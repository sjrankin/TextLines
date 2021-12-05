//
//  FontSlice.swift
//  TextLines
//
//  Created by Stuart Rankin on 12/1/21.
//

import Foundation
import UIKit

class FontSlice: UIViewController, UITextFieldDelegate,
                 UIFontPickerViewControllerDelegate
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = UIConstants.CornerRadius
        self.view.layer.borderColor = UIConstants.DarkBorder
        self.view.layer.borderWidth = UIConstants.ThickBorder
        
        FontSize = Settings.GetCGFloat(.ImageTextFontSize, 32.0)
        FontSizeField.text = "\(Int(FontSize))"
        FontName = Settings.GetString(.ImageTextFont, "Avenir-Black")
        FontNameLabel.text = FontName
        
        SampleTextField.layer.borderColor = UIColor.gray.cgColor
        SampleTextField.layer.borderWidth = 0.5
        SampleTextField.layer.cornerRadius = 5.0
        
        FontColorWell.backgroundColor = UIColor.clear
        FontColorWell.addTarget(self, action: #selector(TextColorChangedHandler(_:)), for: .valueChanged)
        FontColorWell.selectedColor = Settings.GetColor(.TextColor, UIColor.black)
        FontColorWell.supportsAlpha = true
        
        DrawSample()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        FontSizeField.resignFirstResponder()
        super.viewWillDisappear(animated)
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
    
    var FontSize: CGFloat = 32.0
    var FontName: String = ""
    var SelectedFont = 0
    
    @IBAction func FontPickerButtonHandler(_ sender: Any)
    {
        let configuration = UIFontPickerViewController.Configuration()
        configuration.includeFaces = true
        let vc = UIFontPickerViewController(configuration: configuration)
        vc.delegate = self
        present(vc, animated: true)
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
    
    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController)
    {
        // attempt to read the selected font descriptor, but exit quietly if that fails
        guard let descriptor = viewController.selectedFontDescriptor else
        {
            return
        }
        
        let font = UIFont(descriptor: descriptor, size: 36)
        FontNameLabel.text = font.fontName
        Settings.SetString(.ImageTextFont, font.fontName)
        DrawSample()
    }
    
    func fontPickerViewControllerDidCancel(_ viewController: UIFontPickerViewController)
    {
        print("Font picker canceled")
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
        SampleTextField.backgroundColor = BGColor
        SampleTextField.textColor = TextColor
        let LocalSize = Settings.GetCGFloat(.ImageTextFontSize, 32.0)
        let LocalName = Settings.GetString(.ImageTextFont, "Avenir")
        let SampleFont = UIFont(name: LocalName, size: LocalSize)
        SampleTextField.font = SampleFont
    }
    
    @IBOutlet weak var FontNameLabel: UILabel!
    @IBOutlet weak var FontColorWell: UIColorWell!
    @IBOutlet weak var FontSizeField: UITextField!
    @IBOutlet weak var SampleTextField: UITextView!
}
