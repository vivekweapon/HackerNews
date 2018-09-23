//
//  NewsObject.swift
//  HackerNews
//
//  Created by Vivekananda Cherukuri on 23/09/18.
//  Copyright © 2018 Vivekananda Cherukuri. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class NewsObject:Object {
    
    let id = RealmOptional<Int>()
   
    convenience init(id:Int?){
        self.init()
        self.id.value = id
    }
}
