//
//  +SliceHandler.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/6/21.
//

import Foundation
import UIKit

extension ViewController
{
    /// Show a settings slice.
    /// - Note: Any changes to settings need to be detected by subscribing to the `Settings` class.
    /// - Parameter Slice: Determines which slice to show.
    func ShowSliceHandler(_ Slice: SliceTypes)
    {
        LoadSlice(Slice)
        
        SettingSlicePanel.layer.zPosition = 1000
        TextInput.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       options: [.curveEaseIn],
                       animations:
                        {
            self.SettingSlicePanel.alpha = 1.0
        },
                       completion:
                        {
            _ in
            self.SettingSlicePanel.becomeFirstResponder()
        })
    }
    
    /// Hide the slice handler.
    func HideSliceHandler()
    {
        TextInput.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: [.allowUserInteraction],
                       animations:
                        {
            self.SettingSlicePanel.alpha = 0.0
        },
                       completion:
                        {
            _ in
            self.SettingSlicePanel.resignFirstResponder()
            self.SettingSlicePanel.layer.zPosition = UIConstants.HiddenZ
        })
    }
    
    /// Load a settings slice.
    /// - Parameter Slice: The slice to load.
    func LoadSlice(_ Slice: SliceTypes)
    {
        let Story = UIStoryboard(name: "MainSettingSlices", bundle: nil)
        var VC: UIViewController!
         let NewHeight = HeightFor(Slice: Slice)
            SliceControllerHeight.constant = NewHeight
        switch Slice
        {
            case .ViewportSize:
                VC = Story.instantiateViewController(withIdentifier: "ViewportSizeSlice") as? ViewportSizeSlice
            
            case .BackgroundSettings:
                VC = Story.instantiateViewController(withIdentifier: "BackgroundSlice") as? BackgroundSlice
                
            case .AnimationSettings:
                VC = Story.instantiateViewController(withIdentifier: "AnimationSettingsSlice") as? AnimationSettingsSlice
            
            case .CircleSettings:
                VC = Story.instantiateViewController(withIdentifier: "CircleSettingSlice") as? CircleSettingSlice
                
            case .EllipseSettings:
                VC = Story.instantiateViewController(withIdentifier: "OvalSettingSlice") as? OvalSettingSlice
            
            case .RectangleSettings:
                VC = Story.instantiateViewController(withIdentifier: "RectangleSettingSlice") as? RectangleSettingSlice
               
            case .TriangleSettings:
                VC = Story.instantiateViewController(withIdentifier: "TriangleSettingSlice") as? TriangleSettingSlice
                
            case .GuidelineSettings:
                VC = Story.instantiateViewController(withIdentifier: "GuidelinesSlice") as? GuidelineSettingSlice
            
            case .NoShapeOptions:
                VC = Story.instantiateViewController(withIdentifier: "NoOptionsSlice") as? NoOptionsSlice
                (VC as? NoOptionsSlice)?.ShapeName = "unknown"
                
            case .DebugSlice:
                VC = Story.instantiateViewController(withIdentifier: "DebugSlice") as? DebugSlice
                
            case .TextFormatting:
                VC = Story.instantiateViewController(withIdentifier: "TextFormattingSlice") as? TextFormattingSlice
        
            case .OctagonSettings:
                VC = Story.instantiateViewController(withIdentifier: "OctagonSettingSlice") as? OctagonSlice
                
            case .HexagonSettings:
                VC = Story.instantiateViewController(withIdentifier: "HexagonSettingSlice") as? HexagonSlice
                
            case .SpiralLineSettings:
                VC = Story.instantiateViewController(withIdentifier: "SpiralSettingSlice") as? SpiralSliceSettings
                
            case .LineSettings:
                VC = Story.instantiateViewController(withIdentifier: "LineSlice") as? LineSlice
        }
        
        guard let ActualVC = VC else
        {
            Debug.FatalError("Error getting view controller for setting slice \(Slice.rawValue)")
        }
        if let OldController = PreviousController
        {
            OldController.removeFromParent()
            ActualVC.didMove(toParent: self)
        }
        PreviousController = ActualVC
        addChild(ActualVC)
        SliceContainer.addSubview(ActualVC.view)
        ActualVC.didMove(toParent: self)
        
        ActualVC.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        ActualVC.view.frame = SliceContainer.bounds
        
        SliceContainer.addSubview(ActualVC.view)
        ActualVC.didMove(toParent: self)
    }
    
    /// Return the height to use for the slice view. Some slices need more room.
    /// - Returns: The height of the slice view.
    func HeightFor(Slice: SliceTypes) -> CGFloat
    {
        switch Slice
        {
            case .RectangleSettings,
                    .TriangleSettings,
                    .LineSettings:
                return 310.0 + 70.0
                
            case .DebugSlice:
                return 310.0 + 60.0
                
            case .SpiralLineSettings:
                return 310.0 + 160.0
                
            default:
                return 310.0
        }
    }
    
    @IBAction func CloseSliceButtonHandler(_ sender: Any)
    {
        TextInput.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: [.allowUserInteraction],
                       animations:
                        {
            self.SettingSlicePanel.alpha = 0.0
        },
                       completion:
                        {
            _ in
            self.SettingSlicePanel.resignFirstResponder()
            self.SettingSlicePanel.layer.zPosition = UIConstants.HiddenZ
        })
    }
    
    
}
