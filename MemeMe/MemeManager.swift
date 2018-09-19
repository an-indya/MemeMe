//
//  MemeManager.swift
//  MemeMe
//
//  Created by Anindya Sengupta on 2/22/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import UIKit

struct MemeManager {
    static func shareImage (from viewController: UIViewController, for view: UIView, completion: @escaping (UIImage) -> Void) {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            if let imageToShare = UIGraphicsGetImageFromCurrentImageContext() {
                let activityController = UIActivityViewController(activityItems: [imageToShare],
                                                                  applicationActivities: nil)
                activityController.completionWithItemsHandler = { activity, success, items, error in
                    completion(imageToShare)
                }
                UIPresenter.presentViewController(presentedViewController: activityController, from: viewController)
            }
            UIGraphicsEndImageContext()
        }
    }
}
