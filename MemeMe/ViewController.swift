//
//  ViewController.swift
//  MemeMe
//
//  Created by Anindya Sengupta on 2/13/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var memeView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet var textFieldsOutletCollection: [UITextField]!
    @IBOutlet weak var containerView: UIView!

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
        UIGraphicsBeginImageContextWithOptions(containerView.frame.size, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            containerView.layer.render(in: context)
            if let imageToShare = UIGraphicsGetImageFromCurrentImageContext() {
                let activityController = UIActivityViewController(activityItems: [imageToShare],
                                                                  applicationActivities: nil)
                activityController.completionWithItemsHandler = {[weak self] activity, success, items, error in
                    self?.save(memedImage: imageToShare)
                }
                UIPresenter.presentViewController(presentedViewController: activityController, from: self)
            }
            UIGraphicsEndImageContext()
        }
    }

    @IBAction func didTapCameraButton(_ sender: Any) {
        AlertManager.showAlertController(with: .actionSheet,
                                         title: Messages.choiceTitle.rawValue,
                                         message: Messages.choiceText.rawValue,
                                         alertActions: pickerActions,
                                         presentationHandler: {[weak self](viewController, animated) in
                                            UIPresenter.presentViewController(presentedViewController: viewController, from: self)},
                                         actionHandler: {[weak self](sourceType) in
                                            guard let weakSelf = self else { return }
                                            UIPresenter.presentImagePicker(with: weakSelf.imagePicker, from: self, source: sourceType)
        })
    }

    @IBAction func didCancel(_ sender: Any) {
        UIPresenter.resetView(for: textFieldsOutletCollection, imageView: memeView)
    }

    @IBAction func didPressBackground(_ sender: Any) {
        _ = textFieldsOutletCollection.map({$0.resignFirstResponder()})
    }

    func save(memedImage: UIImage) {
        // Create the meme
        let _ = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: memeView.image!, memedImage: memedImage)
    }

}

//MARK: - UIImagePickerControllerDelegate Methods

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeView.image = image
        }
        UIPresenter.resetTextFields(outletCollection: textFieldsOutletCollection, enabled: true)
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - UITextFieldDelegate Methods

extension ViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        notificationManager.selectedTextField = textField.tag == topTextField.tag ? .topTextField : .bottomTextField
        return true
    }
}


