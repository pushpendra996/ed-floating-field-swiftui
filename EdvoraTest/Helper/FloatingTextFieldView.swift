//
//  FloatingTextFieldView.swift
//  EdvoraTest
//
//  Created by Pushpendra  Kumar on 05/12/21.
//

import SwiftUI
import UIKit




struct FloatingTextFieldView: View {
    
    var focusable: Binding<[Bool]>? = nil
    let placeHolder: String
    @Binding var text: String
    var iconLeft: String? = nil
    var iconRight : String? = nil
    @State var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var autocapitalizationType: UITextAutocapitalizationType = .none
    var returnKeyType: UIReturnKeyType = .default
    
    
    @State private var isEditing = false
    @State private var scaleFactor  = 1.0
    @State private var edges = EdgeInsets(top: 0, leading:45, bottom: 0, trailing: 0)
    @State private var actionColour : Color = Color("hint")
    
    private enum Field : Int, Hashable {
        case fieldName
    }
    
    @FocusState private var focusField : Field?
    
    var shouldPlaceHolderMove: Bool {
        isEditing || (text.count != 0)
    }
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                if iconLeft != nil {
                    Image(systemName: iconLeft ?? "person")
                        .foregroundColor(Color("hint"))
                }
                ITextField(label: "", text: $text, focusable: focusable, isSecureTextEntry: .constant(isSecure), returnKeyType: returnKeyType, autocapitalizationType: autocapitalizationType, keyboardType : keyboardType, onBegainEditing:  { status in
                    DispatchQueue.main.async {
                        isEditing = status
                        if isEditing {
                            scaleFactor = 0.85
                            edges = EdgeInsets(top: 0, leading:15, bottom: 60, trailing: 0)
                        } else {
                            if text.isEmpty {
                            scaleFactor = 1
                            edges = EdgeInsets(top: 0, leading:45, bottom: 0, trailing: 0)
                            }
                        }
                    }
                })
                .font(Font.custom("Verdana", size: 17))
                .focused($focusField, equals: .fieldName)
                if iconRight != nil {
                    Image(systemName: iconRight ?? "key")
                        .padding(.trailing)
                        .foregroundColor(actionColour)
                        .animation(Animation.linear(duration: 0.4), value: actionColour)
                        .onTapGesture {
                            isSecure.toggle()
                            if isSecure {
                                actionColour = Color("hint")
                            }else {
                                actionColour =  Color("accent")
                            }
                        }
                
                }
            }
            .padding([.top, .leading, .bottom])
            .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(UIColor.init(rgb: 0xdac4c5)), lineWidth: 1)
                        .frame(height: 55))
            .foregroundColor(Color.primary)
            .accentColor(Color.secondary)
            
            
            Text(placeHolder)
                .onTapGesture {
                    self.focusField = .fieldName
                }
                .background(Color(UIColor.systemBackground))
                .foregroundColor(Color.secondary)
                .padding(edges)
                .scaleEffect(scaleFactor)
                .animation(Animation.easeInOut(duration: 0.4), value: edges)
                .animation(Animation.easeInOut(duration: 0.5), value: scaleFactor)
                .font(Font.custom("Verdana", size: 17))
        }
        
    }
}

struct FloatingTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        FloatingTextFieldView(placeHolder: "Username", text: .constant(""))
    }
}
