//
//  TwitterDelegate.swift
//  ClientTwitter
//
//  Created by mac on 5/3/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import UIKit
protocol TwitterViewDelegate: NSObjectProtocol {
    func displayTweets(tweets: [Tweet])
    func displayError(error: NSError)
}
