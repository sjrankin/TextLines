//
//  Filters.swift
//  Filters
//
//  Created by Stuart Rankin on 8/29/21.
//

import Foundation
import UIKit
import CoreGraphics
import CoreImage.CIFilterBuiltins

class Filters
{
    /// Create and return a checkerboard pattern.
    /// - Parameters:
    ///   - Width: Width of the returned image. Best if a multiple of `CheckerSize`.
    ///   - Height: Height of the returned image. Best if a multiple of `CheckerSize`.
    ///   - CheckerSize: Width (and height) of a single check (block).
    ///   - Color0: First color to use.
    ///   - Color1: Second color to use.
    /// - Returns: Checkerboard pattern image on success, nil on error.
    public static func Checkerboard(Width: CGFloat, Height: CGFloat, CheckerSize: Int,
                                    Color0: CIColor = CIColor.gray, Color1: CIColor = CIColor.white) -> UIImage?
    {
        let Filter = CIFilter.checkerboardGenerator()
        Filter.color0 = Color0
        Filter.color1 = Color1
        Filter.width = Float(CheckerSize)
        Filter.center = CGPoint.zero//CGPoint(x: Width / 2.0, y: Height / 2.0)
        if let First = Filter.outputImage
        {
            let CropFilter = CIFilter(name: "CICrop")
            let Size = CIVector(x: 0, y: 0, z: Width, w: Height)
            CropFilter?.setValue(Size, forKey: "inputRectangle")
            CropFilter?.setValue(First, forKey: "inputImage")
            if let Second = CropFilter?.outputImage
            {
                let Final = UIImage(ciImage: Second)
                return Final
            }
        }
        return nil
    }
}
