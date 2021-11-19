//
//  UIImageView2.swift
//  TextLines
//
//  Created by Stuart Rankin on 10/24/21.
//

import Foundation
import UIKit

/// UIImageView with a .Net-like tag.
class UIImageView2: UIImageView
{
    /// Get or set a tag value of any type. Defaults to `nil`.
    var Tag: Any? = nil
}

extension UIImageView
{
    /// Returns the image with the background color.
    /// - Returns: Image with the background color or nil on error.
    func ImageWithBackground() -> UIImage?
    {
        guard let Image = self.image else
        {
            return nil
        }
        let BGColor = Settings.GetColor(.BackgroundColor, UIColor.black)
        if BGColor.a == 0.0
        {
            let BackgroundImage = UIImage(Color: UIColor.black, Size: Image.size)
            let Blitted = Image.BlitOnBackground(BackgroundImage)
            return Blitted
        }
        return Image
    }
}
