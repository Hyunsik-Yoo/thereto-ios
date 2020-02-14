import UIKit

class WriteVC: BaseVC {
    
    private lazy var writeView = WriteView.init(frame: self.view.frame)
    
    private var viewModel = WriteViewModel.init()

    private let imagePicker = UIImagePickerController()
    
    static func instance() -> UINavigationController {
        let controller = WriteVC.init(nibName: nil, bundle: nil)
        
        controller.tabBarItem = UITabBarItem.init(title: "엽서쓰기", image: UIImage.init(named: "ic_write"), selectedImage: UIImage.init(named: "ic_write"))
        
        return UINavigationController.init(rootViewController: controller).then {
            $0.modalPresentationStyle = .fullScreen
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        view = writeView
        imagePicker.delegate = self
    }
    
    override func bindEvent() {
        writeView.closeBtn.rx.tap.bind { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        writeView.friendBtn.rx.tap.bind { [weak self] in
            let selectFriendVC = SelectFriendVC.instance().then {
                $0.delegate = self
            }
            self?.navigationController?.pushViewController(selectFriendVC, animated: true)
        }.disposed(by: disposeBag)
        
        writeView.locationBtn.rx.tap.bind { [weak self] in
            let selectLocationVC = SelectLocationVC.instance().then {
                $0.delegate = self
            }
            self?.navigationController?.pushViewController(selectLocationVC, animated: true)
        }.disposed(by: disposeBag)
        
        writeView.pictureBtn.rx.tap.bind { [weak self] in
            if let vc = self {
                AlertUtil.showImagePicker(controller: vc, picker: vc.imagePicker)
            }
        }.disposed(by: disposeBag)
        
        writeView.pictureImgBtn.rx.tap.bind { [weak self] in
            if let vc = self {
                AlertUtil.showImagePicker(controller: vc, picker: vc.imagePicker)
            }
        }.disposed(by: disposeBag)
    }
}

extension WriteVC: SelectFriendDelegate {
    func onSelectFriend(friend: Friend) {
        self.writeView.friendBtn.setTitle("\(friend.nickname) (\(friend.name))", for: .normal)
    }
}

extension WriteVC: SelectLocationDelegate {
    func onSelectLocation(location: Location) {
        self.writeView.locationBtn.setTitle("\(location.name!) (\(location.addr!))", for: .normal)
    }
}

extension WriteVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.viewModel.mainImg.onNext(image)
            self.writeView.pictureBtn.isHidden = true
            self.writeView.pictureImgBtn.isHidden = false
            self.writeView.pictureImgBtn.setImage(image, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

