//
//  TextFieldInput.swift
//  Karkonex
//
//  Created by QTS Coder on 25/10/24.
//

import SwiftUI
struct TextFieldInput: UIViewRepresentable {
    
    // binding...
    
    typealias UIViewType = UITextField
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.addDoneButtonOnKeyboard()
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        // update binding...
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    public class Coordinator: NSObject, UITextFieldDelegate {
        // delegate methods...
    }
}

extension UITextField {

    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        self.resignFirstResponder()
    }
}
