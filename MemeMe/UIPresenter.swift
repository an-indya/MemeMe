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

        let memeTextAttributes:[String:Any] = [convertFromNSAttributedStringKey(NSAttributedString.Key.strokeColor): UIColor.black,
                                               convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.yellow,
                                               convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: "PermanentMarker", size: 32)!,////https://fonts.google.com/specimen/Permanent+Marker (Free and Opensource)
                                               convertFromNSAttributedStringKey(NSAttributedString.Key.strokeWidth): -4.0,
                                               convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): style]
        _ = outletCollection.map({$0.defaultTextAttributes = convertToNSAttributedStringKeyDictionary(memeTextAttributes)})
    }
}

extension UIPresenter {
    static func presentImagePicker(with imagePicker: UIImagePickerController,
                                   from viewController: UIViewController?,
                                   source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            if let viewController = viewController as? MemeViewController {
                imagePicker.delegate = viewController
                imagePicker.sourceType = source
                imagePicker.allowsEditing = true
                presentViewController(presentedViewController: imagePicker, from: viewController)
            }
        }
        else {
            AlertManager.showAlertController(with: .alert,
                                             title: Messages.errorTitle.rawValue,
                                             message: Messages.notAvailable.rawValue,
                                             alertActions: alertActions,
                                             presentationHandler: { (controller, animated) in
                UIPresenter.presentViewController(presentedViewController: controller, from: viewController)},
                                             actionHandler: nil)
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
