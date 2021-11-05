//
//  BooleanCell.swift
//  BooleanCell
//
//  Created by Stuart Rankin on 8/16/21.
//

import Foundation
import UIKit

typealias BooleanCellClosure = (Bool) -> ()

class BooleanCell: UITableViewCell,
                   CellProtocol
{
    func SetWidth(_ Width: CGFloat)
    {
        CurrentWidth = Width > 1000.0 ? 1000.0 : Width
        SettingSwitch.removeFromSuperview()
        SettingSwitch = UISwitch(frame: CGRect(x: CurrentWidth - (51 + 10), y: BooleanCell.CellHeight / 2 - 34 / 2,
                                               width: 51, height: 34))
        SettingSwitch.addTarget(self, action: #selector(self.SwitchChanged(_:)),
                                for: .valueChanged)
        contentView.addSubview(SettingSwitch)
        AdjustedWidth = Width
    }
    
    var AdjustedWidth: CGFloat = 0.0
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
        SettingSwitch = UISwitch(frame: CGRect(x: CurrentWidth - (51 + 10),
                                               y: GetSwitchYPosition(),
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
                                     y: GetSwitchYPosition(),
                                     width: 51, height: 34)
        let InitialValue = Settings.GetBool(Setting)
        SettingSwitch.isOn = InitialValue
    }
    
    /// Get a vertically centered Y position for the `UISwitch`.
    /// - Returns: Value to use as the Y position for the `UISwitch`.
    func GetSwitchYPosition() -> CGFloat
    {
        var Y = BooleanCell2.CellHeight / 2.0
        let Scratch = UISwitch()
        Y = Y - Scratch.frame.height / 2
        Y = Y / 2
        return Y
    }
    
    var Closure: BooleanCellClosure? = nil
    var HeaderLabel: UILabel!
    var SettingSwitch: UISwitch!
    
    var Setting: SettingKeys? = nil
    var CurrentWidth: CGFloat = 0.0
    var Header: String = ""
}
