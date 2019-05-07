//
//  Extension+TweetsTableViewController.swift
//  ClientTwitter
//
//  Created by mac on 5/6/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import UIKit
extension TweetsTableViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if searchBar == searchController.searchBar {
            searchBar.placeholder = Constant.searchPlaceholder
        }
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar == searchController.searchBar {
            apiTwitterService?.searchText = searchBar.text
            setSearchbarPlaceholder(searchBar)
            apiTwitterService?.getTweets(content: searchBar.text)
            searchController.isActive = false
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        setSearchbarPlaceholder(searchBar)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        setSearchbarPlaceholder(searchBar)
    }
    
    private func setSearchbarPlaceholder(_ searchBar: UISearchBar) {
        searchBar.placeholder = apiTwitterService?.searchText
    }
}
