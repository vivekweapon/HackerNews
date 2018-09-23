//
//  APIService.swift
//  HackerNews
//
//  Created by Vivekananda Cherukuri on 21/09/18.
//  Copyright © 2018 Vivekananda Cherukuri. All rights reserved.
//

import UIKit
import Alamofire

let baseURLString = "https://hacker-news.firebaseio.com/v0/"

class APIService: NSObject {
    
    // Singleton creation
    static let sharedInstance = APIService()
    private override init() {} // Prevents outside calling of init
    
    // Fetch top stories
    public func fetchNews(size: Int, pageNo:Int,completionHandler: @escaping (Bool, NSArray) -> Void) {
        
        Alamofire.request(baseURLString + "topstories.json").responseJSON { response in
            if let topstoriesJSON = response.result.value as? NSArray {
                
               completionHandler(true,topstoriesJSON)
            } else {
                completionHandler(false, [])
            }
        }
    }
    
    func getIndividualNews(newsIdArray:NSArray,size:Int,pageNo:Int,completionHandler: @escaping (Bool, [News]) -> Void){
       
        let newsGroup = DispatchGroup()
        var returnNews : [News] = []
        let numberOfNews = newsIdArray.count > size ? size : newsIdArray.count
        let subArrayNews = newsIdArray.subarray(with: NSRange(location: pageNo * size, length: numberOfNews)) as NSArray
        
        for news in subArrayNews {
            newsGroup.enter()
            
            Alamofire.request(baseURLString + "item/\(news).json").responseJSON { response in
                if let newsJSON = response.result.value as? NSDictionary {
                    let newsObject = News.init(json: newsJSON)
                    returnNews.append(newsObject)
                }
                newsGroup.leave()
            }
        }
        
        newsGroup.notify(queue: .main) {
            
            completionHandler(true, returnNews)
        }
    }
    

    // Fetch comments
    public func fetchComments(commentsIds: [Int], completionHandler: @escaping (Bool, [Comment]) -> Void) {
        
        var returnComments : [Comment] = []
        
        let commentsGroup = DispatchGroup()
        for commentId in commentsIds {
            commentsGroup.enter()
            
            Alamofire.request(baseURLString + "item/\(commentId).json").responseJSON { response in
                if let commentJSON = response.result.value as? NSDictionary {
                    let commentObject = Comment.init(json: commentJSON)
                    commentObject.getComments(completionHandler: { (success) in
                        returnComments.append(commentObject)
                        commentsGroup.leave()
                    })
                } else {
                    commentsGroup.leave()
                }
            }
        }
        
        commentsGroup.notify(queue: .main) {
            returnComments.sort {a, b in
                commentsIds.index(of: a.id!)! < commentsIds.index(of: b.id!)!
            }
            
            completionHandler(true, returnComments)
        }
        
    }
}
