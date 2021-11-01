//
//  Enums.swift
//  Enums
//
//  Created by Stuart Rankin on 8/15/21.
//

import Foundation
import UIKit

/// Shapes upon which text is plotting along the perimeter/edge.
enum Shapes: String, CaseIterable
{
    /// Circle.
    case Circle = "Circle"
    /// Ellipse/oval.
    case Ellipse = "Ellipse"
    /// Rectangle/square.
    case Rectangle = "Square"
    /// Triangle.
    case Triangle = "Triangle"
    /// Bezier path.
    case Bezier = "Bezier"
    /// Scribbled path.
    case Scribble = "Scribble"
    /// Spiral path.
    case Spiral = "Spiral"
    /// Hexagonal shape.
    case Hexagon = "Hexagon"
    /// Octangonal shape.
    case Octagon = "Octagon"
    /// Infinity symbol.
    case Infinity = "Infinity"
    /// Line shape.
    case Line = "Line"
    /// Heart shape.
    case Heart = "Heart"
    /// User-defined shape.
    case User = "User"
}

/// Type of background.
enum Backgrounds: String, CaseIterable
{
    /// Solid (or transparent) color.
    case Color = "Color"
    /// Image.
    case Image = "Image"
}

/// Main shape categories.
enum ShapeCategories: String, CaseIterable
{
    /// Simple, geometric, closed shapes.
    case Shapes = "Shapes"
    /// Lines (open shapes).
    case Lines = "Lines"
    /// Free-form shapes (defined by the user).
    case Freeform = "Freeform"
}

/// Command buttons.
enum CommandButtons: String, CaseIterable
{
    /// The action button.
    case ActionButton = "ActionButton"
    
    /// The projects button.
    case ProjectButton = "ProjectButton"
    
    /// The camera button.
    case CameraButton = "CameraButton"
    
    /// The video button.
    case VideoButton = "VideoButton"
    
    /// The save button.
    case SaveButton = "SaveButton"
    
    /// The share button.
    case ShareButton = "ShareButton"
    
    /// The font button.
    case FontButton = "FontButton"
    
    /// The play animation button.
    case PlayButton = "PlayButton"
    
    /// The user shape button.
    case UserButton = "UserButton"
    
    /// Background button.
    case BackgroundButton = "BackgroundButton"
}

/// Automatic text on shape alignments.
/// - Note: Not all alignments are valid for all shapes - invalid alignments are
///         treated as `.None`.
enum ShapeAlignments: String, CaseIterable
{
    /// No alignment (uses `.TextOffset` or animation).
    case None = "None"
    /// Align at the top of the shape.
    case Top = "Top"
    /// Align at the bottom of the shape.
    case Bottom = "Bottom"
    /// Align at the left-side of the shape.
    case Left = "Left"
    /// Align at the right-side of the shape.
    case Right = "Right"
}

/// Image types supported by the `TitledImage` class. These are based on which constructor
/// should be called when creating the image.
enum ImageTypes
{
    /// Normal type of image created with `UIImage(named:)`.
    case Normal
    /// SVG type of image created with `UIImage(named:)` but which requires further color processing.
    case SVG
    /// System image created with `UIImage(systemName:)`.
    case System
}

/// Orientations of simple lines.
enum LineOptions: String, CaseIterable
{
    /// Horizontal lines.
    case Horizontal = "Horizontal"
    /// Vertical lines.
    case Vertical = "Vertical"
    /// Diagonal lines with negative 45° slope.
    case DiagonalDescending = "DiagonalDescending"
    /// Diagonal lines with positive 45° slope.
    case DiagonalAscending = "DiagonalAscending"
}

/// Styles for straight lines.
enum LineStyles: String, CaseIterable
{
    /// Straight, unadored line.
    case Straight = "Straight"
    /// Square wave line.
    case SquareWave = "SquareWave"
    /// Saw tooth wave line.
    case SawtoothWave = "SawtoothWave"
    /// Sine wave line.
    case SineWave = "SineWave"
    /// Curlicue line.
    case Curlicue = "Curlicue"
}

/// Standard viewport dimentional sizes. Used for user shapes.
enum ViewportSizes: String, CaseIterable
{
    /// Small sized - 500 pixels.
    case Small = "500"
    /// Medium sized - 1000 pixels.
    case Medium = "1000"
    /// Large sized - 1500 pixels.
    case Large = "1500"
}
