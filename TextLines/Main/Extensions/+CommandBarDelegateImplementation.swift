//
//  +CommandBarDelegateImplementation.swift
//  TextLines
//
//  Created by Stuart Rankin on 12/4/21.
//

import Foundation
import UIKit

extension ViewController: CommandBarProtocol
{
    // MARK: - Command bar delegate functions.
    
    func HasTitles(_ sender: CommandBarManager) -> Bool
    {
        switch sender
        {
            case CommandScroller:
                return true
                
            default:
                return false
        }
    }
    
    func TitleFontSize(_ sender: CommandBarManager, Command: CommandButtons) -> CGFloat
    {
        return 14.0
    }
    
    func TitleColor(_ sender: CommandBarManager, Command: CommandButtons) -> UIColor?
    {
        return nil
    }
    
    func ButtonHorizontalGap(_ sender: CommandBarManager) -> CGFloat
    {
        return 16.0
    }
    
    func InitialGap(_ sender: CommandBarManager) -> CGFloat
    {
        return 0.0
    }
    
    func DoubleTap(_ sender: CommandBarManager, Command: CommandButtons)
    {
        //Not used here.
    }
    
    /// Handle long taps on command buttons. Nothing done here.
    func LongTapOn(_ Command: CommandButtons)
    {
        //Not used here.
    }
    
    func LongTapOn(_ sender: CommandBarManager, Command: CommandButtons)
    {
        
    }
    
    func ButtonColor(_ sender: CommandBarManager, Command: CommandButtons) -> UIColor?
    {
        return UIColor.systemBlue
    }
    
    func HighlightTappedButtons(_ sender: CommandBarManager) -> Bool
    {
        return false
    }
    
    func CommandButtonSize(_ sender: CommandBarManager, Command: CommandButtons) -> CGSize?
    {
        switch sender
        {
            case CommandScroller:
                return CGSize(width: UIConstants.MainIconWidth,
                              height: UIConstants.MainIconHeight)
                
            default:
                return CGSize(width: UIConstants.DefaultIconWidth,
                              height: UIConstants.DefaultIconHeight)
        }
    }
    
    /// Execute the passed command. Commands are passed from the main command panel.
    /// - Note: Unknown/unimplemented commands are ignored.
    /// - Parameter Command: The command to execute.
    func ExecuteCommand(_ sender: CommandBarManager, Command: CommandButtons)
    {
        switch Command
        {
            case .ActionButton:
                SettingPanel.layer.zPosition = 1000
                TextInput.isUserInteractionEnabled = false
                UIView.animate(withDuration: 0.3,
                               delay: 0.0,
                               options: [.curveEaseIn],
                               animations:
                                {
                    self.SettingPanel.alpha = 1.0
                },
                               completion:
                                {
                    _ in
                    self.SettingPanel.becomeFirstResponder()
                })
                
            case .ProjectButton:
                break
            case .CameraButton:
                break
            case .VideoButton:
                break
                
            case .SaveButton:
                SaveCurrentImage()
                
            case .ShareButton:
                guard let ImageToShare = TextOutput.image else
                {
                    Debug.Print("No image to share")
                    return
                }
                SharedImage = ImageToShare
                ShareCurrentImage()
                
            case .TextFormatButton:
                ShowSliceHandler(.TextFormatting)
                
#if DEBUG
            case .DebugButton:
                ShowSliceHandler(.DebugSlice)
#endif
                
            case .FontButton:
                ShowSliceHandler(.FontSlice)
                
            case .DimensionsButton:
                ShowSliceHandler(.ViewportSize)
                
            case .PlayButton:                
                SetAnimationState()
                
            case .UserButton:
                let Storyboard = UIStoryboard(name: "UserShapes", bundle: nil)
                let VC = Storyboard.instantiateViewController(withIdentifier: "UserShapeController") as! UserShapeController
                self.present(VC, animated: true)
                
            case .BackgroundButton:
                ShowSliceHandler(.BackgroundSettings)
                
            case .ShapeCommonOptionsButton:
                ShowSliceHandler(.CommonSettings)
                
            case .ShapeOptionsButton:
                switch Settings.GetEnum(ForKey: .CurrentShape, EnumType: Shapes.self, Default: .Circle)
                {
                    case .Circle:
                        ShowSliceHandler(.CircleSettings)
                        
                    case .Ellipse:
                        ShowSliceHandler(.EllipseSettings)
                        
                    case .Rectangle:
                        ShowSliceHandler(.RectangleSettings)
                        
                    case .Triangle:
                        ShowSliceHandler(.TriangleSettings)
                        
                    case .Octagon:
                        ShowSliceHandler(.OctagonSettings)
                        
                    case .Hexagon:
                        ShowSliceHandler(.HexagonSettings)
                        
                    case .Line:
                        ShowSliceHandler(.LineSettings)
                        
                    case .Spiral:
                        ShowSliceHandler(.SpiralLineSettings)
                        
                    case .Star:
                        ShowSliceHandler(.StarSlice)
                        
                    case .NGon:
                        ShowSliceHandler(.NGonSlice)
                        
                    default:
                        break
                }
                
            case .AnimationButton:
                ShowSliceHandler(.AnimationSettings)
                
            case .GuidelinesButton:
                ShowSliceHandler(.GuidelineSettings)
        }
    }
    
    func ShapeGroupSelected(_ sender: CommandBarManager, NewCategory: ShapeCategories)
    {
        
    }
    
    func ShapeSelected(_ sender: CommandBarManager, NewShape: Shapes)
    {
        
    }
}
