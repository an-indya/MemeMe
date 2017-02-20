//
//  ViewController.swift
//  MemeMe
//
//  Created by Anindya Sengupta on 2/13/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

enum TextFieldTag: Int {
    case topTextField = 1
    case bottomTextField = 2
}

class ViewController: UIViewController {
    
    @IBOutlet weak var memeView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet var textFieldsOutletCollection: [UITextField]!
    @IBOutlet weak var containerView: UIView!

    var selectedTextField: TextFieldTag = .topTextField
    let imagePicker = UIImagePickerController()
    let photoPickerActions = [PickerItem(itemText: "Photo Library", itemSource: .photoLibrary, alertActionStyle: .default),
                              PickerItem(itemText: "Camera", itemSource: .camera, alertActionStyle: .default),
                              PickerItem(itemText: "Cancel", itemSource: nil, alertActionStyle: .destructive)]


    //MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    //MARK: - Keyboard notification subscription and handling
    func subscribeToKeyboardNotifications () {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    func keyboardWillShow(_ notification:Notification) {
        if selectedTextField == .bottomTextField {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }

    func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }

    //MARK: - Event Handlers
    @IBAction func didPressShareButton(_ sender: Any) {
        UIGraphicsBeginImageContextWithOptions(containerView.frame.size, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            containerView.layer.render(in: context)
            if let imageToShare = UIGraphicsGetImageFromCurrentImageContext() {
                let activityController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
                present(activityController, animated: true, completion: nil)
            }
            UIGraphicsEndImageContext()
        }
    }
    
    @IBAction func didTapCameraButton(_ sender: Any) {
        showActionSheet()
    }
    
    @IBAction func didCancel(_ sender: Any) {
        resetView()
    }
    
    @IBAction func didPressBackground(_ sender: Any) {
        _ = textFieldsOutletCollection.map({$0.resignFirstResponder()})
    }
    
    func presentImagePicker(with source: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            imagePicker.delegate = self
            imagePicker.sourceType = source
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else {
            showAlert(message: .notAvailable)
        }
    }

    //MARK: - Convenience Methods
    func resetView () {
        memeView.image = nil
        resetTextFields(enabled: false)
    }

    /// Resets all text fields to their original state and based on parameter enables/disables them
    ///
    /// - Parameter state: If true, the text fields are enabled, else disabled
    func resetTextFields(enabled state: Bool) {
        _ = textFieldsOutletCollection.map({ (textField) -> UITextField in
            textField.text = ""
            textField.isEnabled = state
            return textField
        })
    }
    
    func showAlert(message: Messages) {
        let controller = UIAlertController(title: Messages.errorTitle.rawValue, message: message.rawValue, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }
    
    func showActionSheet () {
        let actionSheet = UIAlertController(title: Messages.choiceTitle.rawValue, message: Messages.choiceText.rawValue, preferredStyle: .actionSheet)
        for action in photoPickerActions {
            actionSheet.addAction(UIAlertAction(title: action.itemText, style: action.alertActionStyle) { [weak self] (axn) in
                if let itemSource = action.itemSource {
                    self?.presentImagePicker(with: itemSource)
                }
            })
        }
        present(actionSheet, animated: true, completion: nil)
    }
}

//MARK: - UIImagePickerControllerDelegate Methods

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeView.image = image
        }
        resetTextFields(enabled: true)
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - UITextFieldDelegate Methods

extension ViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        selectedTextField = textField.tag == topTextField.tag ? .topTextField : .bottomTextField
        return true
    }
}


