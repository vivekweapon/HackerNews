//
//  HackerNewsCell.swift
//  HackerNews
//
//  Created by Vivekananda Cherukuri on 22/09/18.
//  Copyright © 2018 Vivekananda Cherukuri. All rights reserved.
//

import Foundation
import UIKit

class HackerNewsCell:UITableViewCell {
    
    let cellBackgroundView:UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray
        return view
        
    }()
    
    let topicTitle:UILabel = {
       
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = UIFont(name: "HelveticaNeue", size: 20.0)
        label.text = "Introduction to HTML Components"
        label.sizeToFit()
        return label
        
    }()
    
    let urlLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 89.0/255.0, green: 89.0/255.0, blue: 89.0/255.0, alpha: 1)
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue", size: 8.0)
        label.text = "www.w3c.com"
        label.sizeToFit()
        return label
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
    
    let userNameLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        label.text = "user01"
        label.sizeToFit()
        return label
    }()
    
    let voteCountBackgroundView:UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.orange
        return view
        
    }()
    
    let voteCountLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue", size: 18.0)
        label.text = "41"
        label.sizeToFit()
        return label
    }()
    
    let commentsImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "comments-icon")
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        return imageView
    }()
    
    let numberOfCommentsLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue", size: 14.0)
        label.text = "33"
        label.sizeToFit()
        return label
    }()
    
    let saperator:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue", size: 14.0)
        label.text = "*"
        label.sizeToFit()
        return label
    }()
    
    var news: News?

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setUpViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    //setup cell with news object
    func set(news: News) {
        self.news = news
        
        let dateFormatter = DateFormatter()
        let timeString = dateFormatter.timeSince(from: news.time!, numericDates: true)
        
        timeStampLabel.text = timeString
        
        topicTitle.text = news.title!
        numberOfCommentsLabel.text = String(describing: news.commentsIds.count)
        
        if news.by != nil {
            self.userNameLabel.text = news.by!
        }
       
        self.voteCountLabel.text = "\(String(describing: news.score!))"
        self.urlLabel.text =  news.url?.absoluteString
        
    }

    func setUpViews(){
       
        addSubview(cellBackgroundView)
        cellBackgroundView.addSubview(topicTitle)
        cellBackgroundView.addSubview(urlLabel)
        cellBackgroundView.addSubview(commentsImageView)
        cellBackgroundView.addSubview(numberOfCommentsLabel)
        cellBackgroundView.addSubview(timeStampLabel)
        cellBackgroundView.addSubview(saperator)
        cellBackgroundView.addSubview(userNameLabel)
        cellBackgroundView.addSubview(voteCountBackgroundView)
        cellBackgroundView.addSubview(voteCountLabel)
        setUpConstraints()
        
    }
   
    func setUpConstraints(){
       
        cellBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        cellBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        cellBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        cellBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true 
        
        voteCountBackgroundView.leadingAnchor.constraint(equalTo: cellBackgroundView.leadingAnchor, constant: 0).isActive = true
        voteCountBackgroundView.topAnchor.constraint(equalTo: cellBackgroundView.topAnchor, constant: 0).isActive = true
        voteCountBackgroundView.bottomAnchor.constraint(equalTo: cellBackgroundView.bottomAnchor, constant: 0).isActive = true
        voteCountBackgroundView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        voteCountLabel.centerXAnchor.constraint(equalTo: voteCountBackgroundView.centerXAnchor).isActive = true
        voteCountLabel.centerYAnchor.constraint(equalTo: voteCountBackgroundView.centerYAnchor).isActive = true
        
        topicTitle.leadingAnchor.constraint(equalTo: voteCountBackgroundView.trailingAnchor, constant: 10).isActive = true
        topicTitle.topAnchor.constraint(equalTo: voteCountBackgroundView.topAnchor, constant: 10).isActive = true
        topicTitle.trailingAnchor.constraint(equalTo: commentsImageView.leadingAnchor, constant: -10).isActive = true
        
        commentsImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        commentsImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        commentsImageView.trailingAnchor.constraint(equalTo: cellBackgroundView.trailingAnchor, constant: -30).isActive = true
        commentsImageView.centerYAnchor.constraint(equalTo: cellBackgroundView.centerYAnchor).isActive = true
        
        numberOfCommentsLabel.topAnchor.constraint(equalTo: commentsImageView.bottomAnchor, constant: 10).isActive = true
        numberOfCommentsLabel.centerXAnchor.constraint(equalTo: commentsImageView.centerXAnchor).isActive = true
      
        urlLabel.topAnchor.constraint(equalTo: topicTitle.bottomAnchor, constant: 5).isActive = true
        urlLabel.leadingAnchor.constraint(equalTo: topicTitle.leadingAnchor).isActive = true
        urlLabel.trailingAnchor.constraint(equalTo:commentsImageView.leadingAnchor, constant: -10).isActive = true
        
        timeStampLabel.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant:5).isActive = true
        timeStampLabel.leadingAnchor.constraint(equalTo: urlLabel.leadingAnchor).isActive = true
        
        saperator.leadingAnchor.constraint(equalTo: timeStampLabel.trailingAnchor, constant: 3).isActive = true
        saperator.centerYAnchor.constraint(equalTo: timeStampLabel.centerYAnchor).isActive = true
        
        userNameLabel.leadingAnchor.constraint(equalTo: saperator.trailingAnchor, constant: 3).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: timeStampLabel.topAnchor).isActive = true 
        
        
    }
}
