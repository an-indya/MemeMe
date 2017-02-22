//
//  UIPresenter.swift
//  MemeMe
//
//  Created by Anindya Sengupta on 2/22/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import UIKit

class UIPresenter {
    static func presentViewController (presentedViewController: UIViewController, from presentingViewController: UIViewController?) {
        if let viewController = presentingViewController {
            DispatchQueue.main.async {
                viewController.present(presentedViewController, animated: true, completion: nil)
            }
        }
    }

    //MARK: - Convenience Methods
    static func resetView (for outletCollection: [UITextField], imageView: UIImageView) {
        imageView.image = nil
        resetTextFields(outletCollection: outletCollection, enabled: false)
    }

    static func resetTextFields(outletCollection: [UITextField], enabled state: Bool) {
        _ = outletCollection.map({ (textField) -> UITextField in
            textField.text = ""
            textField.isEnabled = state
            return textField
        })
    }

    static func setTextFieldAttributes (for outletCollection: [UITextField]) {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let memeTextAttributes:[String:Any] = [NSStrokeColorAttributeName: UIColor.black,
                                               NSForegroundColorAttributeName: UIColor.white,
                                               NSFontAttributeName: UIFont(name: "PermanentMarker", size: 32)!,
                                               NSStrokeWidthAttributeName: 2,
                                               NSParagraphStyleAttributeName: style]
        _ = outletCollection.map({$0.defaultTextAttributes = memeTextAttributes})
    }
}

extension UIPresenter {
    static func presentImagePicker(with imagePicker: UIImagePickerController,
                                   from viewController: UIViewController?,
                                   source: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            if let viewController = viewController as? ViewController {
                imagePicker.delegate = viewController
                imagePicker.sourceType = source
                imagePicker.allowsEditing = false
                presentViewController(presentedViewController: imagePicker, from: viewController)
            }
        }
        else {
            AlertManager.showAlertController(with: .alert, title: Messages.errorTitle.rawValue, message: Messages.notAvailable.rawValue, alertActions: alertActions, presentationHandler: { (controller, animated) in
                UIPresenter.presentViewController(presentedViewController: controller, from: viewController)
            }, actionHandler: nil)
        }
    }
}
