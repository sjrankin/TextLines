//
//  SlideHandlerProtocol.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/6/21.
//

import Foundation
import UIKit

protocol SliceHandlerProtocol: AnyObject
{
    func CloseCurrentSlice()
    func PushSlice(_ Slice: SliceTypes)
    func PopSlice()
}
