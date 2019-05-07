//
//  Constant.swift
//  ClientTwitter
//
//  Created by mac on 5/7/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

public struct Constant {
    static let searchPlaceholder = "Search Twitter"
    static let dateFormatDefault = "E MMM dd HH:mm:ss Z yyyy"
    static let dateFormatForTweet = "dd/MM/yy HH:mm"
    static let httpGetMethod = "GET"
    static let httpPostMethod  = "POST"
    static let defaultSearchText = "IOS Developer"
    static func getValidURL(by url: String, amountTweets: Int) -> String {
        return "https://api.twitter.com/1.1/search/tweets.json?q=\(url)&result_type=recent&count=\(amountTweets)"
    }
}
