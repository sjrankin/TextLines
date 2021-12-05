//
//  SettingDefaults.swift
//  SettingDefaults
//
//  Created by Stuart Rankin on 8/14/21.
//

import Foundation
import UIKit

extension Settings
{
    /// Map between a setting key and the type of data it stores.
    public static let SettingDefaults: [SettingKeys: Any] =
    [
        // MARK: - Initialization.
        .InitializationFlag: false,
        
        // MARK: - General shape settings.
        .MainShape: ShapeCategories.Shapes,
        .CurrentShape: Shapes.Circle,
        
        // MARK: - Full image attributes.
        .ImageTextFont: "Avenir-Black",
        .ImageTextFontSize: 48.0,
        .TextColor: UIColor.white,
        .BackgroundColor: UIColor.clear,
        .GuidelineColor: UIColor.red,
        .GridColor: UIColor.yellow,
        .ShowGuidelines: true,
        .ShowGridLines: false,
        .ImageWidth: 1024,
        .ImageHeight: 1024,
        .ClockwiseText: true,
        .ShowCheckerboard: true,
        .BackgroundType: Backgrounds.Color,
        .RotateCharacters: false,
        .TextOffset: 0,
        .ShapeAlignment: ShapeAlignments.None,
        .ActionIconName: "ThreeDotsInCircleIcon",
        .ViewportWidth: 1024,
        .ViewportHeight: 1024,
        .CircleRadiusPercent: 0.95,
        
        // MARK: - Debug attributes.
        .ShowGuideMarks: false,
        .GuidelineWidth: 2.0,
        
        // MARK: - Animation attributes.
        .AnimationSpeed: AnimationSpeeds.Medium.rawValue,
        .AnimateClockwise: true,
        .Animating: false,
        
        // MARK: - Common attributes.
        .CommonSmoothing: false,
        
        // MARK: - Circle attributes.
        .CircleAngle: 1.57079632679,        //pi ÷ 2
        .CircleDiameter: 1000,
        
        // MARK: - Elliptical attributes.
        .EllipseAngle: 1.57079632679,       //pi ÷ 2
        .EllipseMajor: 0.95,
        .EllipseMinor: 0.65,
        
        // MARK: - Square/rectangle attributes.
        .RectangleWidth: 0.9,
        .RectangleHeight: 0.9,
        .RectangleRoundedCorners: true,
        
        // MARK: - Triangle attributes.
        .TriangleBase: 0.9,
        .TriangleHeight: 0.9,
        .TriangleRounded: false,
        
        // MARK: - Line attributes
        .LineLength: 0.9,
        .LineType: LineOptions.Horizontal,
        .LineStyle: LineStyles.Straight,
        
        // MARK: - Spiral line attributes
        .SpiralStartRadius: 0.0,
        .SpiralSpacePerLoop: 9.0,
        .SpiralStartTheta: 0.0,
        .SpiralEndTheta: 45.0,
        .SpiralThetaStep: 0.0,
        .SpiralSquare: false,
        .SpiralSquareSmooth: false,
        
        //MARK: - Octagon attributes
        .OctagonWidth: 0.9,
        .OctagonHeight: 0.9,
        
        // MARK: - Hexagon attributes
        .HexagonWidth: 0.9,
        .HexagonHeight: 0.9,
        
        // MARK: - User shapes attributes
        .UserShapes: "",
        .CurrentUserShape: UUID.Empty,
        .ShowViewport: true,
        .ScaleToView: true,
        .UserShapeOptionsOrder: "",
        .PointsWhenSmooth: false,
        
        // MARK: - N-gon attributes
        .NGonVertexCount: 7,
        .NGonRotation: 90.0,
        .NGonWidth: 0.95,
        .NGonHeight: 0.95,
        .NGonDrawSmooth: false,
        
        // MARK: - Star attributes
        .StarVertexCount: 5,
        .StarInnerRadius: 0.5,
        .StarOuterRadius: 0.9,
        .StarRotation: 90.0,
        .StarDrawSmooth: false,
    ]
}
