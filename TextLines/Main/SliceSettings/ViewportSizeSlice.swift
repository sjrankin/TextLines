//
//  ViewportSizeSlice.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/6/21.
//

import Foundation
import UIKit

class ViewportSizeSlice: UIViewController, UITextFieldDelegate
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = 5.0
        self.view.layer.borderColor = UIColor.black.cgColor
        self.view.layer.borderWidth = 1.5
        
        InitializeKeyboard()
    }
    
    /// Initialize the keyboard with a `Done` button in a toolbar. This provides an alternative
    /// way for the user to indicate no more editing.
    func InitializeKeyboard()
    {
        let KBToolbar = UIToolbar()
        let FlexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil, action: nil)
        let DoneButton = UIBarButtonItem(title: "Dismiss", style: .done,
                                         target: self, action: #selector(KeyboardDoneButtonTapped))
        
        KBToolbar.setItems([FlexSpace, DoneButton], animated: true)
        KBToolbar.sizeToFit()
        WidthTextBox.inputAccessoryView = KBToolbar
        HeightTextBox.inputAccessoryView = KBToolbar
    }
    
    /// Called by the `Dismiss` button the program inserted into the keyboard's toolbar when the
    /// user has completed text entry.
    @objc func KeyboardDoneButtonTapped()
    {
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        switch textField
        {
            case WidthTextBox:
                print("WidthTextBox=\(textField.text)")
                
            case HeightTextBox:
                print("HeightTextBox=\(textField.text)")
                
            default:
                Debug.Print("Unexpected textField encountered.")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    @IBOutlet weak var HeightTextBox: UITextField!
    @IBOutlet weak var WidthTextBox: UITextField!
}
