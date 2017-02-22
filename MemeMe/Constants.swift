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

let pickerActions = [ActionItem(itemText: .photoLibrary, itemSource: .photoLibrary, alertActionStyle: .default),
                     ActionItem(itemText: .camera, itemSource: .camera, alertActionStyle: .default),
                     ActionItem(itemText: .cancel, itemSource: nil, alertActionStyle: .destructive)]
let alertActions = [ActionItem(itemText: .ok, itemSource: nil, alertActionStyle: .cancel)]



