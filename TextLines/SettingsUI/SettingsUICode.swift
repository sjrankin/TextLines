//
//  SettingsUICode.swift
//  SettingsUICode
//
//  Created by Stuart Rankin on 8/26/21.
//

import Foundation
import UIKit

class SettingsUICode: UITableViewController, UITextFieldDelegate
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let CurrentFont = Settings.GetString(.ImageTextFont, "Avenir-Black")
        FontName.text = CurrentFont
        
        RotatedTextSwitch.isOn = Settings.GetBool(.RotateCharacters)
        OffsetField.text = "\(Settings.GetInt(.TextOffset))"
        ImageWidthText.text = "\(Settings.GetInt(.ImageWidth))"
        ImageHeightText.text = "\(Settings.GetInt(.ImageHeight))"
        let Align = Settings.GetEnum(ForKey: .ShapeAlignment, EnumType: ShapeAlignments.self, Default: .None)
        let AlignIndex = ShapeAlignments.allCases.firstIndex(of: Align) ?? 0
        Alignment.selectedSegmentIndex = AlignIndex
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        switch section
        {
            case 0:
                let Shape = Settings.GetEnum(ForKey: .CurrentShape, EnumType: Shapes.self, Default: .Circle)
                return "\(Shape.rawValue) Settings"
                
            case 1:
                return "Common Settings"
                
            default:
                return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 1
    }
    
    /// Hack to simulate a table view cell tap.
    /// - TODO: Change hardcoded value to something more appropriate.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 4
        {
            let Storyboard = UIStoryboard(name: "UserShapes", bundle: nil)
            let nextViewController = Storyboard.instantiateViewController(withIdentifier: "UserShapeController") as! UserShapeController
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func DoneButtonHandler(_ sender: Any)
    {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func RotatedTextChangedHandler(_ sender: Any)
    {
        if let Switch = sender as? UISwitch
        {
            Settings.SetBool(.RotateCharacters, Switch.isOn)
        }
    }
    
    @IBAction func TextEnded(_ sender: Any)
    {
        guard let TextField = sender as? UITextField else
        {
            return
        }
        guard let RawText = TextField.text else
        {
            return
        }
        guard let TextValue = Int(RawText) else
        {
            return
        }
        switch TextField
        {
            case OffsetField:
                Settings.SetInt(.TextOffset, TextValue)
                
            case ImageWidthText:
                Settings.SetInt(.ImageWidth, TextValue)
                
            case ImageHeightText:
                Settings.SetInt(.ImageHeight, TextValue)
                
            default:
                return
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if let TextValue = textField.text
        {
            switch textField
            {
                case OffsetField:
                    print("Offset=\(TextValue)")
                case ImageHeightText:
                    print("Height=\(TextValue)")
                case ImageWidthText:
                    print("Width=\(TextValue)")
                default:
                    break
            }
        }
    }
    
    @IBAction func AlignmentChangedHandler(_ sender: Any)
    {
        guard let Segment = sender as? UISegmentedControl else
        {
            return
        }
        let Selected = ShapeAlignments.allCases[Segment.selectedSegmentIndex]
        Settings.SetEnum(Selected, EnumType: ShapeAlignments.self, ForKey: .ShapeAlignment)
    }

    @IBOutlet weak var UserShapeTableCell: UITableViewCell!
    @IBOutlet weak var Alignment: UISegmentedControl!
    @IBOutlet weak var OffsetField: UITextField!
    @IBOutlet weak var RotatedTextSwitch: UISwitch!
    @IBOutlet weak var FontName: UILabel!
    @IBOutlet weak var ImageHeightText: UITextField!
    @IBOutlet weak var ImageWidthText: UITextField!
}
