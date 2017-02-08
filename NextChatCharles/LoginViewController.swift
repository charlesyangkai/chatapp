//
//  LoginViewController.swift
//  NextChatCharles
//
//  Created by Charles Lee on 6/2/17.
//  Copyright © 2017 SwiftLearning. All rights reserved.
//

import UIKit
// Step 1 to authenticate
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!{
        didSet{
            loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
        }
    }
    @IBOutlet weak var signUpPageBtn: UIButton!{
        didSet{
            signUpPageBtn.addTarget(self, action: #selector(loadSignUp), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    // LOGIN
    func login(){
        // Step 2 to authenticate
        FIRAuth.auth()?.signIn(withEmail: usernameTF.text!, password: passwordTF.text!, completion: { (user, error) in
            
            print("Login attempt")
            
            // if error then return to prevent it from loading page
            if error != nil {
                print(error as! NSError)
                return
            }
            
            // get the user and then loads to the channel page
            self.handleUser(user: user!)
            self.loadChannelPage()
        })
        print("hacker trying to access")
    }
    
    
    // print out what user is being used at the moment
    func handleUser(user: FIRUser){
        print(user.uid)
    }
    
    
    
    func loadSignUp(){
        let storyboard = UIStoryboard(name: "Auth", bundle: Bundle.main)
        let signUpPage = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController
        navigationController?.pushViewController((signUpPage)!, animated: true)
    }
    
    
    
    func loadChannelPage(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let channelPage = storyboard.instantiateViewController(withIdentifier: "ChannelViewController") as? ChannelViewController
        navigationController?.pushViewController(channelPage!, animated: true)
    }

 
}
