//
//  HotNewsCommentCell.swift
//  HackerNews
//
//  Created by Vivekananda Cherukuri on 23/09/18.
//  Copyright © 2018 Vivekananda Cherukuri. All rights reserved.
//

import Foundation
import UIKit

class HotNewsCommentCell:UITableViewCell {
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setUpViews()
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let bgView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let timeStampLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        label.text = "12 mins ago"
        label.sizeToFit()
        return label
    }()
    
    let userLable:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        label.text = "user01"
        label.sizeToFit()
        return label
    }()
    
    let commentLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        label.text = "This is a top level comment.This is a top level comment.This is a top level comment.This is a top level comment.This is a top level comment.This is a top level comment.This is a top level comment.This is a top level comment.This is a top level comment.This is a top level comment."
        label.numberOfLines = 5
        return label
    }()
    
    func set(comment: Comment) {
        
        let dateFormatter = DateFormatter()
        let timeString = dateFormatter.timeSince(from: comment.time!, numericDates: true)
        
        timeStampLabel.text = timeString
        if let user = comment.by {
            userLable.text  = user
        }
        if let comment = comment.text {
           // commentLabel.//
            commentLabel.attributedText = comment.htmlAttributedString
        }
    }

    
    func setUpViews(){
        
        addSubview(bgView)
        addSubview(timeStampLabel)
        addSubview(userLable)
        addSubview(commentLabel)
        setUpConstraints()
        
    }
    
    func setUpConstraints(){
        
        bgView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        bgView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        bgView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        bgView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        
        timeStampLabel.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 5).isActive = true
        timeStampLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 5).isActive = true
        
        userLable.topAnchor.constraint(equalTo: timeStampLabel.topAnchor).isActive = true
        userLable.leadingAnchor.constraint(equalTo: timeStampLabel.trailingAnchor, constant: 10).isActive = true
        
        commentLabel.topAnchor.constraint(equalTo: timeStampLabel.bottomAnchor, constant: 20).isActive = true
        commentLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 5).isActive = true
        commentLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -5).isActive = true
        commentLabel.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -5).isActive = true
        
    }
}

extension String {
    
    var utfData: Data? {
        return self.data(using: .utf8)
    }
    
    var htmlAttributedString: NSAttributedString? {
        guard let data = self.utfData else {
            return nil
        }
        do {
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
