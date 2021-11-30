//
//  ViewController.swift
//  KeyboardTest
//
//  Created by Stuart Rankin on 11/29/21.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        /*
        //TextInput.inputAssistantItem.leadingBarButtonGroups = []
        //TextInput.inputAssistantItem.trailingBarButtonGroups = []
        //TextInput.inputAccessoryView = UIView(frame: .zero)
        TextInput.inputAccessoryView = nil
        TextInput.autocorrectionType = .no
        TextInput.inputAccessoryView?.isHidden = true
        TextInput.inputAccessoryView?.isUserInteractionEnabled = false
        TextInput.reloadInputViews()
         */
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        //textView.autocorrectionType = .no
        //textView.inputAccessoryView = UIView(frame: .zero)
        //textView.reloadInputViews()
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool
    {
        //textView.autocorrectionType = .yes
        return true
    }
    
    @IBOutlet weak var TextInput: UITextView!
}

