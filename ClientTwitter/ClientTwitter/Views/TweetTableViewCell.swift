//
//  TweetTableViewCell.swift
//  ClientTwitter
//
//  Created by mac on 5/3/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var contentTextLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    
    var tweet: Tweet? {
        didSet {
            guard let avatarImageView = tweet?.profileImageUrl else { return }
            guard let fullNameLabel = tweet?.name else { return }
            guard let screenName = tweet?.screenName else { return }
            guard let contentTextLabel = tweet?.text else { return }
            guard let dataLabel = tweet?.date else { return }
 
            self.avatarImageView.downloaded(from: avatarImageView)
            self.fullNameLabel.text = fullNameLabel
            self.screenName.text = screenName
            self.contentTextLabel.text = contentTextLabel
            self.dataLabel.text = dataLabel
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        avatarImageView.roundedCorners()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
