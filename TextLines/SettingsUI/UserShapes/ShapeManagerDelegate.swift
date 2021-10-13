//
//  ShapeManagerDelegate.swift
//  TextLine
//
//  Created by Stuart Rankin on 10/1/21.
//

import Foundation
import UIKit

protocol ShapeManagerDelegate: AnyObject
{
    func Done(ID: UUID?, TheShape: UserDefinedShape)
    func Canceled()
}
