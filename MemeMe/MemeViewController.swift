//
//  ViewController.swift
//  MemeMe
//
//  Created by Anindya Sengupta on 2/13/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController {

    @IBOutlet weak var memeView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet var textFieldsOutletCollection: [UITextField]!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    weak var delegate: MemeEditorDelegate?

    let imagePicker = UIImagePickerController()
    let notificationManager = KeyboardNotificationManager.shared


    //MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationManager.viewController = self
        UIPresenter.setTextFieldAttributes(for: textFieldsOutletCollection)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationManager.subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        notificationManager.unsubscribeFromAllKeyboardNotifications()
    }

    //MARK: - Event Handlers
    @IBAction func didPressShareButton(_ sender: Any) {
        MemeManager.shareImage(from: self, for: containerView) { [weak self](image) in
            self?.save(memedImage: image)
        }
    }

    @IBAction func didTapCameraButton(_ sender: Any) {
        AlertManager.showAlertController(with: .actionSheet,
                                         title: Messages.choiceTitle.rawValue,
                                         message: Messages.choiceText.rawValue,
                                         alertActions: PickerActionList.generatePickerActions(),
                                         presentationHandler: {[weak self](viewController, animated) in
                                            UIPresenter.presentViewController(presentedViewController: viewController, from: self)},
                                         actionHandler: {[weak self](sourceType) in
                                            guard let weakSelf = self else { return }
                                            UIPresenter.presentImagePicker(with: weakSelf.imagePicker, from: self, source: sourceType)
        })
    }

    @IBAction func didCancel(_ sender: Any) {
        UIPresenter.resetView(for: textFieldsOutletCollection, imageView: memeView)
        shareButton.isEnabled = false
        self.dismiss(animated: true) {[weak self] in
            self?.delegate?.didFinishEditingMeme()
        }
    }

    @IBAction func didPressBackground(_ sender: Any) {
        _ = textFieldsOutletCollection.map({$0.resignFirstResponder()})
    }

    func save(memedImage: UIImage) {
        // Create the meme
        if let topText = topTextField.text,
            let bottomText = bottomTextField.text,
            let originalImage = memeView.image {
            let meme = Meme(topText: topText, bottomText: bottomText, originalImage: originalImage, memedImage: memedImage, createdOn: Date())
            MemeCollection.shared.memeCollection.append(meme)
        }
        else {
            AlertManager.showAlertController(with: .alert, title: Messages.errorTitle.rawValue, message: Messages.textMissing.rawValue, alertActions: alertActions, presentationHandler: { [weak self](viewController, animated) in
                UIPresenter.presentViewController(presentedViewController: viewController, from: self)
            }, actionHandler: nil)
        }
    }
}

//MARK: - UIImagePickerControllerDelegate Methods

extension MemeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            memeView.image = image
        }
        UIPresenter.resetTextFields(outletCollection: textFieldsOutletCollection, enabled: true)
        shareButton.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - UITextFieldDelegate Methods

extension MemeViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        notificationManager.selectedTextField = textField.tag == topTextField.tag ? .topTextField : .bottomTextField
        return true
    }
}

protocol MemeEditorDelegate : class {
    func didFinishEditingMeme ()
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
