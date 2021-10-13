//
//  AttributionCell.swift
//  AttributionCell
//
//  Created by Stuart Rankin on 9/2/21.
//

import Foundation
import UIKit

class AttributionCell: UITableViewCell
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
        HeaderLabel = UILabel(frame: CGRect(x: 15, y: 2, width: 300, height: 24))
        HeaderLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        HeaderLabel.textColor = UIColor.black
        SubHeaderLabel = UILabel(frame: CGRect(x: 15, y: 32, width: 300, height: 25))
        SubHeaderLabel.font = UIFont.systemFont(ofSize: 14)
        SubHeaderLabel.textColor = UIColor.black
        SubHeaderLabel.textAlignment = .left
        contentView.addSubview(HeaderLabel)
        contentView.addSubview(SubHeaderLabel)
        contentView.clipsToBounds = true
    }
    
    public static var CellHeight: CGFloat
    {
        get
        {
            return 60
        }
    }
    
    func LoadCell(Header: String, SubHeader: String, Width: CGFloat,
                  IsLink: Bool = true)
    {
        HeaderLabel.text = Header
        SubHeaderLabel.text = SubHeader
        if IsLink
        {
            HeaderLabel.textColor = UIColor.link
        }
    }
    
    var HeaderLabel: UILabel!
    var SubHeaderLabel: UILabel!
    var TextField: UITextField!
    var CurrentWidth: CGFloat = 0.0
    var Header: String = ""
    var SubHeader: String? = nil
}
