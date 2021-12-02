//
//  SettingHeaders.swift
//  SettingHeaders
//
//  Created by Stuart Rankin on 9/13/21.
//

import Foundation
import UIKit

extension Settings
{
/// Map between a setting key and an associated header.
public static let SettingKeyHeaders: [SettingKeys: String] =
[
    // MARK: - Initialization.
    .InitializationFlag: "Initial initialization",
    
    // MARK: - General shape settings.
    .MainShape: "Shape category",
    .CurrentShape: "Current shape",
    
    // MARK: - Full image attributes.
    .ImageTextFont: "Font name",
    .ImageTextFontSize: "Font size",
    .TextColor: "Font/text color",
    .BackgroundColor: "Background color",
    .GuidelineColor: "Guideline color",
    .GridColor: "Grid color",
    .ShowGuidelines: "Show guidelines",
    .ShowGridLines: "Show gridlines",
    .ImageWidth: "Image width",
    .ImageHeight: "Image height",
    .ClockwiseText: "Clockwise text",
    .ShowCheckerboard: "Show checkerboard",
    .BackgroundType: "Background type",
    .RotateCharacters: "Text orientation",
    .TextOffset: "Text offset",
    .ShapeAlignment: "Text alignment",
    .ActionIconName: "Action icon",
    .CommandButtonList: "Command buttons",
    .ViewportHeight: "Viewport height",
    .ViewportWidth: "Viewport width",
    .CircleRadiusPercent: "Radial%",
    
    // MARK: - Debug attributes.
    .ShowGuideMarks: "Show guidemarks",
    .GuidelineWidth: "Guideline width",
    
    // MARK: - Animation attributes.
    .AnimationSpeed: "Animation speed",
    .AnimateClockwise: "Animate clockwise",
    .Animating: "Currently animating",
    
    // MARK: - Circular attributes.
    .CircleAngle: "Circle angle",
    .CircleDiameter: "Diameter",
    
    // MARK: - Elliptical attributes.
    .EllipseAngle: "Ellipse angle",
    .EllipseMajor: "Width",
    .EllipseMinor: "Height",
    
    // MARK: - Square/rectangle attributes.
    .RectangleWidth: "Width",
    .RectangleHeight: "Height",
    .RectangleRoundedCorners: "Round corners",
    
    // MARK: - Triangle attributes.
    .TriangleBase: "Base",
    .TriangleHeight: "Height",
    .TriangleRounded: "Rounded",
    
    // MARK: - Line attributes
    .LineLength: "Line length",
    .LineType: "Orientation",
    .LineStyle: "Style",
    
    // MARK: - Spiral line attributes
    .SpiralStartRadius: "Start radius",
    .SpiralSpacePerLoop: "Loop gap",
    .SpiralStartTheta: "Start theta",
    .SpiralEndTheta: "End theta",
    .SpiralThetaStep: "Theta step",
    
    //MARK: - Octagon attributes
    .OctagonWidth: "Width",
    .OctagonHeight: "Height",
    
    // MARK: - Hexagon attributes
    .HexagonWidth: "Width",
    .HexagonHeight: "Height",
    
    // MARK: - User shapes attributes
    .UserShapes: "User shapes",
    .CurrentUserShape: "User shape",
    .ShowViewport: "Show viewport",
    .ScaleToView: "Scale drawing",
    .UserShapeOptionsOrder: "Option order",
    .PointsWhenSmooth: "Point when smooth",
    
    // MARK: - N-gon attributes
    .NGonVertexCount: "Vertex count",
    .NGonRotation: "Shape rotation",
    .NGonWidth: "Width of n-gon",
    .NGonHeight: "Height of n-gon",
    ]
}
