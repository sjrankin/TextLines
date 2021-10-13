//
//  UserShapeCell.swift
//  TextLine
//
//  Created by Stuart Rankin on 10/1/21.
//

import Foundation
import UIKit

class UserShapeCell: UITableViewCell
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
        ShapeImage = UIImageView(frame: CGRect(x: 15, y: 5, width: 32, height: 32))
        ShapeImage?.contentMode = .scaleAspectFit
        ShapeImage?.layer.borderWidth = 0.5
        ShapeImage?.layer.borderColor = UIColor.black.cgColor
        ShapeImage?.layer.cornerRadius = 3.0
        contentView.addSubview(ShapeImage!)
        HeaderLabel = UILabel(frame: CGRect(x: 60, y: 5, width: 300, height: 30))
        HeaderLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        HeaderLabel.textColor = UIColor.black
        contentView.addSubview(HeaderLabel)
    }
    
    func LoadCell(Header: String, Title: String, Width: CGFloat,
                  Image: UIImage? = nil,
                  Action: @escaping ButtonAction)
    {
        self.selectionStyle = .blue
        ShapeImage?.image = Image
        HeaderLabel.text = Header
        CurrentWidth = Width > 1000.0 ? 1000.0 : Width
        Button = UIButton()
        SetButtonTitle(Title)
        SetButtonAction(Action)
        Button?.addTarget(self, action: #selector(RunButtonAction), for: .touchUpInside)
        contentView.addSubview(Button!)
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
            if CurrentlySelected
            {
                self.accessoryType = .none
            }
        }
        else
        {
            UIView.animate(withDuration: 0.5)
            {
                self.Button?.alpha = 1.0
            }
            if CurrentlySelected
            {
                self.accessoryType = .checkmark
            }
        }
    }
    
    func SetButtonTitle(_ NewTitle: String)
    {
        if Button == nil
        {
            Debug.FatalError("Title assigned to button before button created.")
        }
        Button?.setTitleColor(UIColor.link, for: .normal)
        Button?.setTitle(NewTitle, for: .normal)
        let BFrame = CGRect(x: (CurrentWidth - 30) - (70 + 10),
                            y: (ButtonCell.CellHeight / 2) - (25 / 2),
                            width: 70, height: 25)
        Button?.frame = BFrame
    }
    
    @objc func RunButtonAction()
    {
        PressAction?()
    }
    
    func SetButtonAction(_ Action: @escaping ButtonAction)
    {
        PressAction = Action
    }
    
    func SelectShape(_ IsSelected: Bool)
    {
        CurrentlySelected = IsSelected
            self.accessoryType = IsSelected ? .checkmark : .none
    }
    
    var CurrentlySelected: Bool = false
    var PressAction: ButtonAction? = nil
    var HeaderLabel: UILabel!
    var Button: UIButton? = nil
    var CurrentWidth: CGFloat = 0.0
    var Header: String = ""
    var ShapeImage: UIImageView? = nil
    
    public static var CellHeight: CGFloat
    {
        get
        {
            return 45
        }
    }
}
