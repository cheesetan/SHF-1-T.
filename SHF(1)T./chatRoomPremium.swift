//
//  chatRoomPremium.swift
//  SHF(1)T.
//
//  Created by Tristan on 13/01/2023.
//

import SwiftUI
import Firebase

struct chatRoomPremium: View {
    
    let chatroom: Chatroom
    @ObservedObject var viewModel = MessagesViewModel()
    @State private var text = String()
    @State private var scrollCount = 0
    
    @Environment(\.presentationMode) var presentationMode
    
    @FocusState private var isTextFieldFocused: Bool
    
    @AppStorage("userNumber", store: .standard) private var userNumber = ""

    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    ScrollViewReader { proxy in
                        HStack {
                            Spacer()
                        }
                        ForEach(viewModel.messages) { message in
                            if message.sender == "\(userNumber)" {
                                VStack {
                                    HStack {
                                        Spacer()
                                        blueBubble(content: message.content, displayName: message.sender)
                                            .padding(.trailing)
                                            .padding(.leading, 50)
                                    }
                                }
                            } else {
                                VStack {
                                    Text(message.sender)
                                        .font(.footnote)
                                        .fontWeight(.semibold)
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading)
                                    HStack {
                                        greenBubble(content: message.content, displayName: message.sender)
                                            .padding(.leading)
                                            .padding(.trailing, 50)
                                            .padding(.bottom, 5)
                                        Spacer()
                                    }
                                }
                            }
                        }
                        HStack {
                            Spacer()
                        }
                        .padding(.bottom)
                        .id("EMPTY")
                        .onAppear {
                            proxy.scrollTo("EMPTY", anchor: .bottom)
                        }
                        .onChange(of: scrollCount) { value in
                            proxy.scrollTo("EMPTY", anchor: .bottom)
                        }
                    }
                    .onTapGesture {
                        UIApplication.shared.dismissKeyboard()
                    }
                }
                Divider()
                HStack {
                    Spacer()
                    TextField("Enter text", text: $text, axis: .vertical)
                        .focused($isTextFieldFocused)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(lineWidth: 1).foregroundColor(.gray))
                        .background(Color("bgColorTab2"))
                        .cornerRadius(16)
                        .frame(width: !text.isEmpty ? UIScreen.main.bounds.width - 86 : UIScreen.main.bounds.width - 24, height: 100)
                        .lineLimit(3)
                        .padding(.bottom, 5)
                    if !text.isEmpty {
                        Spacer()
                        Button {
                            if text != "" && text != " " && text != "\n" {
                                viewModel.sendMessage(chatroomID: chatroom.id, content: text)
                                text = ""
                                scrollCount += 1
                            }
                        } label: {
                            Image(systemName: "arrow.up.message.fill")
                                .font(.title3)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                                .background(.blue)
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                    }
                    Spacer()
                }
            }
            .gesture(DragGesture()
                .onChanged({ _ in
                    UIApplication.shared.dismissKeyboard()
                })
            )
            .toolbarBackground(Color(UIColor.systemBackground), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationTitle("\(chatroom.title)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.fetchData(chatroomID: chatroom.id)
        }
    }
}

struct blueBubble: View {
    
    let content: String
    let displayName: String
    
    var body: some View {
        VStack {
            Text(content)
                .foregroundColor(.white)
                .padding()
                .background(.blue)
                .cornerRadius(20)
        }
    }
}

struct greenBubble: View {
    
    let content: String
    let displayName: String
    
    var body: some View {
        VStack {
            Text(content)
                .foregroundColor(.white)
                .padding()
                .background(.green)
                .cornerRadius(20)
        }
    }
}

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

