//
//  TweetPresenter.swift
//  ClientTwitter
//
//  Created by mac on 5/3/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import UIKit
class TweetPresenter {
    var token: String?
    
    weak var twitterViewDeleagte: TwitterDelegate?
    
    init(_ twitterViewDeleagte: TwitterDelegate?) {
        self.twitterViewDeleagte = twitterViewDeleagte
    }
    
    weak var twitterImage: TwitterImageDelegate?
    
    init(twitterImage: TwitterImageDelegate?) {
        self.twitterImage = twitterImage
    }
    
    func requestToken() {
        guard let key = ProcessInfo.processInfo.environment["CUSTOMER_KEY"] else {return}
        guard let secret = ProcessInfo.processInfo.environment["CUSTOMER_SECRET"] else {return}
        
        let bearer = ((key + ":" + secret).data(using: String.Encoding.utf8))!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        guard let url = URL(string: "https://api.twitter.com/oauth2/token") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic " + bearer, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)

        let task = URLSession.shared.dataTask(with: request) {
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
                            self.downloadJSON(content: "Marvel")
                        } else {
                            print("Empty token")
                        }
                    }
                }
                catch (let error) {
                    self.twitterViewDeleagte?.displayError(error: error as NSError)
                }
            }
        }
        task.resume()
    }
    
    func downloadJSON(content: String?) {
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
            
            let dataTask = URLSession.shared.dataTask(with: request) {
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
                                    print("profileImageUrl ", profileImageUrl)
                                    
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "E MMM dd HH:mm:ss Z yyyy"
                                    if let date = dateFormatter.date(from: date) {
                                        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                                        tweetArray.append(Tweet(profileImageUrl: profileImageUrl, name: name, text: text, date: dateFormatter.string(from: date)))
                                        self.downloadData(profileImageUrl)
                                    }
                                    print(tweet)
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
            }
            dataTask.resume()
        }
    }
    
    func downloadData(_ profileImageUrl: String?) {
        guard let profileImageUrl = profileImageUrl else { return }
        let url = URL(string: profileImageUrl)
        
        let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let error = error {
                print(error)
                self.twitterViewDeleagte?.displayError(error: error as NSError)
            }
            else if let data = data {
                do {
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        self.twitterImage?.displayImage(image: image!)
                    }
                } catch (let error) {
                    print(error)
                    self.twitterViewDeleagte?.displayError(error: error as NSError)
                }
            }
        }
        dataTask.resume()
    }
}
