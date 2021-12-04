//
//  ViewportSizeSlice.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/6/21.
//

import Foundation
import UIKit

class ViewportSizeSlice: UIViewController, UITextFieldDelegate,
                         ShapeSliceProtocol
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = UIConstants.CornerRadius
        self.view.layer.borderColor = UIConstants.DarkBorder
        self.view.layer.borderWidth = UIConstants.ThickBorder
        
        self.WidthTextBox.addTarget(self, action: #selector(OnWidthReturn),
                                     for: UIControl.Event.editingDidEndOnExit)
        self.HeightTextBox.addTarget(self, action: #selector(OnHeightReturn),
                                       for: UIControl.Event.editingDidEndOnExit)
        
        let VWidth = Settings.GetInt(.ViewportWidth, IfZero: 1024)
        let VHeight = Settings.GetInt(.ViewportHeight, IfZero: 1024)
        
        WidthTextBox.text = "\(VWidth)"
        HeightTextBox.text = "\(VHeight)"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(HandleTapToDismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        WidthTextBox.resignFirstResponder()
        HeightTextBox.resignFirstResponder()
        super.viewWillDisappear(animated)
    }
    
    @objc func HandleTapToDismissKeyboard()
    {
        WidthTextBox.resignFirstResponder()
        HeightTextBox.resignFirstResponder() 
    }
    
    @IBAction func OnWidthReturn()
    {
        self.WidthTextBox.resignFirstResponder()
    }
    
    @IBAction func OnHeightReturn()
    {
        self.HeightTextBox.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        switch textField
        {
            case WidthTextBox:
                if let RawWidth = textField.text
                {
                    if let Width = Int(RawWidth)
                    {
                        Settings.SetInt(.ViewportWidth, Width)
                        print("New viewport width: \(Width)")
                    }
                }
                
            case HeightTextBox:
                if let RawHeight = textField.text
                {
                    if let Height = Int(RawHeight)
                    {
                        Settings.SetInt(.ViewportHeight, Height)
                        print("New viewport height: \(Height)")
                    }
                }
                
            default:
                Debug.Print("Unexpected textField encountered.")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func ResetSettings()
    {
        Settings.SetDoubleDefault(For: .ViewportWidth)
        Settings.SetDoubleDefault(For: .ViewportHeight)
        let VWidth = Settings.GetInt(.ViewportWidth, IfZero: 1024)
        let VHeight = Settings.GetInt(.ViewportHeight, IfZero: 1024)
        
        WidthTextBox.text = "\(VWidth)"
        HeightTextBox.text = "\(VHeight)"
    }
    
    @IBOutlet weak var HeightTextBox: UITextField!
    @IBOutlet weak var WidthTextBox: UITextField!
}
