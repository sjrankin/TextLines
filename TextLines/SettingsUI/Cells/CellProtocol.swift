//
//  CellProtocol.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/4/21.
//

import Foundation
import UIKit

/// Protocol to update type cells on the fly.
protocol CellProtocol: AnyObject
{
    /// Update the width of the cell.
    /// - Parameter Width: New width.
    func SetWidth(_ Width: CGFloat)
}
