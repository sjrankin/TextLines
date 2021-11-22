//
//  GuidelinesSettingSlice.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/6/21.
//

import Foundation
import UIKit

class GuidelineSettingSlice: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = UIConstants.CornerRadius
        self.view.layer.borderColor = UIConstants.DarkBorder
        self.view.layer.borderWidth = UIConstants.ThickBorder
        
        ShapeColorControl.clipsToBounds = true
        ShapeColorControl.selectedColor = Settings.GetColor(.GuidelineColor, .yellow)
        ShapeColorControl.supportsAlpha = true
        ShapeColorControl.addTarget(self, action: #selector(ColorChangedHandler(_:)), for: .valueChanged)
        
        GridColorControl.clipsToBounds = true
        GridColorControl.selectedColor = Settings.GetColor(.GridColor, .yellow)
        GridColorControl.supportsAlpha = true
        GridColorControl.addTarget(self, action: #selector(ColorChangedHandler(_:)), for: .valueChanged)
    }
    
    @objc func ColorChangedHandler(_ sender: Any)
    {
        if let Well = sender as? UIColorWell
        {
            if let FinalColor = Well.selectedColor
            {
                switch Well
                {
                    case GridColorControl:
                        Settings.SetColor(.GridColor, FinalColor)
                        
                    case ShapeColorControl:
                        Settings.SetColor(.GuidelineColor, FinalColor)
                        
                    default:
                        break
                }
            }
        }
    }
    
    @IBAction func ShowShapeChanged(_ sender: Any)
    {
    }
    
    @IBAction func ShowGridChanged(_ sender: Any)
    {
    }
    
    @IBOutlet weak var GridColorControl: UIColorWell!
    @IBOutlet weak var ShowGridSwitch: UISwitch!
    @IBOutlet weak var ShapeColorControl: UIColorWell!
    @IBOutlet weak var ShowShapeSwitch: UISwitch!
}
