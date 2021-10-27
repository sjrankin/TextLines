//
//  TitledImageUI.swift
//  TextLine
//
//  Created by Stuart Rankin on 9/22/21.
//

import Foundation
import UIKit

class TitledImageUI: UICollectionViewCell
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        let SampleImage = UIImage(systemName: "sun.and.horizon")
        self.Structure = TitledImageStructure(frame: frame)
        self.Structure?.SetImage(SampleImage!, ImageType: .System)
        self.Structure?.SetTitle("Sample")
        self.addSubview(Structure!)
        let Recognizer = UITapGestureRecognizer(target: self, action: #selector(SampleTapResponder))
        Recognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(Recognizer)
    }
    
    @objc func SampleTapResponder(_ Recognizer: UITapGestureRecognizer)
    {
        Debug.Print("Sample button tapped.")
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    init(frame: CGRect, Image: String, Title: String, ImageType: ImageTypes,
         ID: Any? = nil, Action: TitledBlockAction? = nil)
    {
        super.init(frame: frame)
        self._ImageName = Image
        self.ImageType = ImageType
        self.isUserInteractionEnabled = true
        guard let TImage = LoadImage(Name: Image, Type: ImageType) else
        {
            Debug.FatalError("Error creating image with name: \(Image)")
        }
        self.ID = ID
        self.Structure = TitledImageStructure(frame: frame)
        self.Structure?.SetImage(TImage, ImageType: ImageType)
        self.Structure?.SetTitle(Title)
        self.Structure?.SetAction(Action)
        self.Structure?.SetTitleColor(.black)
        self.addSubview(Structure!)
    }
    
    var Title: String?
    {
        get
        {
            return self.Structure?.Title
        }
    }
    
    var _ImageName: String? = nil
    var ImageName: String?
    {
        get
        {
            return _ImageName
        }
    }
    
    func GetIconImageView() -> UIImageView?
    {
        let ActualImage = self.Structure?.Image
        return ActualImage
    }
    
    func GetIconImage() -> UIImage?
    {
        let ActualImage = self.Structure?.Image?.image
        return ActualImage
    }

    public var ImageType: ImageTypes? = nil

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
    
    public var IsUsed: Bool = false
    public var IsReadOnly: Bool = false
    private var Structure: TitledImageStructure? = nil
    public var ID: Any? = nil
}
