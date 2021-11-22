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
        .AnimationSpeed: 3,
        .AnimateClockwise: true,
        .Animating: false,
        
        // MARK: - Circle attriubtes.
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
        .SpiralSpacePerLoop: 5.0,
        .SpiralStartTheta: 0.0,
        .SpiralEndTheta: 40.0,
        .SpiralThetaStep: 1,
        
        // MARK: - User shapes attributes
        .UserShapes: "",
        .CurrentUserShape: UUID.Empty,
        .ShowViewport: true,
        .ScaleToView: true,
        .UserShapeOptionsOrder: "",
        .PointsWhenSmooth: false,
    ]
}
