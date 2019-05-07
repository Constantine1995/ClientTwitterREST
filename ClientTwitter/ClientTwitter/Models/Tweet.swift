//
//  Tweet.swift
//  ClientTwitter
//
//  Created by mac on 5/3/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
public struct TweetAPIResponse {
    static let token = "access_token"
    static let statuses = "statuses"
    static let user = "user"
    static let profileImageUrl = "profile_image_url_https"
    static let name = "name"
    static let screenName = "screen_name"
    static let text = "text"
    static let date = "created_at"
}

public struct Tweet {
    public let profileImageUrl: String?
    public let name: String
    public let screenName: String!
    public let text: String!
    public let date: String!
}
