//
//  SettingKeysMap.swift
//  SettingKeysMap
//
//  Created by Stuart Rankin on 7/19/21. Adapted from Flatland View.
//

import Foundation
import UIKit

extension Settings
{
    /// Map between a setting key and the type of data it stores.
    public static let SettingKeyTypes: [SettingKeys: Any] =
    [
        // MARK: - Initialization.
        .InitializationFlag: Bool.self,
        
        // MARK: - General shape settings.
        .MainShape: ShapeCategories.self,
        .CurrentShape: Shapes.self,
        
        // MARK: - Full image attributes.
        .ImageTextFont: String.self,
        .ImageTextFontSize: CGFloat.self,
        .TextColor: UIColor.self,
        .BackgroundColor: UIColor.self,
        .GuidelineColor: UIColor.self,
        .ShowGuidelines: Bool.self,
        .ImageWidth: Int.self,
        .ImageHeight: Int.self,
        .ClockwiseText: Bool.self,
        .ShowCheckerboard: Bool.self,
        .BackgroundType: Backgrounds.self,
        .RotateCharacters: Bool.self,
        .TextOffset: Int.self,
        .ShapeAlignment: ShapeAlignments.self,
        .ActionIconName: String.self,
        
        // MARK: - Debug attributes.
        .ShowGuideMarks: Bool.self,
        .GuidelineWidth: CGFloat.self,
        
        // MARK: - Animation attributes.
        .AnimationSpeed: Int.self,
        .AnimateClockwise: Bool.self,
        .Animating: Bool.self,
        
        // MARK: - Circular attributes.
        .CircleAngle: Double.self,
        .CircleDiameter: Int.self,
        
        // MARK: - Elliptical attributes.
        .EllipseAngle: Double.self,
        .EllipseLength: Int.self,
        .EllipseHeight: Int.self,
        
        // MARK: - Square/rectangle attributes.
        .RectangleWidth: Int.self,
        .RectangleHeight: Int.self,
        .RectangleRoundedCorners: Bool.self,
        
        // MARK: - Triangle attributes.
        .TriangleBase: Int.self,
        .TriangleHeight: Int.self,
        .TriangleRounded: Bool.self,
        
        // MARK: - Line attributes
        .LineLength: Int.self,
        .LineType: LineOptions.self,
        .LineStyle: LineStyles.self,
        
        // MARK: - Spiral line attributes
        .SpiralStartRadius: CGFloat.self,
        .SpiralSpacePerLoop: CGFloat.self,
        .SpiralStartTheta: CGFloat.self,
        .SpiralEndTheta: CGFloat.self,
        .SpiralThetaStep: CGFloat.self,
        
        // MARK: - User shapes attributes
        .UserShapes: String.self,
        .CurrentUserShape: UUID.self,
        .ShowViewport: Bool.self,
        .ScaleToView: Bool.self,
        .UserShapeOptionsOrder: String.self,
    ]
}
