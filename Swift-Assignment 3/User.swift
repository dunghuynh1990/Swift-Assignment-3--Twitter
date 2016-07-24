//
//  User.swift
//  Swift-Assignment 3
//
//  Created by Huynh Tri Dung on 7/23/16.
//  Copyright © 2016 Huynh Tri Dung. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: NSString?
    var screenName: NSString?
    var profileUrl: NSURL?
    var tagLine: NSString?
    
    var dictionary: NSDictionary?
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? NSString
        screenName = dictionary["screen_name"] as? NSString
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }
        tagLine = dictionary["description"] as? NSString
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                
                defaults.setObject(data, forKey: "currentUserData")
            } else {
                defaults.setObject(nil, forKey: "currentUser")
            }
            defaults.synchronize()  
        }
    }
}
