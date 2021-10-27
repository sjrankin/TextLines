//
//  MainProtocol.swift
//  MainProtocol
//
//  Created by Stuart Rankin on 8/24/21.
//

import Foundation
import UIKit

protocol MainProtocol: AnyObject
{
    func SetShape(_ NewShape: Shapes)
    func GetMainImages() -> [ShapeCategories: UIImageView]
    func UpdateOutput()
    func GetShapeScroller() -> UIScrollView
}
