//
//  TextFormattingSlice.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/6/21.
//

import Foundation
import UIKit

class TextFormattingSlice: UIViewController, ShapeSliceProtocol
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = UIConstants.CornerRadius
        self.view.layer.borderColor = UIConstants.DarkBorder
        self.view.layer.borderWidth = UIConstants.ThickBorder
        
        RotateTextSwitch.isOn = Settings.GetBool(.RotateCharacters)
        guard let DefaultOrientation = Settings.SettingDefaults[.ShapeAlignment] as? ShapeAlignments else
        {
            Debug.Print("Error getting default value for .ShapeAlignment.")
            return
        }
        Settings.SetEnum(DefaultOrientation, EnumType: ShapeAlignments.self, ForKey: .ShapeAlignment)
        let Orientation = Settings.GetEnum(ForKey: .ShapeAlignment, EnumType: ShapeAlignments.self, Default: .Top)
        switch Orientation
        {
            case .Top:
                AlignmentControl.selectedSegmentIndex = 1
                
            case .Bottom:
                AlignmentControl.selectedSegmentIndex = 2
                
            case .Left:
                AlignmentControl.selectedSegmentIndex = 3
                
            case .Right:
                AlignmentControl.selectedSegmentIndex = 4
                
            case .None:
                AlignmentControl.selectedSegmentIndex = 0
        }
    }
    
    @objc func TextColorChangedHandler(_ sender: Any)
    {
        if let Well = sender as? UIColorWell
        {
            if let FinalColor = Well.selectedColor
            {
                Settings.SetColor(.TextColor, FinalColor)
            }
        }
    }
    
    @IBAction func SelectFontTapped(_ sender: Any)
    {
    }
    
    @IBAction func RotateSwitchChangeHandler(_ sender: Any)
    {
        guard let Switch = sender as? UISwitch else
        {
            return
        }
        Settings.SetBool(.RotateCharacters, Switch.isOn)
    }
    
    @IBAction func AlignmentControlChanged(_ sender: Any)
    {
        guard let Segment = sender as? UISegmentedControl else
        {
            return
        }
        let Index = Segment.selectedSegmentIndex
        var Align: ShapeAlignments = .None
        switch Index
        {
            case 0:
                Align = .None
                
            case 1:
                Align = .Top
                
            case 2:
                Align = .Bottom
                
            case 3:
                Align = .Left
                
            case 4:
                Align = .Right
                
            default:
                return
        }
        Settings.SetEnum(Align, EnumType: ShapeAlignments.self, ForKey: .ShapeAlignment)
    }
    
    func ResetSettings()
    {
        Settings.SetBoolDefault(For: .RotateCharacters)
        RotateTextSwitch.isOn = Settings.GetBool(.RotateCharacters)
        guard let DefaultOrientation = Settings.SettingDefaults[.ShapeAlignment] as? ShapeAlignments else
        {
            Debug.Print("Error getting default value for .ShapeAlignment.")
            return
        }
        Settings.SetEnum(DefaultOrientation, EnumType: ShapeAlignments.self, ForKey: .ShapeAlignment)
        let Orientation = Settings.GetEnum(ForKey: .ShapeAlignment, EnumType: ShapeAlignments.self, Default: .Top)
        switch Orientation
        {
            case .Top:
                AlignmentControl.selectedSegmentIndex = 1
                
            case .Bottom:
                AlignmentControl.selectedSegmentIndex = 2
                
            case .Left:
                AlignmentControl.selectedSegmentIndex = 3
                
            case .Right:
                AlignmentControl.selectedSegmentIndex = 4
                
            case .None:
                AlignmentControl.selectedSegmentIndex = 0
        }
    }
    
    @IBOutlet weak var AlignmentControl: UISegmentedControl!
    @IBOutlet weak var RotateTextSwitch: UISwitch!
}
