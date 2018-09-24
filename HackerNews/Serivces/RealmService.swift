//
//  RealmService.swift
//  HackerNews
//
//  Created by Vivekananda Cherukuri on 23/09/18.
//  Copyright © 2018 Vivekananda Cherukuri. All rights reserved.
//

import Foundation
import RealmSwift



class RealmService {
    private init() {}
    static let shared = RealmService()
    var realm = try! Realm()
    
    func create<T:Object>(_ object:T){
        do {
            try realm.write {
                realm.add(object)
            }
        }
        catch {}
        
    }
    
    func update<T:Object>(_ object:T, with dictionary: [String:Any?]){
        do {
            try realm.write {
                for(key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        }
        catch {}
    }
    
    func delete<T:Object>(_ object:T){
        
        do {
            try realm.write {
                realm.delete(object)
            }
        }
        catch {}
    }
    
}
