//
//  HackerNewsViewController.swift
//  HackerNews
//
//  Created by Vivekananda Cherukuri on 21/09/18.
//  Copyright © 2018 Vivekananda Cherukuri. All rights reserved.
//

import UIKit
import Foundation
let maxNumberOfNews = 30

class HackerNewsViewController: UIViewController {
    
    var isDataLoading:Bool=false
    var pageNo:Int=0
    var limit:Int=20
    var offset:Int=0 //pageNo*limit
    var didEndReached:Bool=false
    var indicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)

    
    var latestNews = [News]()
    private let refreshControl = UIRefreshControl()
    private let bottomRefreshControl = UIRefreshControl()

    let hackerNewsTableView:UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var activityIndicator:UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "Top Stories"
        if #available(iOS 10.0, *) {
            hackerNewsTableView.refreshControl = refreshControl
        } else {
            hackerNewsTableView.addSubview(refreshControl)
        }
       
        refreshControl.addTarget(self, action: #selector(refreshHackerTable), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Data ...", attributes: nil)
        hackerNewsTableView.setContentOffset(CGPoint(x: 0, y: hackerNewsTableView.contentOffset.y - 30), animated: false)
        hackerNewsTableView.refreshControl?.beginRefreshing()
        refreshHackerTable(pageNo: 0, limit: 30)
      
        


        hackerNewsTableView.delegate = self
        hackerNewsTableView.dataSource = self
        hackerNewsTableView.backgroundColor = UIColor.clear
        hackerNewsTableView.register(HackerNewsCell.self, forCellReuseIdentifier: "HackerNewsCell")
        hackerNewsTableView.separatorStyle = .none
        self.view.addSubview(hackerNewsTableView)
        hackerNewsTableView.addSubview(activityIndicator)
        setUpConstraints()
      
    }
    
    func setUpConstraints(){
       
        self.hackerNewsTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.hackerNewsTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.hackerNewsTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.hackerNewsTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        self.activityIndicator.centerXAnchor.constraint(equalTo: hackerNewsTableView.centerXAnchor).isActive = true
        self.activityIndicator.bottomAnchor.constraint(equalTo: hackerNewsTableView.bottomAnchor, constant: 30).isActive = true
        self.activityIndicator.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.activityIndicator.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    @objc func refreshHackerTable(pageNo:Int,limit:Int) {
        APIService.sharedInstance.fetchNews(size: maxNumberOfNews, pageNo: self.pageNo) { (success, news) in
            
            if(self.latestNews.count == 0){
                self.latestNews.removeAll()
                self.latestNews = news
                self.hackerNewsTableView.reloadData()
                self.refreshControl.endRefreshing()

            }
            else{

                var indexPathArray = [IndexPath]()
                
                for obj in news {
                   
                    let count = self.latestNews.count - 1
                    let indexPath = IndexPath(item: count + 1, section: 0)
                    indexPathArray.append(indexPath)
                    self.latestNews.append(obj)

                    
                }
                
                
                self.hackerNewsTableView.beginUpdates()
                self.hackerNewsTableView.insertRows(at: indexPathArray, with: .automatic)
                self.hackerNewsTableView.endUpdates()
                self.hackerNewsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                self.activityIndicator.stopAnimating()
                self.hackerNewsTableView.backgroundColor = UIColor.clear

            }
           
            
            
            if (!success) {
                // Display error
                let alertView: UIAlertController = UIAlertController.init(title: "Error fetching news",
                                                                          message: "There was an error fetching the new Hacker News articles. Please make sure you're connected to the internet and try again.",
                                                                          preferredStyle: .alert)
                let dismissButton: UIAlertAction = UIAlertAction.init(title: "OK",
                                                                      style: .default,
                                                                      handler: nil)
                alertView.addAction(dismissButton)
                self.present(alertView, animated: true, completion: nil)
            }
            
        }
    }

}
extension HackerNewsViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return latestNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let hackerNewsCell = hackerNewsTableView.dequeueReusableCell(withIdentifier: "HackerNewsCell", for: indexPath) as! HackerNewsCell
        hackerNewsCell.selectionStyle = .none
        let news = latestNews[indexPath.row]
        hackerNewsCell.set(news: news)
        return hackerNewsCell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailViewController = DetailHackerNewsViewController()
        detailViewController.newsItem = self.latestNews[indexPath.row]
        self.navigationController?.pushViewController(detailViewController, animated: true)
        
    }
    
}
extension HackerNewsViewController:UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        print("scrollViewDidEndDragging")
        if ((hackerNewsTableView.contentOffset.y + hackerNewsTableView.frame.size.height) >= hackerNewsTableView.contentSize.height + 100)
        {
            if !isDataLoading{
                isDataLoading = true
                self.pageNo = self.pageNo+1
                self.offset=self.limit * self.pageNo
             
                self.hackerNewsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
                refreshHackerTable(pageNo: self.pageNo, limit: maxNumberOfNews)
                self.activityIndicator.startAnimating()
                self.hackerNewsTableView.backgroundColor = UIColor.red
                
            }
        }
        
        
    }
}

