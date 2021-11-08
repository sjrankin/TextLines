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
        self.view.layer.cornerRadius = 5.0
        self.view.layer.borderColor = UIColor.black.cgColor
        self.view.layer.borderWidth = 1.5
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
