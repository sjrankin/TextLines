//
//  AnimationSettingsSlice.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/6/21.
//

import Foundation
import UIKit

class AnimationSettingsSlice: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = 5.0
        self.view.layer.borderColor = UIColor.black.cgColor
        self.view.layer.borderWidth = 1.5
    }
    
    @IBAction func AnimationSpeedControlChanged(_ sender: Any)
    {
    }
    
    @IBAction func AnimationDirectionControlChanged(_ sender: Any)
    {
    }
    
    @IBOutlet weak var AnimationSpeedControl: UISegmentedControl!
    @IBOutlet weak var AnimationDirectionControl: UISegmentedControl!
}
