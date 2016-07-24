//
//  TwitterClient.swift
//  Swift-Assignment 3
//
//  Created by Huynh Tri Dung on 7/23/16.
//  Copyright © 2016 Huynh Tri Dung. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


class TwitterClient: BDBOAuth1SessionManager {

    static let shareInstance = TwitterClient(baseURL: NSURL(string:"https://api.twitter.com")!, consumerKey: "eCMlAe82BceMijbKSPJpXtPDb", consumerSecret: "UuaUDlJgJWfXDR2SAYYLHzkKJXbZas4n4HzFr4YXBZpP61Wnmd")
    
    
    
    var loginSuccess:(() -> ())?
    var loginFailure:((NSError) -> ())?
    
    
    func homeTimeLine(success: ([Tweet])->(), failure: (NSError)->()) {
        GET("/1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task:NSURLSessionDataTask, response:AnyObject?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetWithArray(dictionaries)
            success(tweets)
            }, failure: { (task:NSURLSessionDataTask?, error:NSError) in
                print("error: \(error.localizedDescription)")
                failure(error)
        })
    }
    
    func homeTimeLineWithParams(count: Int?, maxId: NSNumber?, success: ([Tweet])->(), failure: (NSError)->()) {
        var params = [String : AnyObject]()
        
        if count != nil {
            params["count"] = count!
        }
        
        if maxId != nil {
            params["max_id"] = maxId!
        }
        
        GET("/1.1/statuses/home_timeline.json", parameters: params, progress: nil, success: { (task:NSURLSessionDataTask, response:AnyObject?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetWithArray(dictionaries)
            success(tweets)
            }, failure: { (task:NSURLSessionDataTask?, error:NSError) in
                print("error: \(error.localizedDescription)")
                failure(error)
        })
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("/1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task:NSURLSessionDataTask, response:AnyObject?) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
            
            }, failure: { (task:NSURLSessionDataTask?, error:NSError) in
                print("error\(error.localizedDescription)")
                failure(error)
        })
    }
    
    func updateTweet(text: String, success: (Tweet?)->(), failure: (NSError)->()) {
        var params = [String : AnyObject]()
        params["status"] = text
        POST("/1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let userDictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: userDictionary)
            success(tweet)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print("error\(error.localizedDescription)")
            failure(error)
        }
    }
    
//    func replyTweet(text: String, originalId: NSNumber, completion: (tweet: Tweet?, error: NSError?) -> ()) {
//        
//        var params = [String : AnyObject]()
//        params["status"] = text
//        params["in_reply_to_status_id"] = originalId
//        
//        POST("1.1/statuses/update.json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject!) -> Void in
//            
//            var newTweet = Tweet(dictionary: response as! NSDictionary)
//            completion(tweet: newTweet, error: nil)
//            
//            }, failure: { (operation: NSURLSessionDataTask!, error: NSError!) -> Void in
//                println("error updating new tweet")
//                completion(tweet: nil, error: error)
//        })
//    }
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.shareInstance.deauthorize()
        TwitterClient.shareInstance.fetchRequestTokenWithPath("/oauth/request_token", method: "GET", callbackURL: NSURL(string:"twitterdemo://oauth"), scope: nil, success: { (requestToken:BDBOAuth1Credential!) in
            print("I got a token")
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            
        }) { (error:NSError!) in
            print("error:\(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    func handlerOpenUrl(url:NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken:BDBOAuth1Credential!) in
            self.currentAccount({ (user:User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error:NSError) in
                self.loginFailure?(error)
            })
            
            
        }) { (error:NSError!) in
            print("error\(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
}
