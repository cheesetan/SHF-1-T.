//
//  chatroomViewModel.swift
//  SHF(1)T.
//
//  Created by Tristan on 13/01/2023.
//

import SwiftUI
import Firebase

struct Chatroom: Codable, Identifiable {
    var id: String
    var title: String
}


class ChatroomsViewModel: ObservableObject {
    
    @Published var chatrooms = [Chatroom]()
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    @AppStorage("userNumber", store: .standard) private var userNumber = ""
    
    func fetchData() {
        
        db.collection("chatrooms").whereField("users", arrayContains: userNumber).addSnapshotListener({(snapshot, error) in
            guard let documents = snapshot?.documents else {
                print ("no docs returned!")
                return
            }
            
            self.chatrooms = documents.map({docSnapshot -> Chatroom in
                let data = docSnapshot.data()
                let docId = docSnapshot.documentID
                let title = data["title"] as? String ?? ""
                
                return Chatroom(id: docId, title: title)
            })
        })
    }
    
    func createChatroom(otherUser: String) {
        db.collection("chatrooms").addDocument(data: [
            "title": "\(userNumber), \(otherUser)",
            "users": [userNumber, otherUser]]) { err in
                if let err = err {
                    print("error adding document! \(err)")
                }
                
            }
    }
}
