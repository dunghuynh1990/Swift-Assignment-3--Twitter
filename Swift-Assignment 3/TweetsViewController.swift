//
//  TweetsViewController.swift
//  Swift-Assignment 3
//
//  Created by Huynh Tri Dung on 7/23/16.
//  Copyright © 2016 Huynh Tri Dung. All rights reserved.
// 
//  TODO: add is retweet
//  TODO: auto constraint
//  TODO: cell's button
//  TODO: no internet connection
//  TODO: infinite scroll
//  TODO: add sound when refresh
//  TODO: client error
//  TODO: add button to table view background to refresh


/*
 #### Required
 - [x] User can sign in using OAuth login flow
 - [x] User can view last 20 tweets from their home timeline
 - [x] The current signed in user will be persisted across restarts
 - [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp. In other words, design the custom cell with the proper Auto Layout settings. You will also need to augment the model classes.
 - [x] User can pull to refresh
 - [x] User can compose a new tweet by tapping on a compose button.
 - [] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
 - [] User can retweet, favorite, and reply to the tweet directly from the timeline feed
 ​
 #### Optional
 - [x] When composing, you should have a countdown in the upper right for the tweet limit.
 - [] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
 - [] Retweeting and favoriting should increment the retweet and favorite count.
 - [] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
 - [] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
 - [x] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.
 ​
 */

import UIKit
import MBProgressHUD

class TweetsViewController: UIViewController {
    var tweets : [Tweet]?
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl?
    var loadingView: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.hidden = true
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        pullToRefresh()
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadData()
        
        // add loading view
        let tableFooterView: UIView = UIView(frame: CGRectMake(0, 0, 320, 50))
        loadingView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
//        loadingView.startAnimating()
        loadingView.center = tableFooterView.center
        tableFooterView.addSubview(loadingView)
        tableView.tableFooterView = tableFooterView
        
    }
    
    func loadData() {
        TwitterClient.shareInstance.homeTimeLine({ (tweets:[Tweet]) in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.tweets = tweets
            self.tableView.reloadData()
            self.tableView.hidden = false
        }) { (error:NSError) in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            print(error.localizedDescription)
        }
    }
    
    func refreshData() {
        TwitterClient.shareInstance.homeTimeLine({ (tweets:[Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }) { (error:NSError) in
            print(error.localizedDescription)
        }
        refreshControl?.endRefreshing()
    }
    
    func pullToRefresh() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(TweetsViewController.refreshData), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddTweet"{
            let addTweetVC = segue.destinationViewController as! AddTweetViewController
            addTweetVC.delegate = self
        }
    }
    
}

extension TweetsViewController {
    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.shareInstance.logout()
    }

}


extension TweetsViewController: UITabBarDelegate, UITableViewDataSource {
    //MARK: TableView Data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets?.count > 0 {
            return tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = tweets![indexPath.row]
        print(tweets![indexPath.row].id!)
        cell.layoutMargins = UIEdgeInsetsZero
        cell.separatorInset = UIEdgeInsetsZero
        
        if indexPath.row == tweets!.count - 1 {
            loadingView.startAnimating()
            
            if tweets!.count > 0 {
                let maxId = ((tweets![tweets!.count - 1].id)!.longLongValue - NSNumber(integer: 1).longLongValue) as NSNumber
                TwitterClient.shareInstance.homeTimeLineWithParams(20, maxId: maxId, success: { (tweets:[Tweet]) in
                    for tweet in tweets {
//                        self.tweets.append(tweet)
                        self.tweets?.append(tweet)
                    }
                    self.tableView.reloadData()
                }, failure: { (error: NSError) in
                        print(error.localizedDescription)
                })
            }
        } else {
            loadingView.stopAnimating()
        }
        
        return cell
    }
}

extension TweetsViewController: AddTweetViewControllerDelegate {
    //Delegate not call
    func addTweetViewController(addTweetViewController: AddTweetViewController, didAddTweet newTweet: Tweet) {
//        tweets?.insert(newTweet, atIndex: 0)
        tableView.reloadData()
        self.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top)
    }
}