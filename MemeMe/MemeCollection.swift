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
    private override init() {}

}
