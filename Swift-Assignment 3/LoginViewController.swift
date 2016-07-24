//
//  LoginViewController.swift
//  Swift-Assignment 3
//
//  Created by Huynh Tri Dung on 7/23/16.
//  Copyright © 2016 Huynh Tri Dung. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginTwitter(sender: AnyObject) {
        TwitterClient.shareInstance.login({
            print("I've loged in")
            self.performSegueWithIdentifier("LoginSegue", sender: nil)
        }) { (error:NSError) in
            print("error:\(error.localizedDescription)")
        }
    }
}

