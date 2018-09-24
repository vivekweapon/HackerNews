//
//  HackerNewsWebviewCell.swift
//  HackerNews
//
//  Created by Vivekananda Cherukuri on 24/09/18.
//  Copyright © 2018 Vivekananda Cherukuri. All rights reserved.
//

import Foundation
import UIKit

class HackerNewsWebViewCell:UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
