//
//  HackerNewsViewController.swift
//  HackerNews
//
//  Created by Vivekananda Cherukuri on 21/09/18.
//  Copyright © 2018 Vivekananda Cherukuri. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift
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
        self.view.backgroundColor = UIColor.white
        
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
        
        let realm = RealmService.shared.realm
        let array = realm.objects(NewsObject.self)
        
        for obj in array {
            RealmService.shared.delete(obj)
        }
      
        //fetch hot news when view is loaded
        APIService.sharedInstance.fetchNews(size: 30, pageNo: 0) { (sucess, storiesArray) in
            
            for (_, news) in storiesArray.enumerated(){
                let id = NewsObject(id: news )
                RealmService.shared.create(id)

            }
        
            self.fetchHackerNews()

        }
        
        hackerNewsTableView.delegate = self
        hackerNewsTableView.dataSource = self
        hackerNewsTableView.backgroundColor = UIColor.clear
        hackerNewsTableView.register(HackerNewsCell.self, forCellReuseIdentifier: "HackerNewsCell")
        hackerNewsTableView.separatorStyle = .none
        self.view.addSubview(hackerNewsTableView)
        self.view.addSubview(activityIndicator)
        setUpConstraints()
      
    }
    
    func setUpConstraints(){
        self.hackerNewsTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.hackerNewsTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.hackerNewsTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.hackerNewsTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.activityIndicator.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.activityIndicator.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    //refresh while draging tableview from top
    @objc func refreshHackerTable(){
        
        let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        
        // get the date time String from the date object
        formatter.string(from: currentDateTime)
        let dateButton : UIBarButtonItem = UIBarButtonItem(title: formatter.string(from: currentDateTime), style: UIBarButtonItem.Style.plain, target: self, action: Selector(""))

        self.navigationItem.rightBarButtonItem = dateButton

        hackerNewsTableView.setContentOffset(CGPoint(x: 0, y: hackerNewsTableView.contentOffset.y - 30), animated: false)

        APIService.sharedInstance.fetchNews(size: 30, pageNo: 0) { (sucess, storiesArray) in
            self.refreshControl.endRefreshing()
            var newStoriesArray = [Any]()
            
            for newStory in storiesArray {
                newStoriesArray.append(newStory)
            }
            
            let realm = RealmService.shared.realm//realm object.
            let array = realm.objects(NewsObject.self)//objects synced already using realm.

            var realmArray = [Int]()
            
            for obj in array {
                realmArray.append(obj.id.value!)
            }
            
            //get unique id that are not present in realm database.
            let uniqueStoriesArray = Array(Set(realmArray).subtracting(Set(storiesArray)))

            //if no unique items dont make api call.
            if(uniqueStoriesArray.count == 0){
                return
            } else {
               
                //make an api call and get data only for unique ids present in result array.
                APIService.sharedInstance.getIndividualNews(newsIdArray: uniqueStoriesArray as NSArray, size: uniqueStoriesArray.count, pageNo:0) { (success, news) in
                    
                    var indexPathArray = [IndexPath]()
                    var  i = 0
                    
                    for obj in news {
                        let indexPath = IndexPath(item: i, section: 0)
                        indexPathArray.append(indexPath)
                        self.latestNews.append(obj)
                        i += 1
                    }
                    
                    self.hackerNewsTableView.beginUpdates()
                    self.hackerNewsTableView.insertRows(at: indexPathArray, with: .automatic)
                    self.hackerNewsTableView.endUpdates()
                    self.hackerNewsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                    self.activityIndicator.stopAnimating()
                    self.hackerNewsTableView.backgroundColor = UIColor.clear
                    
                    if (!success) {
                        // Display error
                     self.displayAlert()
                    }
                }
            }
        }
    }
    
    
    //Initial fetch for HackerNews.
        func fetchHackerNews() {
       
        let idArray = getSavedIds()

            APIService.sharedInstance.getIndividualNews(newsIdArray: idArray, size: 30, pageNo: self.pageNo) { (success, news) in
            
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
            
            if (!success) {
                // Display error
                self.displayAlert()
            }
        }
  
    }
    
    //Getmore hackernes whileswiping up for more news.
    func getMoreNews(pageNo:Int,size:Int){
        
        let idArray = getSavedIds()

        APIService.sharedInstance.getIndividualNews(newsIdArray: idArray, size: 30, pageNo: self.pageNo) { (success, news) in
            
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
            
            if (!success) {
               self.displayAlert()
            }
            
        }
    }
    
    func displayAlert(){
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
    
    func getSavedIds()->NSArray {
        let realm = RealmService.shared.realm
        let array = realm.objects(NewsObject.self)
        
        
        var realmArray = [Any]()
        
        for obj in array {
            realmArray.append(obj.id.value!)
        }
        
        return realmArray as NSArray
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
        detailViewController.commentsIds = self.latestNews[indexPath.row].commentsIds
        self.navigationController?.pushViewController(detailViewController, animated: true)
        
    }
    
}
extension HackerNewsViewController:UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        print("scrollViewWillBeginDragging")
        refreshControl.beginRefreshing()
        self.refreshHackerTable()
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
                self.getMoreNews(pageNo:self.pageNo,size:30)

                self.activityIndicator.startAnimating()
                self.hackerNewsTableView.backgroundColor = UIColor.red
            }
        }
    }
}

