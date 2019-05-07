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
    
    typealias ActionHandler = () -> Void
    
    // MARK: - UISearchBarDelegate
    
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
    
    func searchBarClear(_ searchBar: UISearchBar) {
        searchBar.placeholder = Constant.searchPlaceholder
        apiTwitterService?.searchText = searchBar.text
    }
    
    private func setSearchbarPlaceholder(_ searchBar: UISearchBar) {
        searchBar.placeholder = apiTwitterService?.searchText
    }
    
    // MARK: - Custom UIAlertControllers
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertWithAction(title: String, message: String, completion: @escaping ActionHandler ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion()
        })
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
