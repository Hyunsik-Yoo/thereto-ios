import UIKit

class WriteVC: BaseVC {
    
    private lazy var writeView = WriteView.init(frame: self.view.frame)
    
    private var viewModel = WriteViewModel.init()

    private let imagePicker = UIImagePickerController()
    
    private var myInfo: User!
    
    
    static func instance() -> UINavigationController {
        let controller = WriteVC.init(nibName: nil, bundle: nil)
        
        controller.tabBarItem = UITabBarItem.init(title: "엽서쓰기", image: UIImage.init(named: "ic_write"), selectedImage: UIImage.init(named: "ic_write"))
        
        return UINavigationController.init(rootViewController: controller).then {
            $0.modalPresentationStyle = .fullScreen
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        view = writeView
        writeView.textField.delegate = self
        imagePicker.delegate = self
        getMyInfo()
        setupKeyboardEvent()
    }
    
    override func bindEvent() {
        writeView.tapBg.rx.event.bind { [weak self] _ in
            self?.writeView.endEditing(true)
        }.disposed(by: disposeBag)
        
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
        
        writeView.sendBtn.rx.tap.bind { [weak self] in
            self?.sendLetter()
        }.disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
        viewModel.friend.bind { [weak self] (friend) in
            if let friend = friend {
                self?.writeView.friendBtn.setTitle("\(friend.nickname) (\(friend.name))", for: .normal)
            }
        }.disposed(by: disposeBag)
        
        viewModel.location.bind { [weak self] (location) in
            if let location = location {
                self?.writeView.locationBtn.setTitle("\(location.name!) (\(location.addr!))", for: .normal)
            }
        }.disposed(by: disposeBag)
    }
    
    private func getMyInfo() {
        writeView.startLoading()
        UserService.getMyUser { [weak self] (user) in
            self?.myInfo = user
            self?.writeView.stopLoading()
        }
    }
    
    private func setupKeyboardEvent() {
        NotificationCenter.default.addObserver(self, selector: #selector(onShowKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onHideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func sendLetter() {
        let photo = try! viewModel.mainImg.value()
        LetterSerivce.saveLetterPhoto(image: photo, name: "test") { [weak self] (result) in
            if let vc = self {
                switch result {
                case .success(let url):
                    let letter = Letter.init(from: vc.myInfo,
                                             to: try! vc.viewModel.friend.value()!,
                                             location: try! vc.viewModel.location.value()!,
                                             photo: url,
                                             message: vc.writeView.textField.text!)
                    LetterSerivce.sendLetter(letter: letter) {
                        AlertUtil.showWithCancel(message: "엽서 보내기 성공") {
                            vc.dismiss(animated: true, completion: nil)
                        }
                    }
                case .failure(let error):
                    AlertUtil.show(controller: vc, title: "사진 저장 오류", message: error.localizedDescription)
                }
            }
        }
    }
    
    @objc func onShowKeyboard(notification: NSNotification) {
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.writeView.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.writeView.scrollView.contentInset = contentInset
    }
    
    @objc func onHideKeyboard(notification: NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        
        self.writeView.scrollView.contentInset = contentInset
    }
}

extension WriteVC: SelectFriendDelegate {
    func onSelectFriend(friend: Friend) {
        self.viewModel.friend.onNext(friend)
    }
}

extension WriteVC: SelectLocationDelegate {
    func onSelectLocation(location: Location) {
        self.viewModel.location.onNext(location)
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

extension WriteVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "내용을 입력해주세요." {
            textView.text = ""
            textView.textColor = .greyishBrownTwo
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "내용을 입력해주세요."
            textView.textColor = .mushroom
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let textFieldText = textView.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + text.count
        
        return count <= 100
    }
}

