//
//  ChannelCell.swift
//  NextChatCharles
//
//  Created by Charles Lee on 6/2/17.
//  Copyright © 2017 SwiftLearning. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    
    
    // Ultimate purpose to do this is to allow channel view controller to use this custom cell programatically
    // Static means 1. no need to instantiate to access the cell 2. set only once and wont change
    static let cellIdentifier = "ChannelCell"
    static let cellNib = UINib(nibName: "ChannelCell", bundle: Bundle.main)


    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
}
