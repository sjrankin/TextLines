//
//  DebugUICode.swift
//  DebugUICode
//
//  Created by Stuart Rankin on 8/14/21.
//

import Foundation
import UIKit

class DebugUICode: UITableViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        GuideMarkSwitch.isOn = Settings.GetBool(.ShowGuideMarks)
    }
    
    @IBAction func DoneButtonHandler(_ sender: Any)
    {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ResetSettingsButtonHandler(_ sender: Any)
    {
        Settings.Initialize(true)
    }
    
    @IBAction func GuideMarksChangedHandler(_ sender: Any)
    {
        guard let Switch = sender as? UISwitch else
        {
            return
        }
        Settings.SetBool(.ShowGuideMarks, Switch.isOn)
    }
    
    @IBOutlet weak var GuideMarkSwitch: UISwitch!
}
