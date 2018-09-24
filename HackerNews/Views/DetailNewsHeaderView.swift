//
//  DetailNewsHeaderView.swift
//  HackerNews
//
//  Created by Vivekananda Cherukuri on 23/09/18.
//  Copyright © 2018 Vivekananda Cherukuri. All rights reserved.
//

import Foundation
import UIKit


class DetailNewsHeaderView:UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    var bgView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.orange
        return view
    }()
    
    let topicTitle:UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
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
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue", size: 8.0)
        label.text = "www.w3c.com"
        label.sizeToFit()
        return label
    }()
    
    let timeStampLabel:UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        label.text = "12 mins ago"
        label.sizeToFit()
        return label
        
    }()
    
    let userNameLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        label.text = "user01"
        label.sizeToFit()
        return label
    }()
    
    let saperator:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont(name: "HelveticaNeue", size: 14.0)
        label.text = "*"
        label.sizeToFit()
        return label
    }()
    
    let commentsButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Comments(50)", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)

        return button
    }()
    
    let articleButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Article", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
    
        return button
    }()
    
    func setup(){
        addSubview(bgView)
        bgView.addSubview(topicTitle)
        bgView.addSubview(urlLabel)
        bgView.addSubview(timeStampLabel)
        bgView.addSubview(saperator)
        bgView.addSubview(userNameLabel)
        bgView.addSubview(articleButton)
        bgView.addSubview(commentsButton)
        setupConstraints()
    }
    
    func  setupConstraints(){
        
        bgView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        bgView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        bgView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bgView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
       
        topicTitle.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 10).isActive = true
        topicTitle.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 10).isActive = true
        topicTitle.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -10).isActive = true
        
        urlLabel.topAnchor.constraint(equalTo: topicTitle.bottomAnchor, constant: 5).isActive = true
        urlLabel.leadingAnchor.constraint(equalTo: topicTitle.leadingAnchor).isActive = true
        urlLabel.trailingAnchor.constraint(equalTo:topicTitle.trailingAnchor, constant: 0).isActive = true
        
        timeStampLabel.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant:5).isActive = true
        timeStampLabel.leadingAnchor.constraint(equalTo: urlLabel.leadingAnchor).isActive = true
        
        saperator.leadingAnchor.constraint(equalTo: timeStampLabel.trailingAnchor, constant: 3).isActive = true
        saperator.centerYAnchor.constraint(equalTo: timeStampLabel.centerYAnchor).isActive = true
        
        userNameLabel.leadingAnchor.constraint(equalTo: saperator.trailingAnchor, constant: 3).isActive = true
        userNameLabel.centerYAnchor.constraint(equalTo: saperator.centerYAnchor).isActive = true
        
        let window = UIApplication.shared.keyWindow!

        commentsButton.bottomAnchor.constraint(equalTo: bgView.bottomAnchor).isActive = true
        commentsButton.widthAnchor.constraint(equalToConstant: window.frame.size.width/2).isActive = true
        commentsButton.leadingAnchor.constraint(equalTo: bgView.leadingAnchor).isActive = true
        
        articleButton.bottomAnchor.constraint(equalTo: bgView.bottomAnchor).isActive = true
        articleButton.widthAnchor.constraint(equalToConstant: window.frame.size.width/2).isActive = true
        articleButton.leadingAnchor.constraint(equalTo: commentsButton.trailingAnchor).isActive = true
        
    }
    
    //setup header with news object
    func set(news: News) {
        
        topicTitle.text = news.title!
        
        let dateFormatter = DateFormatter()
        let timeString = dateFormatter.timeSince(from: news.time!, numericDates: true)
        timeStampLabel.text = timeString

        if news.by != nil {
            self.userNameLabel.text = news.by!
        }
        
        self.urlLabel.text =  news.url?.absoluteString
        commentsButton.setTitle("Comments(\(news.commentsIds.count))", for: .normal)
        
    }
}

