//
//  Channel.swift
//  NextChatCharles
//
//  Created by Charles Lee on 6/2/17.
//  Copyright © 2017 SwiftLearning. All rights reserved.
//

import Foundation

class Channel{
    var name: String?
    var id: String?
    var chats: [Chat] = []

    
    init(withDictionary dictionary: [String: Any], index: Int){
        
        // Set the values for id and name
        id = String(index)
        name = dictionary["name"] as? String
        
        // Set the values for chats/ making sure there is chat before proceeding to loop
        if let allChats = dictionary["chats"] as? [Any] {
            for aChat in allChats {
                // Making sure each chat is of type dictionary
                if let ChatValue = aChat as? [String:Any]{
                    // Making all the chats of type class Chat
                    let newChat = Chat(withDictionary: ChatValue)
                    chats.append(newChat)
                }
            }
        }
    }
    
    
    func membersName() -> String {
        var members : String = ""
        for chat in chats{
            // sender name is optional, cant append nil
            // wouldn't this make rock be repeated twice if he types two chats
            if let name = chat.senderName {
                members.append(name)
                members.append(", ")
            }
        }
        return members
    }
    
    
}
