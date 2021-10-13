//
//  TitledImageStructure.swift
//  TextLine
//
//  Created by Stuart Rankin on 9/22/21.
//

import Foundation
import UIKit

typealias TitledBlockAction = (Any?) -> ()

class TitledImageStructure: UIView
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        CreateStructure()
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
        CreateStructure()
    }
    
    let LabelHeight: CGFloat = 20.0
    
    func CreateStructure()
    {
        self.isUserInteractionEnabled = true
        let Frame = self.frame
        let ImageHeight = Frame.height - LabelHeight
        Image = UIImageView(frame: CGRect(origin: .zero,
                                          size: CGSize(width: Frame.width, height: ImageHeight)))
        Image?.contentMode = .scaleAspectFit
        self.addSubview(Image!)
        Label = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: ImageHeight),
                                      size: CGSize(width: Frame.width, height: LabelHeight)))
        Label?.textAlignment = .center
        self.addSubview(Label!)
        let Recognizer = UITapGestureRecognizer(target: self, action: #selector(TapResponder))
        Recognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(Recognizer)
    }
    
    var TapAction: TitledBlockAction? = nil
    
    @objc func TapResponder(_ Recognizer: UITapGestureRecognizer)
    {
        TapAction?(ID)
    }
    
    func SetOrigin(_ NewOrigin: CGPoint)
    {
        self.frame = CGRect(origin: NewOrigin, size: self.frame.size)
    }
    
    func SetAction(_ Action: TitledBlockAction?)
    {
        TapAction = Action
    }
    
    func SetID(_ ID: Any?)
    {
        self.ID = ID
    }
    
    func SetImage(_ NewImage: UIImage, ImageType: ImageTypes)
    {
        guard let _ = Image else
        {
            return
        }
        //self.Image?.frame = CGRect(origin: .zero, size: NewImage.size)
        self.ImageType = ImageType
        let Config = UIImage.SymbolConfiguration(pointSize: 28.9, weight: .bold, scale: .large)
        Image?.preferredSymbolConfiguration = Config
        Image?.image = NewImage
        if [ImageTypes.SVG, ImageTypes.System].contains(ImageType)
        {
            Image?.image = Image?.image?.withRenderingMode(.alwaysTemplate)
            Image?.tintColor = UIColor.systemBlue
        }
    }
    
    func SetTitle(_ NewTitle: String)
    {
        guard let _ = Label else
        {
            return
        }
        Label?.text = NewTitle
    }
    
    func SetTitleColor(_ NewColor: UIColor)
    {
        guard let _ = Label else
        {
            return
        }
        Label?.textColor = NewColor
    }
    
    var ImageType: ImageTypes = .Normal
    var ID: Any? = nil
    var Label: UILabel? = nil
    var Image: UIImageView? = nil
}
