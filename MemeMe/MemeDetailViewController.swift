//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Anindya Sengupta on 2/24/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var memeImageView: UIImageView!
    var meme: Meme?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let meme = meme else {
            return
        }
        memeImageView.image = meme.memedImage
    }

}
