//
//  FontPickerController.swift
//  FontPickerController
//
//  Created by Stuart Rankin on 8/26/21.
//

import Foundation
import UIKit

class FontPickerController: UITableViewController, UITextFieldDelegate,
                            UIFontPickerViewControllerDelegate
{
    override func viewDidLoad()
    {
        SampleTextField2.layer.cornerRadius = 5
        SampleTextField2.layer.borderColor = UIColor.gray.cgColor
        SampleTextField2.layer.borderWidth = 0.5
        
        FontSize = Settings.GetCGFloat(.ImageTextFontSize, 32.0)
        FontSizeBox2.text = "\(Int(FontSize))"
        FontName = Settings.GetString(.ImageTextFont, "Avenir-Black")
        FullFontNameText2.text = FontName
        
        TextColorWell.backgroundColor = UIColor.clear
        TextColorWell.addTarget(self, action: #selector(TextColorChangedHandler(_:)), for: .valueChanged)
        TextColorWell.selectedColor = Settings.GetColor(.TextColor, UIColor.black)
        TextColorWell.supportsAlpha = true
        
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Dismiss", style: .done,
                                         target: self, action: #selector(DoneButtonTapped))
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        SampleTextField2.inputAccessoryView = toolbar
        FontSizeBox2.inputAccessoryView = toolbar
        DrawSample()
    }
    
    @objc func TextColorChangedHandler(_ sender: Any)
    {
        if let Well = sender as? UIColorWell
        {
            if let FinalColor = Well.selectedColor
            {
                Settings.SetColor(.TextColor, FinalColor)
                DrawSample()
            }
        }
    }
    
    var FontSize: CGFloat = 32.0
    var FontName: String = ""
    var SelectedFont = 0
    
    @IBAction func CloseButtonHandler(_ sender: Any)
    {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func TextFieldEditingEnded2(_ sender: Any)
    {
        if let Field = sender as? UITextField
        {
            
            if let TextValue = Field.text
            {
                if let NewSize = Double(TextValue)
                {
                    Settings.SetCGFloat(.ImageTextFontSize, CGFloat(NewSize))
                    DrawSample()
                }
            }
        }
    }
    
    @objc func DoneButtonTapped()
    {
        self.view.endEditing(true)
    }
    
    @IBAction func FontPickerButtonHandler(_ sender: Any)
    {
        let configuration = UIFontPickerViewController.Configuration()
        configuration.includeFaces = true
        let vc = UIFontPickerViewController(configuration: configuration)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController)
    {
        // attempt to read the selected font descriptor, but exit quietly if that fails
        guard let descriptor = viewController.selectedFontDescriptor else
        {
            return
        }
        
        let font = UIFont(descriptor: descriptor, size: 36)
        FullFontNameText2.text = font.fontName
        Settings.SetString(.ImageTextFont, font.fontName)
        DrawSample()
    }
    
    func fontPickerViewControllerDidCancel(_ viewController: UIFontPickerViewController)
    {
        print("Font picker canceled")
    }
    
    func ColorBrightness(For Color: UIColor) -> CGFloat
    {
        var Red: CGFloat = 0.0
        var Green: CGFloat = 0.0
        var Blue: CGFloat = 0.0
        var Alpha: CGFloat = 0.0
        Color.getRed(&Red, green: &Green, blue: &Blue, alpha: &Alpha)
        var Brightness = (Red * 299.0) + (Green * 587.0) + (Blue * 114.0)
        Brightness = Brightness / 1000.0
        return Brightness
    }
    
    func ContrastingColor(To Color: UIColor) -> UIColor
    {
        let Brightness = ColorBrightness(For: Color)
        return Brightness < 0.5 ? UIColor.white : UIColor.black
    }
    
    func DrawSample()
    {
        let TextColor = Settings.GetColor(.TextColor, UIColor.black)
        let BGColor = ContrastingColor(To: TextColor)
        SampleTextField2.backgroundColor = BGColor
        SampleTextField2.textColor = TextColor
        let LocalSize = Settings.GetCGFloat(.ImageTextFontSize, 32.0)
        let LocalName = Settings.GetString(.ImageTextFont, "Avenir")
        let SampleFont = UIFont(name: LocalName, size: LocalSize)
        SampleTextField2.font = SampleFont
    }
    
    @IBOutlet weak var TextColorWell: UIColorWell!
    @IBOutlet weak var SampleTextField2: UITextView!
    @IBOutlet weak var FullFontNameText2: UILabel!
    @IBOutlet weak var FontSizeBox2: UITextField!
}

