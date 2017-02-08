//
//  ChatCell.swift
//  NextChatCharles
//
//  Created by Charles Lee on 6/2/17.
//  Copyright © 2017 SwiftLearning. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var chatCell: UIView!
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var chatImageView: UIImageView!
    
    
    
    //ultimate purpose to do this is to allow chat view controller to use this custom cell programatically
    static let cellIdentifier = "ChatCell"
    static let cellNib = UINib(nibName: "ChatCell", bundle: Bundle.main)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
