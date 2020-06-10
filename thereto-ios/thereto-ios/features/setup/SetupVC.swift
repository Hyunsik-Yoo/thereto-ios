import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import CropViewController

class SetupVC: BaseVC {
    
    private lazy var setupView = SetupView.init(frame: self.view.frame)
    
    private var viewModel = SetupViewModel(userService: UserService(),
                                           userDefaults: UserDefaultsUtil())
    
    private let imagePicker = UIImagePickerController()
    
    static func instance() -> UINavigationController {
        let controller = SetupVC.init(nibName: nil, bundle: nil)
        
        controller.tabBarItem = UITabBarItem.init(title: "설정", image: UIImage.init(named: "ic_setting_off"), selectedImage: UIImage.init(named: "ic_setting_on"))
        return UINavigationController.init(rootViewController: controller)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = setupView
        setupNavigation()
        setupTableView()
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchMyInfo()
    }
    
    override func bindViewModel() {
        viewModel.output.profile.bind { [weak self] (profileURL) in
            guard let self = self else { return }
            self.setupView.profileImg.kf.setImage(with: URL(string: profileURL)!, for: .normal)
        }.disposed(by: disposeBag)
        viewModel.output.userInfo.bind(onNext: setupView.bind(user:))
            .disposed(by: disposeBag)
        viewModel.output.showLoading.bind(onNext: setupView.showLoading(isShow:))
            .disposed(by: disposeBag)
        viewModel.output.showAlert.bind { [weak self] (title, message) in
            guard let self = self else { return }
            AlertUtil.show(controller: self, title: title, message: message)
        }.disposed(by: disposeBag)
        viewModel.output.goToSignIn.bind(onNext: goToSignIn)
            .disposed(by: disposeBag)
    }
    
    override func bindEvent() {
        setupView.profileImg.rx.tap.bind { [weak self] (_) in
            guard let self = self else { return }
            AlertUtil.showImagePicker(controller: self, picker: self.imagePicker)
        }.disposed(by: disposeBag)
    }
    
    private func setupNavigation() {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupTableView() {
        setupView.tableView.delegate = self
        setupView.tableView.dataSource = self
        setupView.tableView.register(SetupCell.self, forCellReuseIdentifier: SetupCell.registerId)
    }
    
    private func goToSignIn() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.goToSignIn()
        }
    }
    
    private func presentCropViewController(image: UIImage) {
        let cropViewController = CropViewController.init(croppingStyle: .default, image: image)
        
        cropViewController.delegate = self
        cropViewController.aspectRatioLockDimensionSwapEnabled = false
        cropViewController.aspectRatioPreset = .presetSquare
        cropViewController.aspectRatioPickerButtonHidden = true
        cropViewController.aspectRatioLockEnabled = true
        cropViewController.resetButtonHidden = true
        
        present(cropViewController, animated: true, completion: nil)
    }
}

extension SetupVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SetupCell.registerId, for: indexPath) as? SetupCell else {
            return BaseTableViewCell()
        }
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "로그아웃"
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: // 로그아웃
            AlertUtil.showWithCancel(title: "로그아웃", message: "로그아웃하시겠습니까?") { [weak self] in
                self?.viewModel.input.logout.onNext(())
            }
        default:
            break
        }
    }
}

extension SetupVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            self.presentCropViewController(image: image)
        }
    }
}

extension SetupVC: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true) {
            self.viewModel.input.profileImage.onNext(image)
        }
    }
}

