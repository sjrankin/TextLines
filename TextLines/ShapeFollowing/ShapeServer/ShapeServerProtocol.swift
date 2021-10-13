//
//  ShapeServerProtocol.swift
//  TextLine
//
//  Created by Stuart Rankin on 10/1/21.
//

import Foundation
import UIKit

protocol ShapeServerProtocol: AnyObject
{
    func ShapeBezier() -> UIBezierPath?
    func SetMargins(Left: CGFloat, Top: CGFloat, Bottom: CGFloat, Right: CGFloat)
    func SetSize(_ Size: CGSize)
    func SetOrigin(At: CGPoint)
    var PathLength: CGFloat {get}
    var LastPath: UIBezierPath? {get}
}
