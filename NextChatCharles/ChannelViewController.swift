//
//  ChannelViewController.swift
//  NextChatCharles
//
//  Created by Charles Lee on 6/2/17.
//  Copyright © 2017 SwiftLearning. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChannelViewController: UIViewController {
    
    var channels: [Channel] = []
    var dbRef : FIRDatabaseReference!
    
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            
            // The usual delegate and datasource for tableviews
            tableView.delegate = self
            tableView.dataSource = self
            
            // Register the custom cell to the table view
            tableView.register(ChannelCell.cellNib, forCellReuseIdentifier: ChannelCell.cellIdentifier )
            
            // Configure autolayout for height
            tableView.estimatedRowHeight = 80
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = FIRDatabase.database().reference()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Fetch/observe data from firebase
        dbRef.child("channels").observe(.value, with: { (snapshot) in
            
            // dump(snapshot.value)
            
            // Check if the channel has anything in it first before proceeding
            if let snapValues = snapshot.value as? [Any] {
                
                var channelIndex = 0
                var tempChannel : [Channel] = []
                
                // Reading data from firebase to xcode channel by channel through loop
                for snapElement in snapValues {
                    
                    // Making sure each snap element is of dictionary type
                    if let channelDictionary = snapElement as? [String: Any]{
                        
                        // Making the channels of type class channel
                        let newChannel = Channel(withDictionary: channelDictionary, index: channelIndex)
                        channelIndex += 1
                        tempChannel.append(newChannel)
                    }
                }
                self.channels = tempChannel
                self.tableView.reloadData()
            }
        })
    }
    
    
    
}



extension ChannelViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // You are letting 'cell' to be the custom channel cell you created
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelCell.cellIdentifier, for: indexPath) as? ChannelCell else { return UITableViewCell()}
        // You are letting 'channel' to be each channel there is one step at a time
        let channel = channels[indexPath.row]
        cell.mainLabel.text = channel.name
        cell.secondaryLabel.text = channel.membersName()
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatbox = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController
        // Which channel to display
        chatbox?.currentChannel = channels[indexPath.row]
        navigationController?.pushViewController(chatbox!, animated: true)
    }
    
    
    
}
