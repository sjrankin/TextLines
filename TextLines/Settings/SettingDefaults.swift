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
        
        // MARK: - Debug attributes.
        .ShowGuideMarks: false,
        .GuidelineWidth: 2.0,
        
        // MARK: - Animation attributes.
        .AnimationSpeed: 3,
        .AnimateClockwise: true,
        .Animating: false,
        
        // MARK: - Circle attriubtes.
        .CircleAngle: 1.57079632679,        //pi / 2
        .CircleDiameter: 1000,
        
        // MARK: - Elliptical attributes.
        .EllipseAngle: 1.57079632679,       //pi / 2
        .EllipseLength: 1000,
        .EllipseHeight: 700,
        
        // MARK: - Square/rectangle attributes.
        .RectangleWidth: 1024,
        .RectangleHeight: 1024,
        .RectangleRoundedCorners: true,
        
        // MARK: - Triangle attributes.
        .TriangleBase: 500,
        .TriangleHeight: 250,
        .TriangleRounded: false,
        
        // MARK: - Line attributes
        .LineLength: 500,
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
    ]
}
