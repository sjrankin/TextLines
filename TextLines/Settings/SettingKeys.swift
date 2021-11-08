//
//  SettingKeys.swift
//  SettingKeys
//
//  Created by Stuart Rankin on 7/19/21. Adapted from Flatland View.
//

import Foundation

/// Settings. Each case refers to a single setting and is used
/// by the settings class to access the setting.
enum SettingKeys: String, CaseIterable
{
    // MARK: - Infrastructure/initialization-related settings.
    case InitializationFlag = "InitializationFlag"
    
    // MARK: - General shape settings.
    /// MainShapes: Current shape category.
    case MainShape = "MainShape"
    /// Shapes: Current shape name.
    case CurrentShape = "CurrentShape"
    
    // MARK: - Settings for the overall image.
    /// String: Name of the font to use.
    case ImageTextFont = "ImageTextFont"
    /// CGFloat: Size of the font.
    case ImageTextFontSize = "ImageTextFontSize"
    /// UIColor: Color of the text.
    case TextColor = "TextColor"
    /// UIColor: Color of the background.
    case BackgroundColor = "BackgroundColor"
    /// UIColor: Color of the guidelines.
    case GuidelineColor = "GuidelineColor"
    /// UIColor: Color of grid lines.
    case GridColor = "GridColor"
    /// Bool: Show guidelines on the screen (but don't save them).
    case ShowGuidelines = "ShowGuidelines"
    /// Int: Width of the image.
    case ImageWidth = "ImageWidth"
    /// Int: Height of the image.
    case ImageHeight = "ImageHeight"
    /// Boolean: Determines the orientation of the text.
    case ClockwiseText = "ClockwiseText"
    /// Boolean: Show checkerboard pattern behind transparent or semi-transparent color
    /// backgrounds.
    case ShowCheckerboard = "ShowCheckerboard"
    /// Backgrounds: The type of background to use.
    case BackgroundType = "BackgroundType"
    /// Bool: Rotate characters 180° from the tangent of the curve.
    case RotateCharacters = "RotateCharacters"
    /// Int: Static intial text offset.
    case TextOffset = "TextOffset"
    /// ShapeAlignments: Defines how text aligns to shapes.
    case ShapeAlignment = "ShapeAlignment"
    /// String: Name of the icon to use for the action button.
    case ActionIconName = "ActionIconName"
    /// [String]: List of command buttons being displayed.
    case CommandButtonList = "CommandButtonList"
    /// Int: Viewport width.
    case ViewportWidth = "ViewportWidth"
    /// Int: Viewport height.
    case ViewportHeight = "ViewportHeight"
    
    // MARK: - Debug attributes.
    /// Bool: Show debug guidemarks.
    case ShowGuideMarks = "ShowGuideMarks"
    /// CGFloat: Width of guidelines
    case GuidelineWidth = "GuidelineWidth"
    
    // MARK: - Animation attributes.
    /// Int: Relative speed of the animation.
    case AnimationSpeed = "AnimationSpeed"
    /// Bool: Determines direction to animate.
    case AnimateClockwise = "AnimateClockwise"
    /// Bool: Currently animating flag.
    case Animating = "Animating"
    
    // MARK: - Circle attriubtes.
    /// Double: Starting angle for circular text.
    case CircleAngle = "CircleAngle"
    /// Int: Diameter of circle used to plot text.
    case CircleDiameter = "CircleDiameter"
    /// Double: Radius of the circle in terms of percent of the viewport.
    case CircleRadiusPercent = "CircleRadiusPercent"
    
    // MARK: - Ellipse attributes.
    /// Double: Starting angle for the ellipse text
    case EllipseAngle = "EllipseAngle"
    /// Int: Long axis of the ellipse.
    case EllipseLength = "EllipseLength"
    /// Int: Short axis of the ellipse.
    case EllipseHeight = "EllipseHeight"
    
    // MARK: - Square/rectangle attributes
    /// Int: Width of the rectangle.
    case RectangleWidth = "RectangleWidth"
    /// Int: Height of the rectangle.
    case RectangleHeight = "RectangleHeight"
    /// Bool: If true, rectangles are drawn with rounded corners.
    case RectangleRoundedCorners = "RectangleRoundedCorners"
    
    // MARK: - Triangle attributes.
    /// Int: Base length of the triangle.
    case TriangleBase = "TriangleBase"
    /// Int: Base height of the triangle.
    case TriangleHeight = "TriangleHeight"
    /// Bool: Determines if the vertices of the triangle are rounded.
    case TriangleRounded = "TriangleRounded"
    
    // MARK: - Line attributes
    /// Int: Length of the line.
    case LineLength = "LineLength"
    /// LineOptions: Orientation of the line.
    case LineType = "LineType"
    /// LineStyles: Determines how to draw a straight line.
    case LineStyle = "LineStyle"
    
    // MARK: - Horizontal line attributes
    /// Int: Length of horizontal line.
    case HorizontalLineLength = "HorizontalLineLength"
    
    // MARK: - Vertical line attributes
    /// Int: Length of vertical line.
    case VerticalLineLength = "VerticalLineLength"
    
    // MARK: - Spiral line attributes
    /// CGFloat: Starting radius.
    case SpiralStartRadius = "StartRadius"
    /// CGFloat: Space between loops.
    case SpiralSpacePerLoop = "SpacePerLoop"
    /// CGFloat: Starting theta.
    case SpiralStartTheta = "StartTheta"
    /// CGFloat: Ending theta.
    case SpiralEndTheta = "EndTheta"
    /// CGFloat: Theta step value.
    case SpiralThetaStep = "ThetaStep"
    
    // MARK: - User shapes.
    /// String: All user-defined shapes.
    case UserShapes = "UserShapes"
    /// UUID: ID of the current user shape. If a UUID with all `0`s is returned, the
    /// current shape is not set.
    case CurrentUserShape = "CurrentUserShape"
    /// Bool: Show or hide the viewport in the user shape editor.
    case ShowViewport = "ShowViewport"
    /// Bool: Scale user drawing to available view.
    case ScaleToView = "ScaleToView"
    /// String: Order of options for editing user shapes.
    case UserShapeOptionsOrder = "UserShapeOptionsOrder"
    /// Bool: Show original points when in smooth mode.
    case PointsWhenSmooth = "PointsWhenSmooth"
}
