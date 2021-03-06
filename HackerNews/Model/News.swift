//
//  News
//  HackerNews
//
//  Created by Vivekananda Cherukuri on 21/09/18.
//  Copyright © 2018 Vivekananda Cherukuri. All rights reserved.
//

import UIKit

class News: NSObject {
    var id:    Int?
    var title: String?
    var score: Int?
    var by:    String?
    var time:  NSDate?
    var url:   URL?
    var commentsIds : NSArray = []
    var numberOfComments: Int? = 0
    
    convenience init(json: NSDictionary) {
        self.init()
        id       = json.value(forKey: "id")    as? Int
        title    = json.value(forKey: "title") as? String
        score    = json.value(forKey: "score") as? Int
        by       = json.value(forKey: "by")    as? String
        
        if let timeString = json.value(forKey: "time") as? Int {
            let date = NSDate(timeIntervalSince1970: TimeInterval(timeString))
            time = date
        }
        
        if let urlString = json.value(forKey: "url") as? String {
            url = URL(string: urlString)
        } else {
            url = URL(string: "https://news.ycombinator.com/item?id=" + String(describing: id!))
        }
        if let comments = json.value(forKey: "kids") as? NSArray {
            commentsIds = comments
            numberOfComments = comments.count
        }
    }
}
