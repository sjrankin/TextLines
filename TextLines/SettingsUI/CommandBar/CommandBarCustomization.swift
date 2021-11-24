//
//  CommandBarCustomization.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/19/21.
//

import Foundation
import UIKit

class CommandBarCustomization: UIViewController, UITableViewDelegate,
                               UITableViewDataSource, CommandBarProtocol
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        RawSource = Settings.GetStrings(.CommandButtonList, Delimiter: ",", Default: ["ActionButton", "ShapeOptionsButton"])
        #if !DEBUG
        RawSource.removeAll(where: {$0 == "Debug"})
        #endif
        for Other in CommandButtons.allCases
        {
            let SomeCommand = Other.rawValue
            if RawSource.contains(SomeCommand)
            {
                continue
            }
            UnusedSource.append(SomeCommand)
        }
        
        CurrentButtonTable.layer.borderWidth = 0.5
        CurrentButtonTable.layer.borderColor = UIColor.gray.cgColor
        CurrentButtonTable.layer.cornerRadius = 5.0
        
        PopulateCurrentButtonBar()
        PopulateUnusedButtonBar()
    }
    
    var IsDirty = false
    var RawSource = [String]()
    var UnusedSource = [String]()
    var NotUsedBar: CommandBarManager!

    func PopulateCurrentButtonBar()
    {
        CurrentButtonTable.reloadData()
    }
    
    func PopulateUnusedButtonBar()
    {
        NotUsedBar = CommandBarManager(CommandBar: NotUsedScroller,
                                       Buttons: UnusedSource,
                                       EnableLongPress: true,
                                       EnableDoubleTap: true)
        NotUsedBar.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return RawSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let Cell = CommandTableCell(style: .default, reuseIdentifier: "CommandTableCell")
        guard let Command = CommandButtons(rawValue: RawSource[indexPath.row]) else
        {
            Debug.FatalError("Error converting \(RawSource[indexPath.row]) to a command button.")
        }
        let ButtonImage = NotUsedBar.ReturnButtonImage(For: Command,
                                                       Size: CGSize(width: 46, height: 46),
                                                       ButtonColor: .PrussianBlue)
        Cell.LoadButton(Image: ButtonImage,
                        Title: NotUsedBar.ReturnButtonLongTitle(For: Command),
                        Width: tableView.frame.width)
        return Cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
    {
        let RawCommand = RawSource[indexPath.row]
        guard let Command = CommandButtons(rawValue: RawCommand) else
        {
            Debug.FatalError("* Error \(RawSource[indexPath.row]) to a command button.")
        }
        if [CommandButtons.ActionButton,
            CommandButtons.ShapeOptionsButton].contains(Command)
        {
            return UITableViewCell.EditingStyle.none
        }
        else
        {
            return UITableViewCell.EditingStyle.delete
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        RawSource.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        IsDirty = true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let RemoveMe = RawSource[indexPath.row]
            RawSource.remove(at: indexPath.row)
            UnusedSource.append(RemoveMe)
            IsDirty = true
        }
        CurrentButtonTable.reloadData()
        NotUsedBar.UpdateButtons(NewButtons: UnusedSource)
    }
    
    var CurrentlyEditing = false
    
    @IBAction func EditButtonHandler(_ sender: Any)
    {
        CurrentlyEditing = !CurrentlyEditing
        EditCurrentButtonsButton.setTitle(CurrentlyEditing ? "Done" : "Edit", for: .normal)
        EditCurrentButtonsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        CurrentButtonTable.setEditing(CurrentlyEditing, animated: true)
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
                    IsDirty = true
                    CurrentButtonTable.reloadData()
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
        return nil
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
    
    @IBAction func CloseWindow(_ sender: Any)
    {
        if IsDirty
        {
            Settings.SetStrings(.CommandButtonList, RawSource)
        }
        self.dismiss(animated: true, completion: nil)
    }
  
    @IBOutlet weak var NotUsedScroller: UIScrollView!
    @IBOutlet weak var CurrentButtonTable: UITableView!
    @IBOutlet weak var EditCurrentButtonsButton: UIButton!
}
