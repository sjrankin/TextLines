//
//  BigAttributes.swift
//  BigAttributes
//
//  Created by Stuart Rankin on 9/7/21.
//

import Foundation
import UIKit

class BigAttributes: UIViewController
{
    public weak var delegate: AttributesProtocol? = nil
    
    var Title = ""
    var Text = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        TitleBox.text = delegate!.GetTitle()
        TextBox.text = delegate!.GetText()
        
        TitleBox.layer.borderColor = UIColor.systemGray.cgColor
        TitleBox.layer.borderWidth = 0.5
        TitleBox.layer.cornerRadius = 5.0
        
        TextBox.layer.borderColor = UIColor.systemGray.cgColor
        TextBox.layer.borderWidth = 0.5
        TextBox.layer.cornerRadius = 5.0
    }

    @IBAction func DoneButtonHandler(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var TitleBox: UITextView!
    @IBOutlet weak var TextBox: UITextView!
}
