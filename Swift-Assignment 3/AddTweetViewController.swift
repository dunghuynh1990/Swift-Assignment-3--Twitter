//
//  AddTweetViewController.swift
//  Swift-Assignment 3
//
//  Created by Huynh Tri Dung on 7/24/16.
//  Copyright © 2016 Huynh Tri Dung. All rights reserved.
//  TODO: make view auto move with keyboard suggestion

import UIKit

@objc protocol AddTweetViewControllerDelegate {
    optional func addTweetViewControllerDelegate(addTweetViewController: AddTweetViewController, didAddTweet newTweet:Tweet)
}

class AddTweetViewController: UIViewController {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userAccount: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var btnTweet: UIButton!
    @IBOutlet weak var placeholderText: UILabel!
    @IBOutlet weak var textCountLabel: UILabel!
    
    weak var delegate: AddTweetViewControllerDelegate?
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TwitterClient.shareInstance.currentAccount({ (currentUser:User) in
            self.userName.text = currentUser.name as? String
            self.userAccount.text = "@\(currentUser.screenName!)"
            if currentUser.profileUrl != nil {
                self.avatar.setImageWithURL(currentUser.profileUrl!)
            } else {
                self.avatar.image = UIImage(named: "user_placeholder")
            }
        }) { (error:NSError) in
            print(error.localizedDescription)
        }
        avatar.layer.cornerRadius = 5
        avatar.clipsToBounds = true
        
        textView.becomeFirstResponder()
        
        btnTweet.layer.cornerRadius = 5
        btnTweet.clipsToBounds = true
        
        disableButton()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddTweetViewController {
    
    @IBAction func closeView(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onTweetButtonTap(sender: AnyObject) {
        TwitterClient.shareInstance.updateTweet(textView.text, success: { (tweet: Tweet?) in
            let newTweet = tweet
            if let newTweet = newTweet {
            self.dismissViewControllerAnimated(true, completion: {
                self.delegate?.addTweetViewControllerDelegate?(self, didAddTweet: newTweet)
            })
            }
        }) { (error: NSError) in
            print(error.localizedDescription)
        }
    }
}

extension AddTweetViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        var limit:Int
        if textView.text.isEmpty {
            placeholderText.hidden = false
            disableButton()
            limit = 140
            textCountLabel.text = "\(limit)"
        } else {
            placeholderText.hidden = true
            limit = 140 - textView.text.characters.count
            if (limit < 20) && (limit >= 0){
                textRedColor()
                enableButton()
            } else if limit < 0 {
                textRedColor()
                disableButton()
            } else {
                textNormalColor()
                enableButton()
            }
            textCountLabel.text = "\(limit)"
        }
    }
    
    func disableButton() {
        btnTweet.enabled = false
        btnTweet.backgroundColor = UIColor.clearColor()
        btnTweet.layer.borderColor = UIColor.lightGrayColor().CGColor
        btnTweet.layer.borderWidth = 1
        btnTweet.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
    }
    
    func enableButton() {
        btnTweet.enabled = true
        btnTweet.backgroundColor = UIColor(red: 85/255, green: 172/255, blue: 238/255, alpha: 1)
        btnTweet.layer.borderWidth = 0
        btnTweet.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
    
    func textNormalColor() {
        textCountLabel.textColor = UIColor.lightGrayColor()
    }
    
    func textRedColor() {
        textCountLabel.textColor = UIColor.redColor()
    }
    
}
