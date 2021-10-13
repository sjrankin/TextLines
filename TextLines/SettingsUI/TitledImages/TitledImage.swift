//
//  TitledImage.swift
//  TextLine
//
//  Created by Stuart Rankin on 9/19/21.
//

import Foundation
import UIKit

class TitledImage: UIView
{
    init()
    {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    init(ImageName: String, ImageType: ImageTypes, Frame: CGRect,
         Title: String, TitleColor: UIColor, Background: UIColor,
         ID: Any? = nil, Tapped: TitledBlockAction? = nil)
    {
        super.init(frame: Frame)
        self.isUserInteractionEnabled = true
        guard let TImage = LoadImage(Name: ImageName, Type: ImageType) else
        {
            Debug.FatalError("Error creating image with name: \(ImageName)")
        }
        Structure = TitledImageStructure(frame: Frame)
        Structure?.SetID(ID)
        Structure?.SetImage(TImage, ImageType: ImageType)
        Structure?.SetTitle(Title)
        Structure?.SetAction(Tapped)
        Structure?.SetTitleColor(.white)
        self.addSubview(Structure!)
    }
    
    private func LoadImage(Name: String, Type: ImageTypes) -> UIImage?
    {
        switch Type
        {
            case .Normal:
                return UIImage(named: Name)
                
            case .System:
                return UIImage(systemName: Name)
                
            case .SVG:
                return UIImage(named: Name)
        }
    }
    
    public var IsReadOnly: Bool = false
    private var Structure: TitledImageStructure? = nil
}
/*
typealias TitledImageTapped = (String?) -> ()

class TitledImage: UIStackView
{
    init()
    {
        super.init(frame: CGRect.zero)
        self.axis = .vertical
        CommonInitialization()
    }
    
    init(ImageName: String, ImageType: ImageTypes, ImageFrame: CGRect,
         Title: String, TitleColor: UIColor, Background: UIColor, ID: String? = nil,
         Tapped: TitledImageTapped? = nil)
    {
        let TextHeight: CGFloat = 30.0
        PassedID = ID
        let FinalFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: 80.0, height: 80.0))
        self.ImageFrame = FinalFrame
        super.init(frame: FinalFrame)
        print("TitledImage[init] frame=\(FinalFrame)")
        self.axis = .vertical
        CommonInitialization(CGRect(origin: ImageFrame.origin,
                                    size: CGSize(width: 80.0, height: 30)))
        TitleLabel?.text = Title
        TitleLabel?.textColor = TitleColor
        TitleLabel?.backgroundColor = Background
        TitleLabel?.textAlignment = .center
        TitleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        print("TitleLabel?.frame=\(TitleLabel!.frame)")
        TappedClosure = Tapped
        let Recognizer = UITapGestureRecognizer(target: self, action: #selector(TapResponder))
        Recognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(Recognizer)
        if let FinalImage = LoadImage(Name: ImageName, Type: ImageType)
        {
            ImageView = UIImageView(frame: ImageFrame)
            print("ImageView.frame = \(ImageView!.frame)")
            ImageView?.contentMode = .scaleAspectFit
            ImageView?.image = FinalImage
            if [ImageTypes.SVG, ImageTypes.System].contains(ImageType)
            {
                ImageView?.image = ImageView?.image?.withRenderingMode(.alwaysTemplate)
                ImageView?.tintColor = UIColor.systemBlue
            }
            self.isUserInteractionEnabled = true
            self.addArrangedSubview(ImageView!)
            self.addArrangedSubview(TitleLabel!)
        }
        
        self.frame = ImageFrame
    }
    
    var PassedID: String? = nil
    var ImageView: UIImageView? = nil
    var ImageFrame: CGRect? = nil
    
    required init(coder: NSCoder)
    {
        super.init(coder: coder)
        self.axis = .vertical
        CommonInitialization()
    }
    
    @objc func TapResponder(_ Recognizer: UITapGestureRecognizer)
    {
        TappedClosure?(PassedID)
    }
    
    public var TappedClosure: TitledImageTapped? = nil
    
    private func CommonInitialization(_ Frame: CGRect? = nil)
    {
        if let Frame = Frame
        {
            TitleLabel = UILabel(frame: Frame)
        }
        else
        {
            TitleLabel = UILabel(frame: CGRect.zero)
        }
    }
    
    var IsReadOnly: Bool = false
    
    private var TitleLabel: UILabel? = nil

    private func LoadImage(Name: String, Type: ImageTypes) -> UIImage?
    {
        switch Type
        {
            case .Normal:
                return UIImage(named: Name)
                
            case .System:
                return UIImage(systemName: Name)
                
            case .SVG:
                return UIImage(named: Name)
        }
    }
}
*/
