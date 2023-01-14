//
//  Authentication.swift
//  SHF(1)T.
//
//  Created by Tristan on 12/01/2023.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct Authentication: View {
    
    @State private var phonenumber = String()
    @State private var code = String()
    
    @AppStorage("isLoggedIn", store: .standard) private var isLoggedIn = false
    @AppStorage("userNumber", store: .standard) private var userNumber = ""
    @AppStorage("verificationId", store: .standard) private var verificationId = String()
    
    @FocusState private var fieldIsFocused: Bool
    
    var body: some View {
        VStack {
            Text("sign in with phone number, recaptcha, and verification code\nremember to enter your country code before your phone number (e.g. +65)\n\nplease wait after pressing \"send verification code\" to verify your recaptcha")
            
            TextField("phone number", text: $phonenumber, axis: .horizontal)
                .keyboardType(.phonePad)
                .focused($fieldIsFocused)
            
            Button {
                verifyPhoneNumber()
            } label: {
                Text("send verification code")
            }
            
            if !verificationId.isEmpty {
                Text("\ncurrently verifying for number: \(userNumber)")
            }
            
            TextField("enter code", text: $code, axis: .horizontal)
                .keyboardType(.numberPad)
                .focused($fieldIsFocused)
            
            Button {
                signInUser()
            } label: {
                Text("verify")
            }
            .disabled(verificationId.isEmpty)
            
            Text("tip: if verification code expired, we wont tell you, just keep trying lol\n\noh and we will crash the app if you get the verification code wrong")
            
            Button("dismiss keyboard") {
                fieldIsFocused = false
            }
        }
    }
    
    func verifyPhoneNumber() {
        PhoneAuthProvider.provider().verifyPhoneNumber(phonenumber, uiDelegate: nil) { (verificationID, error) in
              if let error = error {
                print(error.localizedDescription)
                return
              }
                verificationId = verificationID!
                userNumber = phonenumber
            }
    }
    
    func signInUser() {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationId,
            verificationCode: code
        )
        
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                    print(error.localizedDescription)
                    fatalError("bitchass got it wrong lol")
            }
            
            print("user is signed in")
            isLoggedIn = true
            verificationId = ""
            setNewAccount()
        }
    }
    
    func setNewAccount() {
        
        var currentUsers = Array<Any>()
        
        Firestore.firestore().collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    currentUsers.append(document.documentID)
                    print(currentUsers)
                }
            }
        }
        
        if !currentUsers.description.contains(userNumber)  {
            Firestore.firestore().collection("users").document(userNumber).setData([
                "userNumber": userNumber,
                "PMs": []
            ])
        }
    }
}

struct Authentication_Previews: PreviewProvider {
    static var previews: some View {
        Authentication()
    }
}
