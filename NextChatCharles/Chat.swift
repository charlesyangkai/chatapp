//
//  Chat.swift
//  NextChatCharles
//
//  Created by Charles Lee on 6/2/17.
//  Copyright © 2017 SwiftLearning. All rights reserved.
//

import Foundation


class Chat {
    var senderID: String?
    var senderName: String?
    var text: String?
    var timeStamp: TimeInterval?
    var image: URL?
    
    
    
    //so it can be declared in other classes.
    init(withDictionary dictionary: [String:Any]){
        
        senderID = dictionary["senderId"]as? String
        senderName = dictionary["senderName"] as? String
        text = dictionary["text"] as? String
        timeStamp = dictionary["timeStamp"] as? TimeInterval
        if let imageURL = dictionary["image"] as? String{
            image = URL(string: imageURL)
        }
        
    }
    
    
    
    

    //timestamp
    func timeAgo() -> String {
        guard let timestamp = timeStamp else { return ("unknown")}
        
        let sentTime = Date(timeIntervalSinceReferenceDate: timestamp)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "d MMM yyyy HH:mm::ss"
        
        print("sent time is \(sentTime)")
        print(timeAgo())
        
        return dateformatter.string(from: sentTime)
    }
}
