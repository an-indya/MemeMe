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

struct PickerItem {
    var itemText: String
    var itemSource: UIImagePickerControllerSourceType?
    var alertActionStyle: UIAlertActionStyle
    
}


