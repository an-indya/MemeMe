//
//  Constants.swift
//  MemeMe
//
//  Created by Anindya Sengupta on 2/14/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

enum Messages: String {
    case errorTitle = "Error"
    case notAvailable = "Camera access is not available"
    case choiceText = "Choose an image from photo library or take a photo"
    case choiceTitle = "Choose a source"
    case textMissing = "Please enter some text"
}

enum AlertButtonText: String {
    case photoLibrary = "Photo Library"
    case camera = "Camera"
    case cancel = "Cancel"
    case ok = "OK"
}

struct ActionItem {
    var itemText: AlertButtonText
    var itemSource: UIImagePickerControllerSourceType?
    var alertActionStyle: UIAlertActionStyle
}

struct PickerActionList {
    static func generatePickerActions () -> [ActionItem] {
        var pickerActions = [ActionItem]()
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            pickerActions.append(ActionItem(itemText: .photoLibrary, itemSource: .photoLibrary, alertActionStyle: .default))
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            pickerActions.append(ActionItem(itemText: .camera, itemSource: .camera, alertActionStyle: .default))
        }
        if pickerActions.count > 0 {
            pickerActions.append(ActionItem(itemText: .cancel, itemSource: nil, alertActionStyle: .destructive))
        }
        return pickerActions
    }
}

let alertActions = [ActionItem(itemText: .ok, itemSource: nil, alertActionStyle: .cancel)]



