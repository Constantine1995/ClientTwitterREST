//
//  APITwitterService.swift
//  ClientTwitter
//
//  Created by mac on 5/6/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import UIKit
class APITwitterService {
    
    var token: String?
    weak var twitterViewDeleagte: TwitterViewDelegate?
    
    init(_ twitterViewDeleagte: TwitterViewDelegate?) {
        self.twitterViewDeleagte = twitterViewDeleagte
    }
    
    func getToken() {
        guard let key = ProcessInfo.processInfo.environment["CUSTOMER_KEY"] else {return}
        guard let secret = ProcessInfo.processInfo.environment["CUSTOMER_SECRET"] else {return}
        
        let bearer = ((key + ":" + secret).data(using: String.Encoding.utf8))!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        guard let url = URL(string: "https://api.twitter.com/oauth2/token") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic " + bearer, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                print(error)
                self.twitterViewDeleagte?.displayError(error: error as NSError)
            }
            else if let data = data {
                do {
                    if let dictionary: NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        self.token = dictionary["access_token"] as? String
                        if self.token != nil {
                            self.getTweets(content: "IOS Developer")
                        } else {
                            print("Empty token")
                        }
                    }
                }
                catch (let error) {
                    self.twitterViewDeleagte?.displayError(error: error as NSError)
                }
            }
            }.resume()
    }
    
    func getTweets(content: String?) {
        guard token != nil else {return}
        
        var tweetArray: [Tweet] = []
        let searchQuery = content?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        guard searchQuery != nil else {
            print("ERROR: encoding search query failed!")
            return
        }
        if let url = URL(string: "https://api.twitter.com/1.1/search/tweets.json?q=\(searchQuery!)&result_type=recent&count=50") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                if let error = error {
                    print(error)
                    self.twitterViewDeleagte?.displayError(error: error as NSError)
                }
                else if let data = data {
                    do {
                        if let responseDictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary {
                            if let tweetStatuses = responseDictionary["statuses"] as? [NSDictionary] {
                                for tweet: NSDictionary in tweetStatuses {
                                    guard let user = tweet["user"] as? NSDictionary else { return }
                                    guard let name = user["name"] as? String else { return }
                                    guard let text = tweet["text"] as? String else { return }
                                    guard let date = tweet["created_at"] as? String else { return }
                                    guard let profileImageUrl = user["profile_image_url_https"] as? String else { return }
                                    guard let screenName = user["screen_name"] as? String else { return }
                                    
                                    let dateFormatter = DateFormatter()
                                    
                                    dateFormatter.dateFormat = "E MMM dd HH:mm:ss Z yyyy"
                                    if let date = dateFormatter.date(from: date) {
                                        dateFormatter.dateFormat = "dd/MM/yy HH:mm"
                                        tweetArray.append(Tweet(profileImageUrl: profileImageUrl, name: name, screenName: "@" + screenName, text: text, date: dateFormatter.string(from: date)))
                                    }
                                }
                            }
                        }
                        self.twitterViewDeleagte?.displayTweets(tweets: tweetArray)
                    }
                    catch (let error) {
                        print(error)
                        self.twitterViewDeleagte?.displayError(error: error as NSError)
                    }
                }
         }.resume()
        }
    }
}
