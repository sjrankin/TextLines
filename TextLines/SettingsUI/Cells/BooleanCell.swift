//
//  BooleanCell.swift
//  BooleanCell
//
//  Created by Stuart Rankin on 8/16/21.
//

import Foundation
import UIKit

typealias BooleanCellClosure = (Bool) -> ()

class BooleanCell: UITableViewCell
{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        InitializeUI()
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    func InitializeUI()
    {
        self.selectionStyle = .none
        HeaderLabel = UILabel(frame: CGRect(x: 15, y: 5, width: 300, height: 30))
        HeaderLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        HeaderLabel.textColor = UIColor.black
        SettingSwitch = UISwitch(frame: CGRect(x: CurrentWidth - (51 + 10), y: BooleanCell.CellHeight / 2 - 34 / 2,
                                               width: 51, height: 34))
        SettingSwitch.addTarget(self, action: #selector(self.SwitchChanged(_:)),
                                for: .valueChanged)
        contentView.addSubview(HeaderLabel)
        contentView.addSubview(SettingSwitch)
    }
    
    @objc func SwitchChanged(_ sender: Any)
    {
        if let Switch = sender as? UISwitch
        {
            if let Key = Setting
            {
            Settings.SetBool(Key, Switch.isOn)
                Closure?(Switch.isOn)
            }
        }
    }
    
    public static var CellHeight: CGFloat
    {
        get
        {
            return 45
        }
    }
    
    func LoadCell(Setting: SettingKeys, Header: String,
                  Width: CGFloat, Closure: BooleanCellClosure? = nil)
    {
        self.Closure = Closure
        self.Setting = Setting
        HeaderLabel.text = Header
        CurrentWidth = Width > 1000.0 ? 1000.0 : Width
        SettingSwitch.frame = CGRect(x: CurrentWidth - (51 + 10),
                                     y: BooleanCell.CellHeight / 2 - 34 / 2,
                                     width: 51, height: 34)
        let InitialValue = Settings.GetBool(Setting)
        SettingSwitch.isOn = InitialValue
    }
    
    var Closure: BooleanCellClosure? = nil
    var HeaderLabel: UILabel!
    var SettingSwitch: UISwitch!
    
    var Setting: SettingKeys? = nil
    var CurrentWidth: CGFloat = 0.0
    var Header: String = ""
}
