//
//  NoOptionsSettingSlice.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/7/21.
//

import Foundation
import UIKit

class NoOptionsSettingSlice: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = 5.0
        self.view.layer.borderColor = UIColor.black.cgColor
        self.view.layer.borderWidth = 1.5
    }
}
