//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

        navigationController?.navigationBar.tintColor = UIColor(named: k.BrandColors.purple)
      
        
        tableView.dataSource = self
        navigationItem.hidesBackButton = true
       
        title = k.appName
        
        tableView.register(UINib(nibName: k.cellNibName, bundle: nil),forCellReuseIdentifier: k.cellIdentifier)
        
        loadMessages()
        
    }
    
    func loadMessages() {
        
        //closure could be triggered at any moment depends on wifi
        
        db.collection(k.FStore.collectionName)
           .order(by: k.FStore.dateField)
           .addSnapshotListener { (querySnapshot, error) in
               
            self.messages = []
               
            if let e = error {
                print("cannot get data \(e)")
            }else {
                if let docs = querySnapshot?.documents {
                    for doc in docs {
                        let data = doc.data()
                        
                        if let messageSender = data[k.FStore.senderField] as? String , let messageBody = data[k.FStore.bodyField] as? String {
                            
                            let newMessage = Message(sender: messageSender, body: messageBody)
                        
                            self.messages.append(newMessage)
                            
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData() //this will show all the new messages
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                            
                        }
                        
                    }
                }
            }
            
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
 
        if let messageSender = Auth.auth().currentUser?.email, let messageBody = messageTextfield.text {
            db.collection(k.FStore.collectionName).addDocument(data: [
                k.FStore.senderField : messageSender,
                k.FStore.bodyField : messageBody,
                k.FStore.dateField : Date().timeIntervalSince1970
            ]) { error in
                if let e = error {
                    print("Issue saving to firestore, \(e)")
                }else{
                    print("Data saved")
                    
                    DispatchQueue.main.async{
                        self.messageTextfield.text = ""
                    }
                    
                }
            }
        }
        
        
        
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
       do {
         try Auth.auth().signOut()
           navigationController?.popToRootViewController(animated: true)
       } catch let signOutError as NSError {
         print("Error signing out: %@", signOutError)
       }
    }
    

}

extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //use to allocate required number of rows
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: k.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body //main label in cell
        
        //this message is from current user
        if message.sender == Auth.auth().currentUser?.email{
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: k.BrandColors.purple)
            cell.label.textColor = UIColor(named: k.BrandColors.lightPurple)
        }else{
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: k.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: k.BrandColors.purple)
        }
        
        return cell
        
    }
    
    
}

