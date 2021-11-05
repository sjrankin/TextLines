//
//  StringCell.swift
//  StringCell
//
//  Created by Stuart Rankin on 9/13/21.
//

import Foundation
import UIKit

//https://kaushalelsewhere.medium.com/how-to-dismiss-keyboard-in-a-view-controller-of-ios-3b1bfe973ad1
class StringCell: UITableViewCell, UITextFieldDelegate, CellProtocol
{
    func SetWidth(_ Width: CGFloat)
    {
        CurrentWidth = Width > 1000.0 ? 1000.0 : Width
        TextField.removeFromSuperview()
        TextField = UITextField(frame: CGRect(x: CurrentWidth - (180 + 10),
                                              y: StringCell.CellHeight / 2 - 30 / 2,
                                              width: 180, height: 30))
        TextField.delegate = self
        TextField.borderStyle = .roundedRect
        TextField.keyboardType = .default
        TextField.returnKeyType = .done
        TextField.textAlignment = .right
        contentView.addSubview(TextField)
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
        TextField = UITextField(frame: CGRect(x: CurrentWidth - (180 + 10),
                                              y: StringCell.CellHeight / 2 - 30 / 2,
                                              width: 180, height: 30))
        TextField.delegate = self
        TextField.borderStyle = .roundedRect
        TextField.keyboardType = .default
        TextField.returnKeyType = .done
        TextField.textAlignment = .right
        contentView.addSubview(HeaderLabel)
        contentView.addSubview(TextField)
    }
    
    func SetupTextField()
    {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Dismiss", style: .done,
                                         target: self, action: #selector(KeyboardDoneButtonTapped))
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        TextField.inputAccessoryView = toolbar
    }
    
    @objc func KeyboardDoneButtonTapped()
    {
        self.contentView.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        guard let Key = Setting else
        {
            return
        }
        if let Result = textField.text
        {
            Settings.SetString(Key, Result)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    public static var CellHeight: CGFloat
    {
        get
        {
            return 45
        }
    }
    
    func LoadCell(Setting: SettingKeys, Header: String, Width: CGFloat)
    {
        if Width < 300
        {
            TextFieldWidth = 80.0
        }
        self.Setting = Setting
        HeaderLabel.text = Header
        CurrentWidth = Width > 1000.0 ? 1000.0 : Width
        TextField.frame = CGRect(x: CurrentWidth - (TextFieldWidth + 10),
                                 y: StringCell.CellHeight / 2 - 30 / 2,
                                 width: TextFieldWidth, height: 30)
        let InitialValue = Settings.GetString(Setting)
        TextField.text = InitialValue
        TextField.clearButtonMode = .always
        TextField.layer.borderColor = UIColor.gray.cgColor
        TextField.layer.borderWidth = 0.5
        TextField.layer.cornerRadius = 5.0
        TextField.layer.backgroundColor = UIColor.yellow.cgColor
        SetupTextField()
    }
    
    var HeaderLabel: UILabel!
    var TextField: UITextField!
    var TextFieldWidth: CGFloat = 180.0
    var Setting: SettingKeys? = nil
    var CurrentWidth: CGFloat = 0.0
    var Header: String = ""
}
