//
//  Settings.swift
//  SHF(1)T.
//
//  Created by Aathithya Jegatheesan on 11/1/23.
//

import SwiftUI
import FirebaseAuth

struct Settings: View {
    @AppStorage("isLoggedIn", store: .standard) private var isLoggedIn = false
    @AppStorage("userNumber", store: .standard) private var userNumber = ""
    
    var body: some View {
        VStack {
            Text("Settings").font(.title).fontWeight(.bold)
            Text("Currently signed in with phone number: \(userNumber)")
            
            Spacer()
            
            Button {
                logOut()
            } label: {
                Text("log out").foregroundColor(.red).fontWeight(.bold).font(.caption2)
            }
            
            Spacer()
        }
        
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
