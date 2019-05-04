//
//  TweetTableViewCell.swift
//  ClientTwitter
//
//  Created by mac on 5/3/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell, TwitterImageDelegate {
    
    private var tweetPresenter: TweetPresenter?
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var referenceCreated: UILabel!
    @IBOutlet weak var contentTextLabel: UILabel!
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var dataLabel: UILabel!
    
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tweetPresenter = TweetPresenter(twitterImage: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateUI() {
        print("it works")
        
        if let profileImageUrl = tweet?.profileImageUrl {
            let url = URL(string: profileImageUrl)
            
            let request = URLRequest(url: url!)
            let networkProcessor = NetworkProcessing(request: request)
            networkProcessor.downloadData { [weak self] (imageData, httpResponse, error) in
                DispatchQueue.main.async {
                    if let imageData = imageData {
                        self?.avatarImageView.image = UIImage(data: imageData)
                    }
                }
                
            }
            
            //            let url = URL(string: profileImageUrl)
            //
            //            let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            //                if let error = error {
            //                    print(error)
            //                }
            //                else if let data = data {
            //                    do {
            //                        DispatchQueue.main.async {
            //                            let image = UIImage(data: data)
            //                            self.avatarImageView.image = image
            //                            print("temp",  image)
            //                        }
            //
            //                    } catch (let error) {
            //                        print(error)
            //                    }
            //                }
            //            }
            //            dataTask.resume()
        }
    }
    
    func displayImage(image: UIImage) {
        self.avatarImageView.image = image
        print("TestDelegateWorks")
        
    }
    
}
