//
//  ProfileViewController.swift
//  audioplayer
//
//  Created Arturo Ventura on 05/02/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import CropViewController

class ProfileViewController: UIViewController,ProfileViewControllerProtocol {
    
    var presenter: ProfilePresenterProtocol?
    var imagePicker = UIImagePickerController()
    var user = User(username: "", name: "", image: "", lastName: "", biography: "")
    var TextFields = [UIView]()
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.addSubview(mainStack)
        scrollView.alwaysBounceVertical = true
        mainStack.fillSuperView(padding: .init(top: 0, left: 0, bottom: 83, right: 0))
        mainStack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        return scrollView
    }()
    
    lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageProfile,
                                                   usernameLabel, usernameTextField,
                                                   nameLabel, nameTextField,
                                                   lastNameLabel, lastNameTextField,
                                                   bibliographyLabel, bibliographyTextView,
                                                   buttonSave])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 8
        
        return stack
    }()
    
    lazy var imageProfile: UIImageView = {
        let image = UIImageView()
        image.anchor(size: CGSize(width: 250, height: 250))
        image.layer.cornerRadius = 125
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .systemGray2
        image.isUserInteractionEnabled = true
        image.clipsToBounds = true
        let gesto = UITapGestureRecognizer(target: self, action: #selector(openGallery))
        image.addGestureRecognizer(gesto)
        return image
    }()
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Username"
        return label
    }()
    lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.tag = 0
        textField.placeholder = "Username"
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.textColor = .white
        textField.backgroundColor = .systemGray2
        textField.anchor(size: CGSize(width: 250, height: 25))
        textField.delegate = self
        return textField
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Name"
        return label
    }()
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.tag = 1
        textField.placeholder = "Name"
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.textColor = .white
        textField.backgroundColor = .systemGray2
        textField.anchor(size: CGSize(width: 250, height: 25))
        textField.delegate = self
        return textField
    }()
    lazy var lastNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Lastname"
        return label
    }()
    lazy var lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.tag = 2
        textField.placeholder = "Lastname"
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.textColor = .white
        textField.backgroundColor = .systemGray2
        textField.anchor(size: CGSize(width: 250, height: 25))
        textField.delegate = self
        return textField
    }()

    lazy var bibliographyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Biography"
        return label
    }()
    
    lazy var bibliographyTextView: UITextView = {
        let textView = UITextView()
        textView.tag = 3
        textView.anchor(size: CGSize(width: 250, height: 250))
        textView.backgroundColor = .systemGray2
        textView.textColor = .white
        textView.layer.cornerRadius = 8
        textView.delegate = self
        return textView
    }()
    
    lazy var buttonSave: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemBlue
        button.setTitle("Save", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(saveButton), for: .touchUpInside)
        button.tintColor = .white
        button.anchor(size: CGSize(width: 250, height: 40))
        return button
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.anchor(size: CGSize(width: 15, height: 15))
        button.backgroundColor = .yellow
        return button
    }()
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.init(named: "MainBackground")
        view.addSubview(scrollView)
        scrollView.insetsLayoutMarginsFromSafeArea = true
        scrollView.fillSuperView()
        TextFields = [usernameTextField,nameTextField,lastNameTextField,bibliographyTextView]
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupHideKeyboardOnTap()
        self.enableKeyBoardToggle()
        presenter?.viewLoaded()
    }
    
    func fillUser(_ user: User) {
        self.user = user
        if !user.image.isEmpty {
            imageProfile.sd_setImage(with: URL(fileURLWithPath: user.completeURLImage), placeholderImage: nil, options: .fromLoaderOnly, completed: nil)
        }
        usernameTextField.text = user.username
        nameTextField.text = user.name
        lastNameTextField.text = user.lastName
        bibliographyTextView.text = user.biography
    }
    
    override func keyboardWillChangeLogic(isShow: Bool, keyboardHeight: CGFloat) {
        scrollView.contentInset = .init(top: 0, left: 0, bottom: keyboardHeight + 10 , right: 0)
        if let vs = getFirstResponder(view: mainStack) {
            let r = scrollView.convert(vs.bounds, from: vs)
            scrollView.scrollRectToVisible(r, animated: true)
        }

    }
    
    @objc func saveButton() {
        presenter?.setUser(user)
    }
    
    @objc func openGallery(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        
        /// Recortar imagen a subir
        let cropViewController = CropViewController(croppingStyle: .circular, image: image)
        
        cropViewController.aspectRatioLockEnabled = true
        cropViewController.customAspectRatio = CGSize(width: 1, height: 1)
        cropViewController.resetButtonHidden = true
        cropViewController.aspectRatioPickerButtonHidden = true
        cropViewController.delegate = self
        
        picker.dismiss(animated:true){
            self.present(cropViewController, animated: true, completion: nil)
        }
        
    }
}
extension ProfileViewController: CropViewControllerDelegate{
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {

    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        presenter?.setImage(image)
        cropViewController.dismiss(animated: true)
    }
    func cropViewController(_ cropViewController: CropViewController, didCropImageToRect rect: CGRect, angle: Int) {
        
    }
}

extension ProfileViewController: UITextFieldDelegate, UITextViewDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let nextTextField = self.TextFields.first(where: {$0.tag == textField.tag + 1}) else {
            textField.resignFirstResponder()
            
            return false
        }
        nextTextField.becomeFirstResponder()
        return false
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        switch textField.tag {
        case 0:
            user.username = newText
        case 1:
            user.name = newText
        case 2:
            user.lastName = newText
        default:
            break
        }
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text! as NSString).replacingCharacters(in: range, with: text)
        user.biography = newText
        return true
    }
}

