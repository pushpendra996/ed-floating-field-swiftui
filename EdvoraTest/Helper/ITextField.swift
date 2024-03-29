//
//  TextFieldHelper.swift
//  EdvoraTest
//
//  Created by Pushpendra  Kumar on 11/12/21.
//

import Foundation
import SwiftUI
import UIKit

struct ITextField: UIViewRepresentable {
    let label: String
    @Binding var text: String
    
    var focusable: Binding<[Bool]>? = nil
    var isSecureTextEntry: Binding<Bool>? = nil
    
    var returnKeyType: UIReturnKeyType = .default
    var autocapitalizationType: UITextAutocapitalizationType = .none
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType? = nil
    
    var tag: Int? = nil
    var inputAccessoryView: UIToolbar? = nil
    
    var onCommit: (() -> Void)? = nil
    var onBegainEditing: ((Bool) -> Void)? = nil
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.placeholder = label
        
        textField.returnKeyType = returnKeyType
        textField.autocapitalizationType = autocapitalizationType
        textField.keyboardType = keyboardType
        textField.isSecureTextEntry = isSecureTextEntry?.wrappedValue ?? false
        textField.textContentType = textContentType
        textField.textAlignment = .left
        
        if let tag = tag {
            textField.tag = tag
        }
        
        textField.inputAccessoryView = inputAccessoryView
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange(_:)), for: .editingChanged)
        
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.isSecureTextEntry = isSecureTextEntry?.wrappedValue ?? false
        
        if let focusable = focusable?.wrappedValue {
            var resignResponder = true
            
            for (index, focused) in focusable.enumerated() {
                if uiView.tag == index && focused {
                    uiView.becomeFirstResponder()
                    resignResponder = false
                    break
                }
            }
            
            if resignResponder {
                uiView.resignFirstResponder()
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UITextFieldDelegate {
        let control: ITextField
        
        init(_ control: ITextField) {
            self.control = control
        }
        
        
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            control.onBegainEditing?(true)
            guard var focusable = control.focusable?.wrappedValue else { return }
            
            for i in 0...(focusable.count - 1) {
                focusable[i] = (textField.tag == i)
            }
            DispatchQueue.main.async {
                self.control.focusable?.wrappedValue = focusable
            }
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            guard var focusable = control.focusable?.wrappedValue else {
                textField.resignFirstResponder()
                return true
            }
            
            for i in 0...(focusable.count - 1) {
                focusable[i] = (textField.tag + 1 == i)
            }
            
            control.focusable?.wrappedValue = focusable
            if textField.tag == focusable.count - 1 {
                textField.resignFirstResponder()
            }
            return true
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            control.onCommit?()
            control.onBegainEditing?(false)
        }
        
        @objc func textFieldDidChange(_ textField: UITextField) {
            control.text = textField.text ?? ""
        }
    }
}
