//
//  StyleSettings.swift
//  TextLine
//
//  Created by Stuart Rankin on 9/18/21.
//

import Foundation
import UIKit

class StyleSettings: UIViewController, CommandBarProtocol
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        RawSource = Settings.GetStrings(.CommandButtonList, Delimiter: ",", Default: ["ActionButton", "ShapeOptionsButton"])
        for Other in CommandButtons.allCases
        {
            let SomeCommand = Other.rawValue
            if RawSource.contains(SomeCommand)
            {
                continue
            }
            UnusedSource.append(SomeCommand)
        }
        PopulateCurrentButtonBar()
        PopulateUnusedButtonBar()
    }
    
    var RawSource = [String]()
    var UnusedSource = [String]()
    var CurrentBar: CommandBarManager!
    var NotUsedBar: CommandBarManager!
    
    func PopulateCurrentButtonBar()
    {
        CurrentBar = CommandBarManager(CommandBar: ActualScroller,
                                       Buttons: RawSource,
                                       EnableLongPress: true,
                                       EnableDoubleTap: true)
        CurrentBar.delegate = self
    }
    
    func PopulateUnusedButtonBar()
    {
        NotUsedBar = CommandBarManager(CommandBar: NotUsedScroller,
                                       Buttons: UnusedSource,
                                       EnableLongPress: true,
                                       EnableDoubleTap: true)
        NotUsedBar.delegate = self
    }
    
    // MARK: - Main protocol functions.
    
    func ExecuteCommand(_ sender: CommandBarManager, Command: CommandButtons)
    {
        switch sender
        {
            case NotUsedBar:
                if let Index = UnusedSource.firstIndex(of: Command.rawValue)
                {
                    UnusedSource.remove(at: Index)
                    RawSource.append(Command.rawValue)
                    NotUsedBar.UpdateButtons(NewButtons: UnusedSource)
                    CurrentBar.UpdateButtons(NewButtons: RawSource)
                    IsDirty = true
                }
                
            case CurrentBar:
                if [CommandButtons.ActionButton,
                    CommandButtons.ShapeOptionsButton].contains(Command)
                {
                    print("Tapped on permanent button.")
                    return
                }
                if let Index = RawSource.firstIndex(of: Command.rawValue)
                {
                    RawSource.remove(at: Index)
                    UnusedSource.append(Command.rawValue)
                    NotUsedBar.UpdateButtons(NewButtons: UnusedSource)
                    CurrentBar.UpdateButtons(NewButtons: RawSource)
                    IsDirty = true
                }
                
            default:
                break
        }
    }
    
    func LongTapOn(_ sender: CommandBarManager, Command: CommandButtons)
    {
    }
    
    func DoubleTap(_ sender: CommandBarManager, Command: CommandButtons)
    {
    }
    
    func ButtonHorizontalGap(_ sender: CommandBarManager) -> CGFloat
    {
        return 16.0
    }
    
    func InitialGap(_ sender: CommandBarManager) -> CGFloat
    {
        switch sender
        {
            case NotUsedBar:
                return 16.0
                
            case CurrentBar:
                return -8.0
                
            default:
                return 16.0
        }
    }
    
    func HasTitles(_ sender: CommandBarManager) -> Bool
    {
        return true
    }
    
    func TitleColor(_ sender: CommandBarManager, Command: CommandButtons) -> UIColor?
    {
        switch sender
        {
            case CurrentBar:
                switch Command
                {
                    case .ActionButton, .ShapeOptionsButton:
                        return UIColor.gray
                        
                    default:
                        return nil
                }
                
            default:
                return nil
        }
    }
    
    func HighlightTappedButtons(_ sender: CommandBarManager) -> Bool
    {
        return false
    }
    
    func ButtonColor(_ sender: CommandBarManager, Command: CommandButtons) -> UIColor?
    {
        switch sender
        {
            case NotUsedBar:
                return UIColor.Gray(Percent: 0.8)
                
            case CurrentBar:
                switch Command
                {
                    case .ActionButton, .ShapeOptionsButton:
                        return UIColor.gray
                        
                    default:
                        return nil
                }
                
            default:
                return nil
        }
    }
    
    func TitleFontSize(_ sender: CommandBarManager, Command: CommandButtons) -> CGFloat
    {
        switch sender
        {
            case NotUsedBar:
                return 14.0
                
            case CurrentBar:
                return 10.0
                
            default:
                return 14.0
        }
    }
    
    func CommandButtonSize(_ sender: CommandBarManager, Command: CommandButtons) -> CGSize?
    {
        switch sender
        {
            case NotUsedBar:
                return CGSize(width: 60, height: 60)
                
            case CurrentBar:
                return CGSize(width: 34, height: 34)
                
            default:
                return CGSize(width: 60, height: 60)
        }
    }
    
    func ShapeGroupSelected(_ sender: CommandBarManager, NewCategory: ShapeCategories)
    {
    }
    
    func ShapeSelected(_ sender: CommandBarManager, NewShape: Shapes)
    {
        
    }
    
    var IsDirty = false
    
    @IBAction func CloseWindow(_ sender: Any)
    {
        if IsDirty
        {
            Settings.SetStrings(.CommandButtonList, RawSource)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var NotUsedScroller: UIScrollView!
    @IBOutlet weak var ActualScroller: UIScrollView!
}

