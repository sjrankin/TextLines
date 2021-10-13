//
//  OptionItems.swift
//  OptionItems
//
//  Created by Stuart Rankin on 8/16/21.
//

import Foundation
import UIKit

class OptionItems
{
    func AddItem(_ NewItem: OptionItem)
    {
        if IndexOf(Item: NewItem.Shape) != nil
        {
            RemoveShape(NewItem.Shape)
        }
        OptionList.append(NewItem)
    }
    
    func Clear()
    {
        OptionList.removeAll()
    }
    
    var OptionList = [OptionItem]()
    
    var Count: Int
    {
        get
        {
            OptionList.count
        }
    }
    
    func IndexOf(Item: Shapes) -> Int?
    {
        for Idx in 0 ..< OptionList.count
        {
            if OptionList[Idx].Shape == Item
            {
                return Idx
            }
        }
        return nil
    }
    
    func RemoveShape(_ Item: Shapes)
    {
        if let Index = IndexOf(Item: Item)
        {
            OptionList.remove(at: Index)
        }
    }
    
    func GetOptions(For Item: Shapes) -> OptionItem?
    {
        for SomeOptionItem in OptionList
        {
            if SomeOptionItem.Shape == Item
            {
                return SomeOptionItem
            }
        }
        return nil
    }
    
    subscript(index: Shapes) -> OptionItem?
    {
        get
        {
        return GetOptions(For: index)
        }
    }
}
