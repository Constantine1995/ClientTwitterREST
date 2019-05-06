//
//  Extension+UIView.swift
//  ClientTwitter
//
//  Created by mac on 5/6/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func roundedCorners() {
        self.layer.cornerRadius = 5.0
        layer.masksToBounds = true
    }
}
