//
//  +SaveShare.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/17/21.
//

import Foundation
import UIKit

extension ViewController
{
    /// Saves the current image being displayed in the user's photo album. If permissions have not
    /// been granted, the user will be asked automatically by iOS.
    func SaveCurrentImage()
    {
        guard let ImageToSave = TextOutput.image else
        {
            ShowQuickMessage(Message: "Cannot Save",
                             For: 3.5,
                             FadeAfter: 1.0,
                             Foreground: UIColor.systemYellow,
                             Background: UIColor.systemRed)
            Debug.Print("No image to save in \(#function).")
            return
        }
        ImageToSave.SaveInPhotoAlbum()
        ShowQuickMessage(Message: "Image Saved",
                         For: 2.0,
                         FadeAfter: 1.5,
                         Background: UIColor.systemGreen)
    }
    
    /// Show a very short message over the main view.
    /// - Note: The user can tap on the message to make it disappear immediately.
    /// - Note: See [Interaction during animation](https://stackoverflow.com/questions/25477093/difficulty-allowing-user-interaction-during-uiview-animation)
    /// - Parameter Message: The text of the message. Three words is probably the most
    ///                      that will fit.
    /// - Parameter For: Duration (in seconds) to fade out the message.
    /// - Parameter FadeAfter: Duration to wait before starting to fade, in seconds. Defaults
    ///                        to `0.5`.
    /// - Parameter Foreground: Color of the text to display. Defaults to `UIColor.black`.
    /// - Parameter Background: Background color of the message.
    func ShowQuickMessage(Message: String, For Duration: Double,
                          FadeAfter: Double = 0.5,
                          Foreground: UIColor = UIColor.black,
                          Background Color: UIColor)
    {
        ShortMessageLabel.isHidden = false
        ShortMessageLabel.alpha = 1.0
        ShortMessageLabel.layer.zPosition = 2000
        ShortMessageLabel.text = Message
        ShortMessageLabel.textColor = Foreground
        ShortMessageLabel.backgroundColor = Color
        ShortMessageLabel.becomeFirstResponder()
        ShortMessageLabel.isUserInteractionEnabled = true
 
        UIView.animate(withDuration: Duration,
                       delay: FadeAfter,
                       options: [.allowUserInteraction],
                       animations:
                        {
            self.ShortMessageLabel.alpha = 0.05
        },
                       completion:
                        {
            IsCompleted in
            if IsCompleted
            {
                self.ShortMessageLabel.isHidden = true
                self.ShortMessageLabel.layer.zPosition = -1000
                self.ShortMessageLabel.alpha = 0.0
                self.ShortMessageLabel.resignFirstResponder()
            }
        })
        
    }
    
    func ShareCurrentImage()
    {
    }
}
