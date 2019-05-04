//
//  TwitterDelegate.swift
//  ClientTwitter
//
//  Created by mac on 5/3/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import UIKit
protocol TwitterDelegate: NSObjectProtocol {
    func displayTweets(tweets: [Tweet])
//    func displayImage(image: UIImage)
    func displayError(error: NSError)
}
