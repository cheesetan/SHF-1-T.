//
//  messagesViewModel.swift
//  SHF(1)T.
//
//  Created by Tristan on 13/01/2023.
//

import SwiftUI
import Firebase

struct Messages: Codable, Identifiable {
    var id: String
    var content: String
    var sender: String
}


class MessagesViewModel: ObservableObject {
    
    @Published var messages = [Messages]()
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    @AppStorage("userNumber", store: .standard) private var userNumber = ""
    
    func fetchData(chatroomID: String) {
        
        db.collection("chatrooms").document(chatroomID).collection("messages").order(by: "sentAt", descending: true).addSnapshotListener({(snapshot, error) in
            guard let documents = snapshot?.documents else {
                print ("no docs returned!")
                return
            }
            
            self.messages = documents.map({docSnapshot -> Messages in
                let data = docSnapshot.data()
                let docId = docSnapshot.documentID
                let content = data["content"] as? String ?? ""
                let sender = data["sender"] as? String ?? ""
                
                return Messages(id: docId, content: content, sender: sender)
            })
        })
    }
    
    func sendMessage(chatroomID: String, content: String) {
            db.collection("chatrooms").document(chatroomID).collection("messages").addDocument(data: [
                                                                                            "sentAt": Date(),
                                                                                            "sender": userNumber,
                                                                                            "content": content])
    }
}

