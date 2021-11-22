//
//  TextFormattingSlice.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/6/21.
//

import Foundation
import UIKit

class TextFormattingSlice: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = UIConstants.CornerRadius
        self.view.layer.borderColor = UIConstants.DarkBorder
        self.view.layer.borderWidth = UIConstants.ThickBorder

        FontColorWell.clipsToBounds = true
        FontColorWell.selectedColor = Settings.GetColor(.TextColor, .black)
        FontColorWell.supportsAlpha = true
        FontColorWell.addTarget(self, action: #selector(TextColorChangedHandler(_:)), for: .valueChanged)
    }
    
    @objc func TextColorChangedHandler(_ sender: Any)
    {
        if let Well = sender as? UIColorWell
        {
            if let FinalColor = Well.selectedColor
            {
                Settings.SetColor(.TextColor, FinalColor)
            }
        }
    }
    
    @IBAction func SelectFontTapped(_ sender: Any)
    {
    }

    @IBAction func RotateSwitchChangeHandler(_ sender: Any)
    {
    }
    
    @IBAction func AlignmentControlChanged(_ sender: Any)
    {
    }
    
    @IBOutlet weak var AlignmentControl: UISegmentedControl!
    @IBOutlet weak var FontColorWell: UIColorWell!
    @IBOutlet weak var FontNameLabel: UILabel!
    @IBOutlet weak var RotateTextSwitch: UISwitch!
}
