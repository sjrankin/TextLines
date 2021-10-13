//
//  BackgroundSettings.swift
//  BackgroundSettings
//
//  Created by Stuart Rankin on 8/29/21.
//

import Foundation
import UIKit
import Photos
import PhotosUI
import AVKit
import CoreServices
import MobileCoreServices
import UniformTypeIdentifiers

class BackgroundSetting: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        BGColorSample.layer.borderWidth = 1.0
        BGColorSample.layer.borderColor = UIColor.gray.cgColor
        BGColorSample.layer.cornerRadius = 5.0
        BGImageSample.layer.borderWidth = 1.0
        BGImageSample.layer.borderColor = UIColor.gray.cgColor
        BGImageSample.layer.cornerRadius = 5.0
        
        BGColorWell.backgroundColor = UIColor.clear
        BGColorWell.addTarget(self, action: #selector(BackgroundColorChangedHandler(_:)), for: .valueChanged)
        BGColorWell.selectedColor = Settings.GetColor(.BackgroundColor, UIColor.red)
        BGColorWell.supportsAlpha = true
        switch Settings.GetEnum(ForKey: .BackgroundType, EnumType: Backgrounds.self, Default: .Color)
        {
            case .Color:
                BGTypeSelector.selectedSegmentIndex = 0
                
            case .Image:
                BGTypeSelector.selectedSegmentIndex = 1
        }
        InitializeBackgroundSample()
        UpdateBackgroundSample()
    }
    
    @objc func BackgroundColorChangedHandler(_ sender: Any)
    {
        if let Well = sender as? UIColorWell
        {
            if let BGColor = Well.selectedColor
            {
                Settings.SetColor(.BackgroundColor, BGColor)
                UpdateBackgroundSample()
            }
        }
    }
    
    @IBAction func SelectImageHandler(_ sender: Any)
    {
        GetPhoto()
    }
    
    @IBAction func BGTypeChangedHandler(_ sender: Any)
    {
        if let Segment = sender as? UISegmentedControl
        {
            let Index = Segment.selectedSegmentIndex
            let Actual = Backgrounds.allCases[Index]
            Settings.SetEnum(Actual, EnumType: Backgrounds.self, ForKey: .BackgroundType)
            UpdateBackgroundSample()
        }
    }
    
    @IBAction func ShowCheckChangedHandler(_ sender: Any)
    {
        if let Switch = sender as? UISwitch
        {
            Settings.SetBool(.ShowCheckerboard, Switch.isOn)
            UpdateBackgroundSample()
        }
    }
    
    var ColorLayer: CALayer? = nil
    var Checks: UIImage? = nil
    
    func InitializeBackgroundSample()
    {
        if Checks == nil
        {
            Checks = Filters.Checkerboard(Width: 1000,
                                          Height: 500,
                                          CheckerSize: 16,
                                          Color0: CIColor(red: 0.85, green: 0.85, blue: 0.85))
        }
        BGColorSample.image = Checks
    }
    
    func UpdateBackgroundSample()
    {

        switch BGTypeSelector.selectedSegmentIndex
        {
            case 0:
                //Color background
                ColorLayer?.removeFromSuperlayer()
                ColorLayer = nil
                 ColorLayer = CALayer()
                let BGColor = Settings.GetColor(.BackgroundColor, UIColor.white)
                ColorLayer?.frame = CGRect(x: 0,
                                           y: 0,
                                           width: BGColorSample.bounds.size.width + 20,
                                           height: BGColorSample.bounds.size.height)
                ColorLayer?.backgroundColor = BGColor.cgColor
                ColorLayer?.zPosition = 100
                BGColorSample.layer.addSublayer(ColorLayer!)
                BGColorSample.isHidden = false
                BGImageSample.isHidden = true
                
            case 1:
                //Image background
                BGImageSample.image = LoadedImage
                BGColorSample.isHidden = true
                BGImageSample.isHidden = false
                
            default:
                return
        }
    }
    
    func GetPhoto()
    {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = false
        pickerController.mediaTypes = ["public.image", "public.camera"]
        pickerController.sourceType = .photoLibrary
        
        self.present(pickerController, animated: true)
    }
    
    /// Image picker canceled by the user. We only care about this because if we didn't, the image picker would never
    /// disappear - we have to close it manually.
    /// - Parameter picker: Not used.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    
    /// Image picker finished picking a media object notice.
    /// - Note: We only care about still images and videos. Each is processed through a different code path but ultimate the same
    ///         code generates the resultant image/video.
    /// - Parameter picker: Not used.
    /// - Parameter didFinishPickingMediaWithInfo: Information about the selected image/media.
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        self.dismiss(animated: true, completion: nil)
        let MediaType = info[UIImagePickerController.InfoKey.mediaType] as! CFString
        let MediaType2 = String(MediaType)
        switch MediaType2
        {
            case UTType.movie.identifier:
                Debug.FatalError("Movies not yet supported.")
                
            case UTType.image.identifier:
                if let SelectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                {
                    LoadedImage = SelectedImage
                }
                
            default:
                fatalError("Unexpected image type: \(MediaType)")
        }
    }
    
    var LoadedImage: UIImage? = nil
    {
        didSet
        {
             if LoadedImage == nil
            {
                 return
             }
                UpdateBackgroundSample()
        }
    }
    
    @IBOutlet weak var BGColorSample: UIImageView!
    @IBOutlet weak var BGImageSample: UIImageView!
    @IBOutlet weak var BGTypeSelector: UISegmentedControl!
    @IBOutlet weak var BGColorWell: UIColorWell!
}
