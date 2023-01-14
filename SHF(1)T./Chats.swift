//
//  Chats.swift
//  SHF(1)T.
//
//  Created by Aathithya Jegatheesan on 11/1/23.
//

import SwiftUI
import Firebase

struct Chats: View {
    
    @State private var showingNewChat = false
    
    @ObservedObject var viewModel = ChatroomsViewModel()
    
    @AppStorage("userNumber", store: .standard) private var userNumber = ""
    
    var body: some View {
        NavigationStack() {
            VStack {
                HStack {
                    Text("Chats").font(.title).fontWeight(.bold)
                    
                    Button {
                        showingNewChat.toggle()
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                    .sheet(isPresented: $showingNewChat) {
                        newChat()
                    }
                }
                
                Spacer()
                
                ForEach(viewModel.chatrooms) { chatroom in
                    NavigationLink(destination: chatRoomPremium(chatroom: chatroom)) {
                        Text(chatroom.title)
                    }
                }
                
                Spacer()
                
            }
            .onAppear {
                viewModel.fetchData()
            }
        }
    }
}

struct chatRoom: View {
    
    let chatroom: Chatroom
    @ObservedObject var viewModel = MessagesViewModel()
    @State private var text = String()
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                ForEach(viewModel.messages) { message in
                    Text("\(message.sender): \(message.content)")
                }
                
                Spacer()
                
                HStack {
                    TextField("enter message", text: $text)
                    
                    Button {
                        viewModel.sendMessage(chatroomID: chatroom.id, content: text)
                    } label: {
                        Text("send")
                    }
                    .disabled(text.isEmpty || text == " ")
                }
            }
            .onAppear {
                viewModel.fetchData(chatroomID: chatroom.id)
            }
            .navigationTitle("\(chatroom.title)")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


struct newChat: View {
    
    @State private var otherUser = String()
    
    @ObservedObject var viewModel = ChatroomsViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("remember to include the country code")
            
            TextField("number", text: $otherUser)
                .keyboardType(.phonePad)
            
            Button {
                viewModel.createChatroom(otherUser: otherUser)
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("create chat")
            }
            .disabled(otherUser.isEmpty)
        }
    }
}

struct Chats_Previews: PreviewProvider {
    static var previews: some View {
        Chats()
    }
}
