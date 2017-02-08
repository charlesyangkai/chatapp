//
//  ChatViewController.swift
//  NextChatCharles
//
//  Created by Charles Lee on 6/2/17.
//  Copyright © 2017 SwiftLearning. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class ChatViewController: UIViewController {
    
    var imageUrl : URL?
    var displayThisName: String?
    var userID: String?
    var currentChannel: Channel?
    var currentChats: [Chat] = []
    
    //step 1:create a reference
    var dbRef: FIRDatabaseReference!
    
    
    @IBOutlet weak var imageBtn: UIButton!{
        didSet{
            imageBtn.addTarget(self, action: #selector(displayImagePicker), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var msgTF: UITextField!
    
    @IBOutlet weak var chatTableView: UITableView!{
        didSet{
            chatTableView.dataSource = self
            chatTableView.delegate = self
            
            //register custom cell
            chatTableView.register(ChatCell.cellNib, forCellReuseIdentifier: ChatCell.cellIdentifier)
            
            //configure autolayout for row height
            chatTableView.estimatedRowHeight = 80
            chatTableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    @IBOutlet weak var sendBtn: UIButton!{
        didSet{
            sendBtn.addTarget(self, action: #selector(sendChat), for: .touchUpInside)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //step 2: create a reference
        dbRef = FIRDatabase.database().reference()
        observeChat()
        
        userID = FIRAuth.auth()?.currentUser?.uid
        
        dbRef.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let displayName = value?["displayName"] as? String ?? ""
            
            self.displayThisName = displayName
            dump(snapshot)
            print(displayName)
        })
    }
    
    
    
    func displayImagePicker(){
        let pickerController = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            pickerController.sourceType = .photoLibrary
            pickerController.delegate = self
            present(pickerController, animated: true, completion: nil)
        }
    }
    
    
    
    func sendChat(){

        guard let text = msgTF.text else {return}
        //this will prevent empty cell created
        if text == ""{
            print("text can't be empty")
            return
        }
        
        guard
            let channelId = currentChannel?.id
            else {return}
        
        
        //catchng time interval
        let timestamp = Date.timeIntervalSinceReferenceDate
        let chatIndex = currentChats.count
        
        //saving time interval to database
        var chatDictionary : [String: Any] = ["senderID" : userID, "senderName" : displayThisName, "text" : text, "timeSamp" : timestamp]
        
        
        //converting url to string
        if let urlString = imageUrl?.absoluteString{
            //saving url string to database
            chatDictionary["image"] = urlString
        }
        
        if let text = msgTF.text{
            //saving msg text to database
            chatDictionary["text"] = text
        }
        print(timestamp)
        
        dbRef.child("channels").child(channelId).child("chats").child(String(chatIndex)).setValue(chatDictionary)
        
        msgTF.text = " "
    }
    
    
    
    //READING FROM FIREBASE
    //get original chat then when adding a new child it will add a new child
    func observeChat(){
        guard
            let channelId = currentChannel?.id else {return}
        dbRef.child("channels").child(channelId).child("chats").observe(.childAdded, with: { (snapshot) in
            
            //append caht
            guard let value = snapshot.value as? [String: Any] else {return}
            let newChat = Chat(withDictionary: value)
            self.appendChat(newChat)
        })
    }
    
    
    
    func appendChat(_ chat: Chat){
        currentChats.append(chat)
        chatTableView.reloadData()
    }
    
    
    
    func uploadImage(image: UIImage){
        let storageRef = FIRStorage.storage().reference()
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        
        let timestamp = String(Date.timeIntervalSinceReferenceDate)
        let convertedTimeStamp = timestamp.replacingOccurrences(of: ".", with: "")
        let imageName = ("image \(convertedTimeStamp).jpeg")
        
        
        //also have png
        guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {return}
        storageRef.child("image123.jpeg").put(imageData, metadata: metadata) { (meta, error) in
            
            self.dismiss(animated: true, completion: nil)
            
            if error != nil {
                return
            }
            
            if let downloadUrl = meta?.downloadURL(){
                self.imageUrl = downloadUrl
                self.sendChat()
                print(downloadUrl)
            } else{
                //error
            }
        }
    }
}


// The UIImagePicker does much of its works from these 2 delegates
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            uploadImage(image: image)
        }
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentChats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.cellIdentifier, for: indexPath) as? ChatCell
            else {
                return UITableViewCell()
        }
        
        let chat = currentChats[indexPath.row]
        
        if let url = chat.image{
            
            if let data = try? Data(contentsOf: url) {
                cell.chatImageView.image = UIImage(data: data)
            }
        }
        
        
        cell.senderLabel.text = chat.senderName
        cell.msgLabel.text = chat.text
        cell.timestampLabel.text = chat.timeAgo()
        
        return cell
    }
    
}
