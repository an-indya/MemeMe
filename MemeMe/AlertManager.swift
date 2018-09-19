//
//  Utilities.swift
//  MemeMe
//
//  Created by Anindya Sengupta on 2/21/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import UIKit

struct AlertManager {
    static func showAlertController (with style: UIAlertController.Style,
                                     title: String,
                                     message: String,
                                     alertActions: [ActionItem],
                                     presentationHandler: (UIViewController, Bool) -> Void,
                                     actionHandler: ((UIImagePickerController.SourceType) -> Void)?) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: style)
        for action in alertActions {
            alertController.addAction(
                UIAlertAction(title: action.itemText.rawValue, style: action.alertActionStyle) { (_) in
                    if let itemSource = action.itemSource {
                        guard let actionHandler = actionHandler else {
                            return
                        }
                        actionHandler(itemSource)
                    }
            })
        }
        presentationHandler(alertController, true)
    }
}
