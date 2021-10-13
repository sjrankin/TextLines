//
//  FontInfo.swift
//  FontInfo
//
//  Created by Stuart Rankin on 8/31/21.
//

import Foundation
import UIKit

class FontInfo
{
    var FontName: String = ""
    
    var Weights: [String] = [String]()
    var OriginalWeights: [String] = [String]()
    var WeightFontNames: [String] = [String]()
    
    func Clear()
    {
        FontName = ""
        Weights.removeAll()
    }
}
