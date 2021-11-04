//
//  SettingsWrapperController.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/3/21.
//

import Foundation
import UIKit

class SettingsWrapperController: UINavigationController
{
    public weak var WrapperDelegate: SettingsWrapperDelegate? = nil
    {
        didSet
        {
            if let (StoryboardName, ControllerName) = WrapperDelegate?.GetTarget()
            {
                print("Displaying \(StoryboardName).\(ControllerName)")
                let Storyboard = UIStoryboard(name: StoryboardName, bundle: nil)
                let VC = Storyboard.instantiateViewController(withIdentifier: ControllerName)
                pushViewController(VC, animated: true)
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
}
