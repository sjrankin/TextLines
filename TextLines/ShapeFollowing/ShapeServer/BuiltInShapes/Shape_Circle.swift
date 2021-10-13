//
//  Shape_Circle.swift
//  TextLine
//
//  Created by Stuart Rankin on 10/1/21.
//

import Foundation
import UIKit

class Shape_Circle: ShapeServerProtocol, SettingChangedProtocol
{
    init()
    {
        Settings.AddSubscriber(self)
    }
    
    deinit
    {
        Settings.RemoveSubscriber(self)
    }
    
    var ClassID = UUID()
    
    func SubscriberID() -> UUID
    {
        return ClassID
    }
    
    public var LastPath: UIBezierPath? = nil
    
    func ShapeBezier() -> UIBezierPath?
    {
        return nil
    }
    
    var TopMargin: CGFloat = 20.0
    var LeftMargin: CGFloat = 20.0
    var BottomMargin: CGFloat = 20.0
    var RightMargin: CGFloat = 20.0
    
    func SetMargins(Left: CGFloat, Top: CGFloat, Bottom: CGFloat, Right: CGFloat)
    {
        LeftMargin = Left
        TopMargin = Top
        BottomMargin = Bottom
        RightMargin = Right
    }
    
    var Size: CGSize = CGSize(width: 1000.0, height: 1000.0)
    
    func SetSize(_ Size: CGSize)
    {
        self.Size = Size
    }
    
    var Origin: CGPoint = CGPoint(x: 0.0, y: 0.0)
    
    func SetOrigin(At: CGPoint)
    {
        Origin = At
    }
    
    var PathLength: CGFloat
    {
        get
        {
            guard let Path = LastPath else
            {
                return 0.0
            }
            return Path.length
        }
    }
    
    func SettingChanged(Setting: SettingKeys, OldValue: Any?, NewValue: Any?)
    {
        if Setting == .CircleDiameter
        {
            //Do something
        }
    }
}
