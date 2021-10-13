//
//  IndividualShapes.swift
//  IndividualShapes
//
//  Created by Stuart Rankin on 8/29/21.
//

import Foundation
import UIKit

class IndividualShapes: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        SettingTable.layer.borderColor = UIColor.gray.cgColor
        SettingTable.layer.cornerRadius = 5.0
        SettingTable.layer.borderWidth = 1.0
        SettingTable.layer.backgroundColor = UIColor.systemGray2.cgColor
        SetOptionsFor(Settings.GetEnum(ForKey: .CurrentShape, EnumType: Shapes.self, Default: .Circle))
    }
    
    var HeaderHeight: CGFloat = 50.0
    var CurrentShapeOptions: OptionItem? = nil
    var OptionsList: [OptionItem] = [OptionItem]()
    
    @IBOutlet weak var SettingTable: UITableView!
}
