//
//  ShapeBarProtocol.swift
//  ShapeBarProtocol
//
//  Created by Stuart Rankin on 8/24/21.
//

import Foundation
import UIKit

protocol ShapeBarProtocol: AnyObject
{
    func SetShape(_ NewShape: Shapes)
    func GetCategories() -> [ShapeCategories]
    func UpdateOutput()
    func GetShapeScroller() -> UIScrollView
}
