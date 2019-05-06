//
//  TweetsTableViewController.swift
//  ClientTwitter
//
//  Created by mac on 5/3/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class TweetsTableViewController: UITableViewController, TwitterViewDelegate {
    
    private var apiTwitterService: APITwitterService?
    private var  token: String?
    private var  tweets: [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = 300 //UITableView.automaticDimension
        apiTwitterService = APITwitterService(self)
        
        apiTwitterService?.getToken()
    }
    
    func displayTweets(tweets: [Tweet]) {
        for tweet in tweets {
            print(tweet)
        }
        self.tweets = tweets
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func displayError(error: NSError) {
        print("Error: ", error)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  tweets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        let urlProfileImage = tweets[indexPath.row].profileImageUrl
        cell.fullNameLabel.text = tweets[indexPath.row].name
        cell.dataLabel.text = tweets[indexPath.row].date
        cell.contentTextLabel.text = tweets[indexPath.row].text
        cell.avatarImageView.downloaded(from: urlProfileImage!)
        return cell
    }
}
