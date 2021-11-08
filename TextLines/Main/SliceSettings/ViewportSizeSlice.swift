//
//  ViewportSizeSlice.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/6/21.
//

import Foundation
import UIKit

class ViewportSizeSlice: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = 5.0
        self.view.layer.borderColor = UIColor.black.cgColor
        self.view.layer.borderWidth = 1.5
    }
    
    @IBAction func EditingEnded(_ sender: Any)
    {
    }
    
    @IBOutlet weak var HeightTextBox: UITextField!
    @IBOutlet weak var WidthTextBox: UITextField!
}
