//
//  Tweet.swift
//  Swift-Assignment 3
//
//  Created by Huynh Tri Dung on 7/23/16.
//  Copyright © 2016 Huynh Tri Dung. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    
    var text : NSString?
    var id : NSNumber?
    
    var timeStamp : NSDate?
    
    var retweetCount : Int = 0
    var favoriteCount : Int = 0
    
    var images = [NSURL]()
    
    var isRetweeted = false
    var isFavorited = false
    
    var replyToStatusId : NSNumber?
    var replyToScreenName : NSString?
    
    var retweet: Tweet?
    
    init(dictionary : NSDictionary){
        text = dictionary["text"] as? NSString
        id = dictionary["id"] as? NSNumber!
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoriteCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        replyToStatusId = dictionary["in_reply_to_status_id"] as? NSNumber!
        replyToScreenName = dictionary["in_reply_to_screen_name"] as? NSString!
        
        isRetweeted = (dictionary["retweeted"] as? Bool!)!
        isFavorited = (dictionary["favorited"] as? Bool!)!
        
        let timeStampString = dictionary["created_at"] as? String
        if let timeStampString = timeStampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timeStamp = formatter.dateFromString(timeStampString)
        }
        
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        


        if let retweetDictionary = dictionary["retweeted_status"] as? NSDictionary {
            retweet = Tweet(dictionary: retweetDictionary)
        }
    }

    class func tweetWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary:dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
    
    func formatedDate() -> String {
        
        let min = 60
        let hour = min * 60
        let day = hour * 24
        let week = day * 7
        
        let elapsedTime = NSDate().timeIntervalSinceDate(timeStamp!)
        let duration = Int(elapsedTime)
        
        if duration < min {
            return "\(duration)s"
        } else if duration >= min && duration < hour {
            let minDur = duration / min
            return "\(minDur)m"
        } else if duration >= hour && duration < day {
            let hourDur = duration / hour
            return "\(hourDur)h"
        } else if duration >= day && duration < week {
            let dayDur = duration / day
            return "\(dayDur)d"
        } else {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "M/d/yy"
            let dateString = dateFormatter.stringFromDate(timeStamp!)
            
            return dateString
        }
    }

    func formatedDetailDate() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        let dateString = dateFormatter.stringFromDate(timeStamp!)
        return dateString
    }
}
