//
//  SpiralSliceSettings.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/25/21.
//

import Foundation
import UIKit

class SpiralSliceSettings: UIViewController, UITextFieldDelegate,
                           SettingChangedProtocol
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = UIConstants.CornerRadius
        self.view.layer.borderColor = UIConstants.DarkBorder
        self.view.layer.borderWidth = UIConstants.ThickBorder
        
        Settings.AddSubscriber(self)
        let VWidth = Settings.GetInt(.ViewportWidth, IfZero: 1024)
        let VHeight = Settings.GetInt(.ViewportHeight, IfZero: 1024)
        let VSizeString = "\(VWidth) x \(VHeight)"
        ViewportSizeLabel.text = VSizeString
        
        InitializeTextField(StartRadiusField, Key: .SpiralStartRadius)
        StartRadiusField.addTarget(self, action: #selector(OnEditingDone),
                                   for: UIControl.Event.editingDidEndOnExit)
        InitializeTextField(StartAngleField, Key: .SpiralStartTheta)
        StartAngleField.addTarget(self, action: #selector(OnEditingDone),
                                  for: UIControl.Event.editingDidEndOnExit)
        InitializeTextField(EndAngleField, Key: .SpiralEndTheta)
        EndAngleField.addTarget(self, action: #selector(OnEditingDone),
                                for: UIControl.Event.editingDidEndOnExit)
        InitializeTextField(AngleStepField, Key: .SpiralThetaStep)
        AngleStepField.addTarget(self, action: #selector(OnEditingDone),
                                 for: UIControl.Event.editingDidEndOnExit)
        InitializeTextField(LineGapField, Key: .SpiralSpacePerLoop)
        LineGapField.addTarget(self, action: #selector(OnEditingDone),
                               for: UIControl.Event.editingDidEndOnExit)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(HandleCloseTap))
        view.addGestureRecognizer(tap)
    }
    
    func InitializeTextField(_ Field: UITextField, Key: SettingKeys)
    {
        var Value = Settings.GetCGFloat(Key)
        let DValue = Double(Value).RoundedTo(2)
        Field.text = "\(DValue)"
    }
    
    // MARK: - Interface handlers.
    
    @objc func HandleCloseTap()
    {
        StartRadiusField.resignFirstResponder()
    }
    
    @IBAction func OnEditingDone()
    {
        self.StartRadiusField.resignFirstResponder()
        self.StartAngleField.resignFirstResponder()
        self.EndAngleField.resignFirstResponder()
        self.AngleStepField.resignFirstResponder()
        self.LineGapField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        guard let Raw = textField.text else
        {
            Debug.Print("No text to parse.")
            return
        }
        let Pure = Raw.filter("0123456789.".contains)
        if let DValue = Double(Pure)
        {
            switch textField
            {
                case StartRadiusField:
                    Settings.SetCGFloat(.SpiralStartRadius, DValue)
                    
                case StartAngleField:
                    Settings.SetCGFloat(.SpiralStartTheta, DValue)
                    
                case EndAngleField:
                    Settings.SetCGFloat(.SpiralEndTheta, DValue)
                    
                case AngleStepField:
                    Settings.SetCGFloat(.SpiralThetaStep, DValue)
                    
                case LineGapField:
                    Settings.SetCGFloat(.SpiralSpacePerLoop, DValue)
                    
                default:
                    Debug.FatalError("Unexpected text field encountered.")
            }
        }
        else
        {
            Debug.Print("Error converting \"\(Pure)\" to Int.")
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Settings handling.
    
    var SettingID = UUID()
    
    func SubscriberID() -> UUID
    {
        return SettingID
    }
    
    func SettingChanged(Setting: SettingKeys, OldValue: Any?, NewValue: Any?)
    {
        switch Setting
        {
            case .ViewportWidth,
                    .ViewportHeight:
                let VWidth = Settings.GetInt(.ViewportWidth, IfZero: 1024)
                let VHeight = Settings.GetInt(.ViewportHeight, IfZero: 1024)
                let VSizeString = "\(VWidth) x \(VHeight)"
                ViewportSizeLabel.text = VSizeString
                
            default:
                break
        }
    }
    
    @IBAction func ResetButtonHandler(_ sender: Any)
    {
        Settings.SetCGFloatDefault(For: .SpiralEndTheta)
        Settings.SetCGFloatDefault(For: .SpiralSpacePerLoop)
        Settings.SetCGFloatDefault(For: .SpiralThetaStep)
        Settings.SetCGFloatDefault(For: .SpiralStartRadius)
        Settings.SetCGFloatDefault(For: .SpiralStartTheta)
        InitializeTextField(StartRadiusField, Key: .SpiralStartRadius)
        InitializeTextField(StartAngleField, Key: .SpiralStartTheta)
        InitializeTextField(EndAngleField, Key: .SpiralEndTheta)
        InitializeTextField(AngleStepField, Key: .SpiralThetaStep)
        InitializeTextField(LineGapField, Key: .SpiralSpacePerLoop)
    }
    
    @IBOutlet weak var StartRadiusField: UITextField!
    @IBOutlet weak var StartAngleField: UITextField!
    @IBOutlet weak var EndAngleField: UITextField!
    @IBOutlet weak var AngleStepField: UITextField!
    @IBOutlet weak var LineGapField: UITextField!
    @IBOutlet weak var ViewportSizeLabel: UILabel!
}
