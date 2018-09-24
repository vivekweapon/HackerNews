//
//  DetailHackerNewsViewController.swift
//  HackerNews
//
//  Created by Vivekananda Cherukuri on 22/09/18.
//  Copyright © 2018 Vivekananda Cherukuri. All rights reserved.
//

import Foundation
import UIKit

class DetailHackerNewsViewController:UIViewController {
    
    private let refreshControl = UIRefreshControl()

    var newsItem:News! = nil
    var commentsIds : NSArray = []
    var comments : [Comment] = []
    let detailNewsTableView:UITableView = {
       
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            detailNewsTableView.refreshControl = refreshControl
        } else {
            detailNewsTableView.addSubview(refreshControl)
        }
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Comments ...", attributes: nil)
        detailNewsTableView.refreshControl?.beginRefreshing()
        detailNewsTableView.rowHeight = UITableView.automaticDimension
        detailNewsTableView.estimatedRowHeight = 85.0
        detailNewsTableView.delegate = self
        detailNewsTableView.dataSource = self 
        detailNewsTableView.register(DetailNewsHeaderView.self, forHeaderFooterViewReuseIdentifier: "DetailNewsHeder")
        detailNewsTableView.register(HotNewsCommentCell.self, forCellReuseIdentifier: "CommentCell")
        getComments()
        setUpVews()
        
    }
    
    //MARK:Fetching Comments
    func getComments(){
        APIService.sharedInstance.fetchComments(commentsIds: commentsIds as! [Int]) { (success, comments) in
            
        
            var flattenComments = [Any]()
            for comment in comments {
                flattenComments += comment.flattenedComments() as! Array<Any>
            }
            self.comments = flattenComments.compactMap { $0 } as! [Comment]
            self.refreshControl.endRefreshing()
            self.detailNewsTableView.reloadData()
            
            if (!success) {
                // Display error
                let alertView: UIAlertController = UIAlertController.init(title: "Error fetching news",
                                                                          message: "HackerNews Error.",
                                                                          preferredStyle: .alert)
                let dismissButton: UIAlertAction = UIAlertAction.init(title: "OK",
                                                                      style: .default,
                                                                      handler: nil)
                alertView.addAction(dismissButton)
                self.present(alertView, animated: true, completion: nil)
            }
            
        }

    }
    
    //MARK:SETUP
    func setUpVews(){
        self.view.addSubview(detailNewsTableView)
        setUpConstraints()
    }
    
    func setUpConstraints(){
        
        detailNewsTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        detailNewsTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        detailNewsTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        detailNewsTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
}

extension DetailHackerNewsViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailNewsTableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! HotNewsCommentCell
        let comment = comments[indexPath.row]
        cell.set(comment: comment)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = DetailNewsHeaderView()
        header.set(news: self.newsItem)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 140
    }
    
    
}
