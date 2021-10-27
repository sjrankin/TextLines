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
        RawSource = Settings.GetStrings(.CommandButtonList, Delimiter: ",", Default: ["ActionButton"])
        RawSource = [CommandButtons.ActionButton.rawValue,
                     CommandButtons.UserButton.rawValue,
                     CommandButtons.CameraButton.rawValue,
                     CommandButtons.FontButton.rawValue,
                     CommandButtons.PlayButton.rawValue,
                     CommandButtons.SaveButton.rawValue,
                     CommandButtons.ShareButton.rawValue]
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
        CurrentBar = CommandBarManager(CommandBar: ActualScroller,//CommandSampleBar,
                                       Buttons: RawSource,
                                       EnableLongPress: true,
                                       EnableDoubleTap: true)
        CurrentBar.delegate = self
    }
    
    func PopulateUnusedButtonBar()
    {
        NotUsedBar = CommandBarManager(CommandBar: AvailableScroller,//CommandSourceBar,
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
                }
                
            case CurrentBar:
                if Command == .ActionButton
                {
                    print("Tapped on permanent action button.")
                    return
                }
                if let Index = RawSource.firstIndex(of: Command.rawValue)
                {
                    RawSource.remove(at: Index)
                    UnusedSource.append(Command.rawValue)
                    NotUsedBar.UpdateButtons(NewButtons: UnusedSource)
                    CurrentBar.UpdateButtons(NewButtons: RawSource)
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
        return 12.0
    }
    
    func TitleColor(_ sender: CommandBarManager, Command: CommandButtons) -> UIColor?
    {
        switch sender
        {
            case CurrentBar:
                if Command == .ActionButton
                {
                    return UIColor.gray
                }
                else
                {
                    return nil
                }
                
            default:
                return nil
        }
    }
    
    func ButtonColor(_ sender: CommandBarManager, Command: CommandButtons) -> UIColor?
    {
        switch sender
        {
            case NotUsedBar:
                return UIColor.black
                
            case CurrentBar:
                if Command == .ActionButton
                {
                    return UIColor.gray
                }
                return nil
                
            default:
                return nil
        }
    }
    
    func CommandButtonSize(_ sender: CommandBarManager, Command: CommandButtons) -> CGSize?
    {
        return CGSize(width: 60, height: 60)
    }
    
    @IBAction func DoneButtonHandler(_ sender: Any)
    {
        self.dismiss(animated: true)
    }
    
    @IBOutlet weak var ActualScroller: UIScrollView!
    @IBOutlet weak var AvailableScroller: UIScrollView!
    //@IBOutlet weak var CommandSampleBar: UIView!
    //@IBOutlet weak var CommandSourceBar: UIView!
}

