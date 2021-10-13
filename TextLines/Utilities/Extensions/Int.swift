//
//  Int.swift
//  Int
//
//  Created by Stuart Rankin on 7/18/21. Adapted from Flatland View.
//

import Foundation
import UIKit

extension Int
{
    /// Returns the instance value as a delimited string.
    /// - Parameter Delimiter: The character (or string if the caller prefers) to use to delimit thousands blocks.
    /// - Returns: Value as a character delimited string.
    func Delimited(Delimiter: String = ",") -> String
    {
        let Raw = "\(self)"
        if Raw.count <= 3
        {
            return Raw
        }
        var RawArray = Array(Raw)
        var Working = ""
        while RawArray.count > 0
        {
            let Last3 = RawArray.suffix(3)
            var Sub = ""
            for C in Last3
            {
                Sub = Sub + String(C)
            }
            if RawArray.count >= 3
            {
                RawArray.removeLast(3)
            }
            else
            {
                RawArray.removeAll()
            }
            let Separator = RawArray.count > 0 ? Delimiter : ""
            Working = "\(Separator)\(Sub)" + Working
        }
        return Working
    }
    
    /// Return the square of the instance value.
    var Squared: Int
    {
        get
        {
            return self * self
        }
    }
    
    /// Return the cube of the instance value.
    var Cubed: Int
    {
        get
        {
            return self * self * self
        }
    }
}
