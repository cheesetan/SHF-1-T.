//
//  ContentView.swift
//  SHF(1)T.
//
//  Created by Aathithya Jegatheesan on 11/1/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 1
    
    var body: some View {
        TabView(selection: $selection) {
            Status()
                .tabItem {
                    Label("Status", systemImage: "circle.dashed.inset.filled")
                }
                .tag(0)
            Chats()
                .tabItem {
                    Label("Chats", systemImage: "bubble.left.and.bubble.right.fill")
                }
                .tag(1)
            Settings()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
