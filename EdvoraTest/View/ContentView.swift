//
//  ContentView.swift
//  EdvoraTest
//
//  Created by Pushpendra  Kumar on 05/12/21.
//

import SwiftUI

struct ContentView: View {
    @State private var errorMessage : String = ""
    @State private var username : String = ""
    @State private var password : String = ""
    @State private var email : String = ""
    @State var fieldFocus = [false, false,false]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Image("app-icon")
                    Spacer()
                    FloatingTextFieldView( placeHolder: "Username", text: $username, iconLeft: "person", autocapitalizationType: .none, returnKeyType: .next)
                    FloatingTextFieldView(placeHolder: "Password", text: $password, iconLeft : "key", iconRight : "eye", isSecure: true, returnKeyType: .next)
                    
                    FloatingTextFieldView( placeHolder: "Email address", text: $email, iconLeft: "mail", keyboardType : .emailAddress, returnKeyType: .done)
                    
                    if errorMessage.isEmpty == false {
                        Text(errorMessage)
                            .font(Font.custom("Verdana", size: 17))
                            .foregroundColor(Color(UIColor.systemRed))
                            .transition(.identity)
                            .padding(5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    NavigationLink(destination: ForgotPassword()) {
                        Text("Forgot password?")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(Font.custom("Verdana", size: 17))
                            .foregroundColor(Color("accent"))
                            .padding(.vertical)
                    }
                    
                    Button(action: {
                        for i in 0...(fieldFocus.count - 1) {
                            fieldFocus[i] = false
                        }
                        validateData()
                    }) {
                        Text("Login")
                            .font(Font.custom("Verdana-Bold", size: 17))
                            .foregroundColor(Color.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color("accent")))
                            .padding()
                    }
                    
                    NavigationLink(destination: RegisterView()) {
                        HStack {
                            Text("Don`t have an account?")
                                .foregroundColor(Color("hint"))
                                .font(Font.custom("Verdana", size: 17))
                            Text("Sign up")
                                .foregroundColor(Color("accent"))
                                .font(Font.custom("Verdana-Bold", size: 17))
                        }
                        
                        
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .padding()
            }
        }
    }
    
    private func validateData(){
        if username.isEmpty {
            errorMessage = "Please enter username"
        } else if username.containsWhitespace {
            errorMessage = "Username can not contain white space"
        } else if username.containsUppercase {
            errorMessage = "Username can not contain UPPER-CASE"
        } else if password.isEmpty {
            errorMessage = "Please enter password."
        } else if password.count < 8 {
            errorMessage = "Password must contain min 8 characters length"
        } else if !password.containsDigits  {
            errorMessage = "Password must contain at least one digit"
        } else if !password.containsUppercase  {
            errorMessage = "Password must contain at least UPPER-CASE"
        } else if !password.containsLowercase  {
            errorMessage = "Password must contain at least LOWER-CASE"
        } else if email.isEmpty {
            errorMessage = "Please enter email address"
        }  else if !email.validEmailAddress {
            errorMessage = "Please enter valid email address"
        } else{
            errorMessage = ""
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
