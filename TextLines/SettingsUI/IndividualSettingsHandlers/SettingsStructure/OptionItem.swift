//
//  OptionItem.swift
//  OptionItem
//
//  Created by Stuart Rankin on 8/16/21.
//

import Foundation
import UIKit

class OptionItem
{
    init(_ ForShape: Shapes)
    {
        _Shape = ForShape
    }
    
    private var _Shape: Shapes = .Circle
    public var Shape: Shapes
    {
        get
        {
            return _Shape
        }
        set
        {
            _Shape = newValue
        }
    }
    
    private var _SettingItemList = [SettingItem]()
    public var SettingItemList: [SettingItem]
    {
        get
        {
            return _SettingItemList
        }
        set
        {
            _SettingItemList = newValue
        }
    }
}
