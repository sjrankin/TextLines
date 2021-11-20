//
//  CommandTableCell.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/19/21.
//

import Foundation
import UIKit

class CommandTableCell: UITableViewCell
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
    
    static let Height = 48.0
    
    func InitializeUI()
    {
        ButtonImage = UIImageView()
        ButtonTitle = UILabel(frame: CGRect(x: 60, y: 8, width: 200, height: 28))
        ButtonTitle?.font = UIFont.boldSystemFont(ofSize: 18.0)
        contentView.addSubview(ButtonTitle!)
        contentView.clipsToBounds = true
    }
    
    var ButtonImage: UIImageView? = nil
    var ButtonTitle: UILabel? = nil
    
    func LoadButton(Image: UIImageView2, Title: String, Width: CGFloat)
    {
        ButtonImage = Image
        ButtonImage?.frame = CGRect(x: 5, y: 1, width: 46, height: 46)
        contentView.addSubview(ButtonImage!)
        ButtonTitle?.text = Title
    }
}
