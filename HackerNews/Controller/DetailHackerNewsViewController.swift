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
    
    var newsItem:News! = nil
    let detailNewsTableView:UITableView = {
       
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailNewsTableView.delegate = self
        detailNewsTableView.dataSource = self 
        detailNewsTableView.register(DetailNewsHeaderView.self, forHeaderFooterViewReuseIdentifier: "DetailNewsHeder")
        setUpVews()
        
    }
    
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
        return newsItem.commentsIds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "gggggg"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = DetailNewsHeaderView()
        header.set(news: self.newsItem)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    
}
