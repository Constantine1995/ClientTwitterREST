//
//  TweetsTableViewController.swift
//  ClientTwitter
//
//  Created by mac on 5/3/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class TweetsTableViewController: UITableViewController, TwitterViewDelegate {
    
    internal var apiTwitterService: APITwitterService?
    private var  token: String?
    private var  tweets: [Tweet] = []
    
    var searchController: UISearchController!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSearchController()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        
        apiTwitterService = APITwitterService(self)
        apiTwitterService?.getToken()
    }

    func displayTweets(tweets: [Tweet]) {
        self.tweets = tweets
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func displayError(error: NSError) {
        print("Error: ", error)
    }
    
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = Constant.searchPlaceholder
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.delegate = self
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  tweets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        let urlProfileImage = tweets[indexPath.row].profileImageUrl
        cell.fullNameLabel.text = tweets[indexPath.row].name
        cell.screenName.text = tweets[indexPath.row].screenName
        cell.dataLabel.text = tweets[indexPath.row].date
        cell.contentTextLabel.text = tweets[indexPath.row].text
        cell.avatarImageView.downloaded(from: urlProfileImage!)
        return cell
    }
}


