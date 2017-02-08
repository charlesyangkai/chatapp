//
//  User.swift
//  NextChatCharles
//
//  Created by Charles Lee on 7/2/17.
//  Copyright © 2017 SwiftLearning. All rights reserved.
//

import Foundation

class User{
    var id: String?
    var userID: String?
    var displayName: String?
    var email: String?
    var password: String?
    
    init(withDictionary dictionary: [String: Any], index: Int){
        id = String(index)
        userID = dictionary["userID"] as? String
        email = dictionary["email"] as? String
        password = dictionary["password"] as? String
        displayName = dictionary["displayName"] as? String
    }
}
