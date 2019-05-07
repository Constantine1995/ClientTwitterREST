//
//  TweetsTableViewController.swift
//  ClientTwitter
//
//  Created by mac on 5/3/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class TweetsTableViewController: UITableViewController, TwitterViewDelegate {
    
    var apiTwitterService: APITwitterService?
    var searchController: UISearchController!
    private var  tweets: [Tweet] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSearchController()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        
        apiTwitterService = APITwitterService(self)
        apiTwitterService?.getToken()
    }
    
    func displayTweets(tweets: [Tweet]) {
        if tweets.count != 0 {
            self.tweets = tweets
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            
            self.showAlertWithAction(title: "Twitter!", message: "Tweets not found! :(") {
                self.searchBarClear(self.searchController.searchBar)
            }
        }
    }
    
    func displayError(error: NSError) {
        self.showAlert(title: "Error!", message: error.localizedDescription)
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
        cell.tweet = tweets[indexPath.row]
        return cell
    }
}
