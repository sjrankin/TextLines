//
//  MoreSettings.swift
//  MoreSettings
//
//  Created by Stuart Rankin on 8/26/21.
//

import Foundation
import UIKit

class MoreSettings: UITableViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        ShapeColorWell.addTarget(self, action: #selector(GridLineColorChangedHandler(_:)), for: .valueChanged)
        ShapeColorWell.selectedColor = Settings.GetColor(.GuidelineColor, UIColor.red)
        ShapeColorWell.supportsAlpha = true
        ShapeColorWell.backgroundColor = UIColor.clear
        ShowShapeSwitch.isOn = Settings.GetBool(.ShowGuidelines)
        VersionString.text = "\(Versioning.VerySimpleVersionString()), Build \(Versioning.Build)"
        CopyrightString.text = "\(Versioning.CopyrightText())"
    }
    
    @objc func GridLineColorChangedHandler(_ sender: Any)
    {
        if let Well = sender as? UIColorWell
        {
            if let WellColor = Well.selectedColor
            {
                Settings.SetColor(.GuidelineColor, WellColor)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 1
    }
    
    /// - TODO: Remove hard-coded table address.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 3 && indexPath.section == 0
        {
            let Storyboard = UIStoryboard(name: "SettingsUI", bundle: nil)
//            let nextViewController = Storyboard.instantiateViewController(withIdentifier: "StyleSettings") as! StyleSettings
            let nextViewController = Storyboard.instantiateViewController(withIdentifier: "CommandBarCustomization") as! CommandBarCustomization
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func ShowShapeChangedHandler(_ sender: Any)
    {
        if let Switch = sender as? UISwitch
        {
            Settings.SetBool(.ShowGuidelines, Switch.isOn)
        }
    }
    
    @IBOutlet weak var CommandBarCell: UIView!
    @IBOutlet weak var ShapeColorWell: UIColorWell!
    @IBOutlet weak var CopyrightString: UILabel!
    @IBOutlet weak var ShowShapeSwitch: UISwitch!
    @IBOutlet weak var VersionString: UILabel!
}
