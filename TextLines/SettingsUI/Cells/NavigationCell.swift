//
//  NavigationCell.swift
//  TextLine
//
//  Created by Stuart Rankin on 9/17/21.
//

import Foundation
import UIKit

typealias NavigationClosure = (Any?) -> ()

//https://kaushalelsewhere.medium.com/how-to-dismiss-keyboard-in-a-view-controller-of-ios-3b1bfe973ad1
class NavigationCell: UITableViewCell, UITextFieldDelegate, CellProtocol
{
    func SetWidth(_ Width: CGFloat)
    {
        CurrentWidth = Width > 1000.0 ? 1000.0 : Width
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
        HeaderLabel.textColor = UIColor.link
        contentView.addSubview(HeaderLabel)
    }
    
    public static var CellHeight: CGFloat
    {
        get
        {
            return 45
        }
    }
    
    func LoadCell(Header: String, Width: CGFloat, Token: Any? = nil, Closure: NavigationClosure? = nil)
    {
        self.Closure = Closure
        AnyToken = Token
        HeaderLabel.text = Header
        CurrentWidth = Width > 1000.0 ? 1000.0 : Width
        self.accessoryType = .disclosureIndicator
        let TapRecognizer = UITapGestureRecognizer(target: self, action: #selector(HandleTaps))
        TapRecognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(TapRecognizer)
    }
    
    var Closure: NavigationClosure? = nil
    
    @objc func HandleTaps(_ Recognizer: UITapGestureRecognizer)
    {
        Closure?(AnyToken)
    }
    
    var HeaderLabel: UILabel!
    var AnyToken: Any?
    
    var CurrentWidth: CGFloat = 0.0
    var Header: String = ""
}
