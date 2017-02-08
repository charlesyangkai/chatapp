//
//  SignUpViewController.swift
//  NextChatCharles
//
//  Created by Charles Lee on 6/2/17.
//  Copyright © 2017 SwiftLearning. All rights reserved.
//

import UIKit
// Step 1 to authenticate/create new user
import FirebaseAuth
// Step 1 to save the new user
import FirebaseDatabase


class SignUpViewController: UIViewController {
    
    // Step 2 to save the new user
    var dbRef: FIRDatabaseReference!
    var users: [User] = []

    @IBOutlet weak var signUpBtn: UIButton!{
        didSet{
            signUpBtn.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var displaynameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Step 3 to save the new user
        dbRef = FIRDatabase.database().reference()
    }
    
    
    
    func signUp(){
        // Step 2 to authenticate/create new user
        FIRAuth.auth()?.createUser(withEmail: usernameTF.text!, password: passwordTF.text!, completion: { (user, error) in
            
            // if error then return to prevent it to from going further
            if error != nil{
                print(error as! NSError)
                return
            } else{
                print(user?.uid)
                print(user?.email)
            }
            
            // 3 steps to save the new user to the database
            
            // Step 1. defining the value, determine what kind of child users should have
            let userDictionary : [String: Any] = ["displayName": self.displaynameTF.text ?? "", "email" : self.usernameTF.text ?? "", "password" : self.passwordTF.text ?? ""]
            
            // Step 2. definining the key/id
            guard let validUserID = user?.uid else {return}
            
            // Step 3. adding the child values [key: value]
            self.dbRef.child("users").updateChildValues([validUserID: userDictionary])
            
        })
    }
}
