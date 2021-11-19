//
//  BackgroundSlice.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/15/21.
//

import Foundation
import UIKit
import Photos
import PhotosUI
import AVKit
import CoreServices
import MobileCoreServices
import UniformTypeIdentifiers

class BackgroundSlice: UIViewController, UINavigationControllerDelegate,
                       UIImagePickerControllerDelegate
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        ColorSample.layer.borderWidth = 1.0
        ColorSample.layer.borderColor = UIColor.gray.cgColor
        ColorSample.layer.cornerRadius = 5.0
        ColorSample.clipsToBounds = true
        
        ImageSample.layer.borderWidth = 1.0
        ImageSample.layer.borderColor = UIColor.gray.cgColor
        ImageSample.layer.cornerRadius = 5.0
        ImageSample.clipsToBounds = true
        
        BackgroundColorWell.clipsToBounds = true
        BackgroundColorWell.backgroundColor = UIColor.clear
        BackgroundColorWell.selectedColor = Settings.GetColor(.BackgroundColor, UIColor.red)
        BackgroundColorWell.supportsAlpha = true
        BackgroundColorWell.addTarget(self, action: #selector(BackgroundColorChangedHandler(_:)), for: .valueChanged)

        switch Settings.GetEnum(ForKey: .BackgroundType, EnumType: Backgrounds.self, Default: .Color)
        {
            case .Color:
                BackgroundTypeSegment.selectedSegmentIndex = 0
                
            case .Image:
                BackgroundTypeSegment.selectedSegmentIndex = 1
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
    
    func InitializeBackgroundSample()
    {
        if Checks == nil
        {
            Checks = Filters.Checkerboard(Width: 1000,
                                          Height: 500,
                                          CheckerSize: 16,
                                          Color0: CIColor(red: 0.85, green: 0.85, blue: 0.85))
        }
        ImageSample.image = Checks
        ColorSample.image = Checks
    }
    
    func UpdateBackgroundSample()
    {
        switch BackgroundTypeSegment.selectedSegmentIndex
        {
            case 0:
                //Color background
                ColorLayer?.removeFromSuperlayer()
                ColorLayer = nil
                ColorLayer = CALayer()
                let BGColor = Settings.GetColor(.BackgroundColor, UIColor.white)
                ColorLayer?.frame = CGRect(x: 0,
                                           y: 0,
                                           width: ImageSample.bounds.size.width + 20,
                                           height: ImageSample.bounds.size.height)
                ColorLayer?.backgroundColor = BGColor.cgColor
                ColorLayer?.opacity = Float(BGColor.a)
                ColorLayer?.zPosition = 100
                ColorSample.layer.addSublayer(ColorLayer!)
                ColorSample.isHidden = false
                ImageSample.isHidden = true
                
            case 1:
                //Image background
                ImageSample.image = LoadedImage
                ColorSample.isHidden = true
                ImageSample.isHidden = false
                
            default:
                return
        }
        
    }
    
    @IBAction func BackgroundImageSelectionHandler(_ sender: Any)
    {
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
    
    
    @IBAction func BackgroundTypeChangedHandler(_ sender: Any)
    {
        if let Segment = sender as? UISegmentedControl
        {
            let Index = Segment.selectedSegmentIndex
            let Actual = Backgrounds.allCases[Index]
            Settings.SetEnum(Actual, EnumType: Backgrounds.self,
                             ForKey: .BackgroundType)
            UpdateBackgroundSample()
            switch Index
            {
                case 0:
                    BackgroundImageButton.isEnabled = false
                    BackgroundColorLabel.isEnabled = true
                    BackgroundColorWell.isEnabled = true
                    
                case 1:
                    BackgroundImageButton.isEnabled = true
                    BackgroundColorLabel.isEnabled = false
                    BackgroundColorWell.isEnabled = false
                    
                default:
                    break
            }
        }
    }
    
    var ColorLayer: CALayer? = nil
    var Checks: UIImage? = nil
    
    @IBOutlet weak var ColorSample: UIImageView!
    @IBOutlet weak var ImageSample: UIImageView!
    @IBOutlet weak var BackgroundColorWell: UIColorWell!
    @IBOutlet weak var BackgroundColorLabel: UILabel!
    @IBOutlet weak var BackgroundImageButton: UIButton!
    @IBOutlet weak var BackgroundTypeSegment: UISegmentedControl!
}
