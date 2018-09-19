//
//  NotificationManager.swift
//  MemeMe
//
//  Created by Anindya Sengupta on 2/21/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import UIKit

enum TextFieldTag: Int {
    case topTextField = 1
    case bottomTextField = 2
}

final class KeyboardNotificationManager : NSObject {
    static let shared = KeyboardNotificationManager()
    private override init() {}
    var selectedTextField: TextFieldTag = .topTextField
    var viewController: UIViewController?


    func subscribeToKeyboardNotifications () {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    func unsubscribeFromAllKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension KeyboardNotificationManager {
    @objc func keyboardWillShow(_ notification:Notification) {
        guard let viewController = viewController else {
            return
        }
        if self.selectedTextField == .bottomTextField {
            viewController.view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }

    @objc func keyboardWillHide(_ notification:Notification) {
        guard let viewController = viewController else {
            return
        }
        viewController.view.frame.origin.y = 0
    }

    private func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
}
