//
//  SettingsEditor.swift
//  SettingsEditor
//
//  Created by Stuart Rankin on 9/13/21.
//

import Foundation
import UIKit

class SettingsEditor: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        guard let Parent = self.presentingViewController else
        {
            return
        }
        // Parent is DebugUICode.
        print("Parent=\(Parent)")
        if Parent.isKind(of: DebugUICode.self)
        {
            DoneButton.isHidden = true
            FromSettingsPanel = false
        }
    }
    
    var FromSettingsPanel = true
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        SettingsViewTable.layer.borderColor = UIColor.gray.cgColor
        SettingsViewTable.layer.borderWidth = 0.5
        SettingsViewTable.layer.cornerRadius = 5.0
        SettingsViewTable.reloadData()
    }
    
    let SetStruct = SettingsStructure.Groups
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return SetStruct[section].GroupName
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return SetStruct[section].GroupSettings.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return SetStruct.count
    }
    
    var BGIndex = 0
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let SomeSetting = SetStruct[indexPath.section].GroupSettings[indexPath.row].0
        let ColorIndex = BGIndex.isMultiple(of: 2) ? 0 : 1
        let BGColor = [UIColor(named: "OptionsColor0"), UIColor(named: "OptionsColor1")][ColorIndex]
        let Header = Settings.SettingKeyHeaders[SomeSetting]!
        let Cell = SettingItem.GenerateCell(Header: Header, With: tableView.frame.width,
                                            SettingKey: SomeSetting)
        Cell?.backgroundColor = BGColor
        BGIndex = BGIndex + 1
        return Cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let Key = SetStruct[indexPath.section].GroupSettings[indexPath.row].0
        guard let KeyType = Settings.SettingKeyTypes[Key] else
        {
            return 0
        }
        let KeyTypeName = "\(KeyType)"
        switch KeyTypeName
        {
            case "Bool":
                return BooleanCell.CellHeight
                
            case "Int":
                return IntCell.CellHeight
                
            case "Double":
                return DoubleCell.CellHeight
                
            case "CGFloat":
                return CGFloatCell.CellHeight
                
            case "UIColor":
                return ColorCell.CellHeight
                
            case "String":
                return StringCell.CellHeight
                
            case "Array<String>":
                return ArrayCell.CellHeight
                
            case "ShapeCategories", "Shapes", "Backgrounds", "ShapeAlignments",
                "LineOptions", "LineStyles":
                return EnumCell.CellHeight
                
            default:
                print("Uncomprehended type: \(KeyTypeName)")
                return 10
        }
    }
    
    @IBAction func DoneButtonHandler(_ sender: Any)
    {
        if FromSettingsPanel
        {
            self.dismiss(animated: true)
        }
        else
        {
        self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var DoneButton: UIButton!
    @IBOutlet weak var SettingsViewTable: UITableView!
}
