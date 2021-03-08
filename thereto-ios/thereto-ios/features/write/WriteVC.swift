import UIKit
import CropViewController
import RxSwift

class WriteVC: BaseVC {
  
  private lazy var writeView = WriteView(frame: self.view.frame)
  private var viewModel = WriteViewModel(
    userDefaults: UserDefaultsUtil(),
    letterService: LetterSerivce(),
    userService: UserService()
  )
  
  private let imagePicker = UIImagePickerController()
  
  
  
  static func instance(user: User? = nil) -> UINavigationController {
    let controller = WriteVC(nibName: nil, bundle: nil)
    if let user = user {
      let friend = Friend(user: user)
      
      controller.viewModel.input.friend.onNext(friend)
    }
    controller.tabBarItem = UITabBarItem(
      title: "write_tab_title".localized, image: UIImage.init(named: "ic_write"),
      selectedImage: UIImage.init(named: "ic_write")
    )
    
    return UINavigationController.init(rootViewController: controller).then {
      $0.modalPresentationStyle = .fullScreen
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(
      self,
      name: UIResponder.keyboardWillShowNotification, object: nil
    )
    NotificationCenter.default.removeObserver(
      self,
      name: UIResponder.keyboardWillHideNotification, object: nil
    )
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.isNavigationBarHidden = true
    view = writeView
    writeView.textField.delegate = self
    imagePicker.delegate = self
    setupKeyboardEvent()
  }
  
  override func bindEvent() {
    writeView.tapBg.rx.event.bind { [weak self] _ in
      self?.writeView.endEditing(true)
    }.disposed(by: disposeBag)
    
    writeView.closeButton.rx.tap.bind { [weak self] in
      self?.dismiss(animated: true, completion: nil)
    }.disposed(by: disposeBag)
    
    writeView.friendButton.rx.tap
      .bind(onNext: self.goToSelectFriend)
      .disposed(by: disposeBag)
    
    writeView.locationButton.rx.tap
      .bind(onNext: self.goToSelectLocation)
      .disposed(by: disposeBag)
    
    writeView.pictureButton.rx.tap
      .bind(onNext: self.showImagePicker)
      .disposed(by: disposeBag)
    
    writeView.pictureImgButton.rx.tap
      .bind(onNext: self.showImagePicker)
      .disposed(by: disposeBag)
  }
  
  override func bindViewModel() {
    writeView.sendButton.rx.tap
      .bind(to: viewModel.input.tapSentButton)
      .disposed(by: disposeBag)
    
    writeView.textField.rx.text.orEmpty
      .bind(to: viewModel.input.message)
      .disposed(by: disposeBag)
    
    viewModel.output.friendName
      .bind(to: writeView.friendButton.rx.title(for: .normal))
      .disposed(by: disposeBag)
    
    viewModel.output.locationName
      .bind(to: writeView.locationButton.rx.title(for: .normal))
      .disposed(by: disposeBag)
    
    viewModel.output.showLoading
      .observeOn(MainScheduler.instance)
      .bind(onNext: self.writeView.showLoading)
      .disposed(by: disposeBag)
    
    viewModel.output.showAlert
      .observeOn(MainScheduler.instance)
      .bind(onNext: self.showAlert)
      .disposed(by: disposeBag)
    
    viewModel.output.showToast
      .observeOn(MainScheduler.instance)
      .bind(onNext: self.writeView.showToast)
      .disposed(by: disposeBag)
    
    viewModel.output.dismiss
      .observeOn(MainScheduler.instance)
      .bind { [weak self] _ in
        self?.dismiss(animated: true, completion: nil)
    }.disposed(by: disposeBag)
  }
  
  private func setupKeyboardEvent() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(onShowKeyboard(notification:)),
      name: UIResponder.keyboardWillShowNotification, object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(onHideKeyboard(notification:)),
      name: UIResponder.keyboardWillHideNotification, object: nil
    )
  }
  
  private func goToSelectFriend() {
    let selectFriendVC = SelectFriendVC.instance().then {
      $0.delegate = self
    }
    
    self.navigationController?.pushViewController(selectFriendVC, animated: true)
  }
  
  private func showImagePicker() {
    AlertUtil.showImagePicker(controller: self, picker: self.imagePicker)
  }
  
  private func goToSelectLocation() {
    let selectLocationVC = SelectLocationVC.instance().then {
      $0.delegate = self
    }
    self.navigationController?.pushViewController(selectLocationVC, animated: true)
  }
  
  private func presentCropViewController(image: UIImage) {
    let cropViewController = CropViewController.init(croppingStyle: .default, image: image)
    
    cropViewController.delegate = self
    cropViewController.aspectRatioLockDimensionSwapEnabled = false
    cropViewController.aspectRatioPreset = .preset4x3
    cropViewController.aspectRatioPickerButtonHidden = true
    cropViewController.aspectRatioLockEnabled = true
    cropViewController.resetButtonHidden = true
    
    present(cropViewController, animated: true, completion: nil)
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

extension WriteVC: CropViewControllerDelegate {
  func cropViewController(
    _ cropViewController: CropViewController,
    didCropToImage image: UIImage,
    withRect cropRect: CGRect,
    angle: Int
  ) {
    cropViewController.dismiss(animated: true) {
      self.viewModel.input.mainImage.onNext(image)
      self.writeView.pictureImgButton.setImage(image, for: .normal)
    }
  }
}

extension WriteVC: SelectFriendDelegate {
  func onSelectFriend(friend: Friend) {
    self.viewModel.input.friend.onNext(friend)
  }
}

extension WriteVC: SelectLocationDelegate {
  func onSelectLocation(location: Location) {
    self.viewModel.input.location.onNext(location)
  }
}

extension WriteVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
  ) {
    picker.dismiss(animated: true, completion: nil)
    if let image = info[.originalImage] as? UIImage {
      self.writeView.pictureButton.isHidden = true
      self.writeView.pictureImgButton.isHidden = false
      self.presentCropViewController(image: image)
    }
  }
}

extension WriteVC: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == "write_placeholder_message".localized {
      textView.text = ""
      textView.textColor = .greyishBrownTwo
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text == "" {
      textView.text = "write_placeholder_message".localized
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

