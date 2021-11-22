//
//  NoOptionsSlice.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/6/21.
//

import Foundation
import UIKit

class NoOptionsSlice: UIViewController
{
    var ShapeName: String? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = UIConstants.CornerRadius
        self.view.layer.borderColor = UIConstants.DarkBorder
        self.view.layer.borderWidth = UIConstants.ThickBorder
    }
    
    override func viewDidLayoutSubviews()
    {
        guard let ShapeName = ShapeName else
        {
            return
        }
        //MainTitle.text = "No Options for \(ShapeName)"
        Explanation.text = "No options available for \(ShapeName)"
    }
    
    @IBOutlet weak var MainTitle: UILabel!
    @IBOutlet weak var Explanation: UILabel!
}
