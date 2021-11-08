//
//  CircleSettingSlice.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/6/21.
//

import Foundation
import UIKit

class CircleSettingSlice: UIViewController, SettingChangedProtocol
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = 5.0
        self.view.layer.borderColor = UIColor.black.cgColor
        self.view.layer.borderWidth = 1.5
        
        Settings.AddSubscriber(self)
        let VWidth = Settings.GetInt(.ViewportWidth, IfZero: 1024)
        let VHeight = Settings.GetInt(.ViewportHeight, IfZero: 1024)
        let VSizeString = "\(VWidth) x \(VHeight)"
        CurrentViewportSize.text = VSizeString
        let Radius = Settings.GetDouble(.CircleRadiusPercent, 0.95)
        let TRadius = Radius.RoundedTo(1) * 100.0
        let RadiusString = "\(Int(TRadius))%"
        RadialText.text = RadiusString
        RadialSlider.value = Float(Radius * 1000.0)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        Settings.RemoveSubscriber(self)
        super.viewWillDisappear(animated)
    }
    
    let ClassSubscriberID = UUID()
    
    func SubscriberID() -> UUID
    {
        return ClassSubscriberID
    }
    
    func SettingChanged(Setting: SettingKeys, OldValue: Any?, NewValue: Any?)
    {
        switch Setting
        {
            case .ViewportWidth:
                let VWidth = Settings.GetInt(.ViewportWidth, IfZero: 1024)
                let VHeight = Settings.GetInt(.ViewportHeight, IfZero: 1024)
                let VSizeString = "\(VWidth) x \(VHeight)"
                CurrentViewportSize.text = VSizeString
                
            case .ViewportHeight:
                let VWidth = Settings.GetInt(.ViewportWidth, IfZero: 1024)
                let VHeight = Settings.GetInt(.ViewportHeight, IfZero: 1024)
                let VSizeString = "\(VWidth) x \(VHeight)"
                CurrentViewportSize.text = VSizeString
                
            default:
                break
        }
    }
    
    @IBAction func ViewportSizeButtonPressed(_ sender: Any)
    {
    }
    
    @IBAction func RadialTextEntryEnded(_ sender: Any)
    {
    }
    
    @IBAction func RadialSliderChanged(_ sender: Any)
    {
        guard let Slider = sender as? UISlider else
        {
            Debug.FatalError("Slider change handler received non-slider control.")
        }
        var NewRadialValue = Double(Slider.value)
        NewRadialValue = NewRadialValue / 1000.0
        NewRadialValue = Utility.RoundTo(NewRadialValue, ToNearest: 2)
        Settings.SetDouble(.CircleRadiusPercent, NewRadialValue)
        let IRadial = Int(NewRadialValue * 100.0)
        let RadiusString = "\(Int(IRadial))%"
        RadialText.text = RadiusString
    }
    
    @IBOutlet weak var RadialText: UITextField!
    @IBOutlet weak var RadialSlider: UISlider!
    @IBOutlet weak var CurrentViewportSize: UILabel!
}
