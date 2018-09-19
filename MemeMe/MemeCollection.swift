//
//  MemeCollection.swift
//  MemeMe
//
//  Created by Anindya Sengupta on 2/23/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation

final class MemeCollection : NSObject {
    static let shared = MemeCollection()
    var memeCollection = [Meme]()

    private override init() {
        //Mock
        memeCollection = [Meme(topText: "Waterfall model", bottomText: "is scenic!!!", originalImage: #imageLiteral(resourceName: "sample"), memedImage: #imageLiteral(resourceName: "sample"), createdOn: Date()), Meme(topText: "Odd man", bottomText: "Out!", originalImage: #imageLiteral(resourceName: "sample2"), memedImage: #imageLiteral(resourceName: "sample2"), createdOn: Date())]
    }

}
