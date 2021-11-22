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
        self.view.layer.cornerRadius = UIConstants.CornerRadius
        self.view.layer.borderColor = UIConstants.DarkBorder
        self.view.layer.borderWidth = UIConstants.ThickBorder
    }
}
