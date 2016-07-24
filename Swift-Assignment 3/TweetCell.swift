//
//  TweetCell.swift
//  Swift-Assignment 3
//
//  Created by Huynh Tri Dung on 7/23/16.
//  Copyright © 2016 Huynh Tri Dung. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {

    @IBOutlet weak var tweetAtavar: UIImageView!
    @IBOutlet weak var tweetRetweetLabel: UILabel!
    @IBOutlet weak var tweetUserNameLabel: UILabel!
    @IBOutlet weak var tweetUserAccountLabel: UILabel!
    @IBOutlet weak var tweetCreatedTime: UILabel!
    @IBOutlet weak var tweetText: UILabel!
//    @IBOutlet weak var tweetImage: UIImageView!
    @IBOutlet weak var iconRetweet: UIImageView!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var loveCountLabel: UILabel!
    @IBOutlet weak var btnReply: UIButton!
    @IBOutlet weak var btnRetweet: UIButton!
    @IBOutlet weak var btnLove: UIButton!
    
    @IBOutlet weak var tweetRetweetLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconRetweetHeightConstraint: NSLayoutConstraint!
    
    
    var tweet: Tweet! {
        didSet {
            let retweetedConstraints = [tweetRetweetLabelHeightConstraint, iconRetweetHeightConstraint]
            
            if let retweet = tweet.retweet {
                if let name = tweet.user?.name {
                    tweetRetweetLabel.text = "\(name) Retweeted"
                    iconRetweet.image = UIImage(named: "retweet-action")
                }
                tweet = retweet
            }
            else if let replyTweetName = tweet.replyToScreenName {
                tweetRetweetLabel.text = "In reply to @\(replyTweetName)"
                iconRetweet.image = UIImage(named: "reply-action")
            }
            else {
                // set constant = 0 to hide view
                for constraint in retweetedConstraints {
                    constraint.constant = 0
                }
            }
            
            tweetUserNameLabel.text = tweet.user?.name as? String
            if let screenName = tweet.user?.screenName {
                tweetUserAccountLabel.text = "@\(screenName)"
            }
            
            
            tweetCreatedTime.text = tweet.formatedDate()
            
            tweetText.text = tweet.text as? String
            
            if tweet.user?.profileUrl != nil {
                tweetAtavar.setImageWithURL((tweet.user?.profileUrl)!)
            } else {
                tweetAtavar.image = UIImage(named: "user_placeholder")
            }
            
            
            if let tweetCount:Int = tweet.retweetCount {
                if tweetCount > 0 {
                    retweetCountLabel.text = "\(tweetCount)"
                } else {
                    retweetCountLabel.text = ""
                }
            }
            
            if let favoriteCount:Int = tweet.favoriteCount {
                if favoriteCount > 0 {
                    loveCountLabel.text = "\(favoriteCount)"
                } else {
                    loveCountLabel.text = ""
                }
            }
            
            if tweet.isRetweeted {
                btnRetweet.setImage(UIImage(named: "retweet-action-on"), forState: .Normal)
            } else {
                btnRetweet.setImage(UIImage(named: "retweet-action"), forState: .Normal)
            }
            
            if tweet.isFavorited {
                btnLove.setImage(UIImage(named: "like-action-on"), forState: .Normal)
            } else {
                btnLove.setImage(UIImage(named: "like-action"), forState: .Normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tweetAtavar.layer.cornerRadius = 5
        tweetAtavar.clipsToBounds = true
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        tweetRetweetLabelHeightConstraint.constant = 15
        iconRetweetHeightConstraint.constant = 15
    }
    
    @IBAction func onRetweetTap(sender: UIButton) {
        if let selectedTweetCell = sender.superview?.superview as? TweetCell {
            let selectedTweet = selectedTweetCell.tweet
            print(selectedTweet)
            
        }
//        if selectedTweet.isRetweeted {
//            TwitterClient.sharedInstance.getRetweetedId(selectedTweet.id!, completion: { (retweetedId, error) -> () in
//                if let myRetweetId = retweetedId {
//                    TwitterClient.sharedInstance.unretweet(myRetweetId, completion: { (response, error) -> () in
//                        if response != nil {
//                            selectedTweet.isRetweeted = false
//                            var retweetCount = selectedTweet.retweetCount! - 1
//                            selectedTweet.retweetCount = retweetCount
//                            if retweetCount != 0 {
//                                retweetCountLabel.text = "\(retweetCount)"
//                            } else {
//                                retweetCountLabel.text = ""
//                            }
//                            
//                            retweetButton.setImage(UIImage(named: "Retweet"), forState: .Normal)
//                        }
//                    })
//                }
//            })
//        } else {
//            TwitterClient.sharedInstance.retweet(selectedTweet.id!, completion: { (response, error) -> () in
//                if response != nil {
//                    selectedTweet.isRetweeted = true
//                    var retweetCount = selectedTweet.retweetCount! + 1
//                    selectedTweet.retweetCount = retweetCount
//                    retweetCountLabel.text = "\(retweetCount)"
//                    retweetButton.setImage(UIImage(named: "RetweetOn"), forState: .Normal)
//                }
//            })
//        }
    }
    

}
