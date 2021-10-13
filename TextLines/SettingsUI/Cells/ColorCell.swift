//
//  ColorCell.swift
//  ColorCell
//
//  Created by Stuart Rankin on 9/13/21.
//

import Foundation
import UIKit

class ColorCell: UITableViewCell
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
        contentView.addSubview(HeaderLabel)
    }
    
    public static var CellHeight: CGFloat
    {
        get
        {
            return 45
        }
    }
    
    @objc func ColorChanged(_ sender: Any)
    {
        if let Color = ColorPicker.selectedColor
        {
            if let ColorSetting = Setting
            {
            Settings.SetColor(ColorSetting, Color)
            }
        }
    }
    
    func LoadCell(Setting: SettingKeys, Header: String, Width: CGFloat)
    {
        self.Setting = Setting
        HeaderLabel.text = Header
        CurrentWidth = Width > 1000.0 ? 1000.0 : Width
        ColorPicker = UIColorWell(frame: CGRect(x: CurrentWidth - (WellHeight + 10),
                                                y: ColorCell.CellHeight / 2 - WellHeight / 2,
                                                width: WellHeight, height: WellHeight))
        ColorPicker.supportsAlpha = true
        ColorPicker.addTarget(self, action: #selector(ColorChanged(_:)), for: .valueChanged)
        let InitialValue = Settings.GetColor(Setting, UIColor.white)
        ColorPicker.selectedColor = InitialValue
        contentView.addSubview(ColorPicker)
    }
    
    let WellHeight: CGFloat = 35
    var HeaderLabel: UILabel!
    var ColorPicker: UIColorWell!
    
    var Setting: SettingKeys? = nil
    var CurrentWidth: CGFloat = 0.0
    var Header: String = ""
    var SubHeader: String? = nil
}
