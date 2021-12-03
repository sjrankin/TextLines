//
//  CommonShapeSlice.swift
//  TextLines
//
//  Created by Stuart Rankin on 12/2/21.
//

import Foundation
import UIKit

class CommonShapeSlice: UIViewController, ShapeSliceProtocol
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = UIConstants.CornerRadius
        self.view.layer.borderColor = UIConstants.DarkBorder
        self.view.layer.borderWidth = UIConstants.ThickBorder
        
        SmoothShapeSwitch.isOn = Settings.GetBool(.CommonSmoothing)
    }
    
    @IBAction func SmoothShapeChangedHandler(_ sender: Any)
    {
        guard let Switch = sender as? UISwitch else
        {
            return
        }
        Settings.SetBool(.CommonSmoothing, Switch.isOn)
    }
    
    func ResetSettings()
    {
        Settings.SetBoolDefault(For: .CommonSmoothing)
        SmoothShapeSwitch.isOn = Settings.GetBool(.CommonSmoothing)
    }
    
    @IBOutlet weak var SmoothShapeSwitch: UISwitch!
    
}
