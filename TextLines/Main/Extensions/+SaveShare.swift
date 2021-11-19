//
//  +SaveShare.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/17/21.
//

import Foundation
import UIKit

extension ViewController: UIActivityItemSource
{
    // MARK: - Save image locally.
    
    /// Saves the current image being displayed in the user's photo album. If permissions have not
    /// been granted, the user will be asked automatically by iOS.
    func SaveCurrentImage()
    {
        guard let ImageToSave = TextOutput.image else
        {
            ShowQuickMessage(Message: "Cannot Save",
                             For: 3.5,
                             FadeAfter: 1.5,
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
            //The final animated alpha level must be greater than 0.0. A value of
            //0.05 works well.
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
    
    // MARK: - Share image.
    
    /// Share the image using built-in controllers.
    func ShareCurrentImage()
    {
        let Items: [Any] = [self]
        let ACV = UIActivityViewController(activityItems: Items, applicationActivities: nil)
        ACV.popoverPresentationController?.sourceView = self.view
        ACV.popoverPresentationController?.sourceRect = self.view.frame
        ACV.popoverPresentationController?.canOverlapSourceViewRect = true
        ACV.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        self.present(ACV, animated: true, completion: nil)
    }
    
    /// Returns the subject line for possible use when exporting the image.
    /// - Parameter activityViewController: Not used.
    /// - Parameter subjectForActivityType: Not used.
    /// - Returns: Subject line.
    public func activityViewController(_ activityViewController: UIActivityViewController,
                                       subjectForActivityType activityType: UIActivity.Type?) -> String
    {
        return "TextLines Image"
    }
    
    /// Determines the type of object to export.
    /// - Parameter activityViewController: Not used.
    /// - Returns: Instance of the type to export. In our case, a `UIImage`.
    public func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any
    {
        return UIImage()
    }
    
    /// Returns the object to export (the type of which is determined in `activityViewControllerPlaceholderItem`.
    /// - Parameter activityViewController: Not used.
    /// - Parameter itemForActivityType: Determines how the user wants to export the image. In our case, we support
    ///                                  anything that accepts an image.
    /// - Returns: The image of the gradient.
    public func activityViewController(_ activityViewController: UIActivityViewController,
                                       itemForActivityType activityType: UIActivity.ActivityType?) -> Any?
    {
        guard let Target = activityType else
        {
            return nil
        }
        guard let FinalImage = SharedImage else
        {
            Debug.Print("No image to share.")
            return nil
        }
        
        switch Target
        {
            case .postToTwitter,
                    .airDrop,
                    .assignToContact,
                    .copyToPasteboard,
                    .mail,
                    .message,
                    .postToFlickr,
                    .postToWeibo,
                    .postToTwitter,
                    .postToFacebook,
                    .postToTencentWeibo,
                    .print,
                    .markupAsPDF,
                    .saveToCameraRoll:
                return FinalImage
                
            default:
                return FinalImage
        }
    }
}
