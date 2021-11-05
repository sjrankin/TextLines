//
//  ButtonCell.swift
//  TextLine
//
//  Created by Stuart Rankin on 9/16/21.
//

import Foundation
import UIKit

typealias ButtonAction = () -> ()

class ButtonCell: UITableViewCell, CellProtocol
{
    func SetWidth(_ Width: CGFloat)
    {
        CurrentWidth = Width > 1000.0 ? 1000.0 : Width
        Button?.removeFromSuperview()
        Button = UIButton()
        SetButtonTitle(PassedButtonTitle)
        Button?.addTarget(self, action: #selector(RunButtonAction), for: .touchUpInside)
        Button?.setTitleColor(UIColor.link, for: .normal)
        let BFrame = CGRect(x: CurrentWidth - (70 + 10),
                            y: (ButtonCell.CellHeight / 2) - (23 / 2),
                            width: 70, height: 25)
        Button?.frame = BFrame
        contentView.addSubview(Button!)
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
        contentView.addSubview(HeaderLabel)
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
        self.Setting = Setting
        HeaderLabel.text = Header
        CurrentWidth = Width > 1000.0 ? 1000.0 : Width
        Button = UIButton()
        Button?.addTarget(self, action: #selector(RunButtonAction), for: .touchUpInside)
        contentView.addSubview(Button!)
    }
    
    func LoadCell(Header: String, Title: String, Width: CGFloat,
                  Action: @escaping ButtonAction)
    {
        HeaderLabel.text = Header
        CurrentWidth = Width > 1000.0 ? 1000.0 : Width
        Button = UIButton()
        SetButtonTitle(Title)
        SetButtonAction(Action)
        Button?.addTarget(self, action: #selector(RunButtonAction), for: .touchUpInside)
        contentView.addSubview(Button!)
    }
    
    func SetButtonTitle(_ NewTitle: String)
    {
        if Button == nil
        {
            Debug.FatalError("Title assigned to button before button created.")
        }
        PassedButtonTitle = NewTitle
        Button?.setTitleColor(UIColor.link, for: .normal)
        Button?.setTitle(NewTitle, for: .normal)
        let BFrame = CGRect(x: CurrentWidth - (70 + 10),
                               y: (ButtonCell.CellHeight / 2) - (23 / 2),
                               width: 70, height: 25)
        Button?.frame = BFrame
    }
    
    var PassedButtonTitle: String = ""

    @objc func RunButtonAction()
    {
        PressAction?()
    }
    
    func SetButtonAction(_ Action: @escaping ButtonAction)
    {
        PressAction = Action
    }
    
    override func willTransition(to state: UITableViewCell.StateMask)
    {
        super.willTransition(to: state)
        if ((state.rawValue & UITableViewCell.StateMask.showingEditControl.rawValue) != 0)
        {
            UIView.animate(withDuration: 0.1)
            {
                self.Button?.alpha = 0.0
            }
        }
        else
        {
            UIView.animate(withDuration: 0.5)
            {
                self.Button?.alpha = 1.0
            }
        }
    }
    
    var PressAction: ButtonAction? = nil
    var HeaderLabel: UILabel!
    var Button: UIButton? = nil
    
    var Setting: SettingKeys? = nil
    var CurrentWidth: CGFloat = 0.0
    var Header: String = ""
    var SubHeader: String? = nil
}
