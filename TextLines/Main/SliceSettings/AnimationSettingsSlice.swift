//
//  AnimationSettingsSlice.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/6/21.
//

import Foundation
import UIKit

class AnimationSettingsSlice: UIViewController, ShapeSliceProtocol
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = UIConstants.CornerRadius
        self.view.layer.borderColor = UIConstants.DarkBorder
        self.view.layer.borderWidth = UIConstants.ThickBorder
    }
    
    @IBAction func AnimationSpeedControlChanged(_ sender: Any)
    {
    }
    
    @IBAction func AnimationDirectionControlChanged(_ sender: Any)
    {
    }
    
    func ResetSettings()
    {
    }
    
    @IBOutlet weak var AnimationSpeedControl: UISegmentedControl!
    @IBOutlet weak var AnimationDirectionControl: UISegmentedControl!
}
