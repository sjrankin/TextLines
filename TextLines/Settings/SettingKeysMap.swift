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
        .GridColor: UIColor.self,
        .ShowGuidelines: Bool.self,
        .ShowGridLines: Bool.self,
        .ImageWidth: Int.self,
        .ImageHeight: Int.self,
        .ClockwiseText: Bool.self,
        .ShowCheckerboard: Bool.self,
        .BackgroundType: Backgrounds.self,
        .RotateCharacters: Bool.self,
        .TextOffset: Int.self,
        .ShapeAlignment: ShapeAlignments.self,
        .ActionIconName: String.self,
        .CommandButtonList: [String].self,
        .ViewportWidth: Int.self,
        .ViewportHeight: Int.self,
        .CircleRadiusPercent: Double.self,
        
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
        .EllipseMajor: Double.self,
        .EllipseMinor: Double.self,
        
        // MARK: - Square/rectangle attributes.
        .RectangleWidth: Double.self,
        .RectangleHeight: Double.self,
        .RectangleRoundedCorners: Bool.self,
        
        // MARK: - Triangle attributes.
        .TriangleBase: Double.self,
        .TriangleHeight: Double.self,
        .TriangleRounded: Bool.self,
        
        // MARK: - Line attributes
        .LineLength: Double.self,
        .LineType: LineOptions.self,
        .LineStyle: LineStyles.self,
        
        // MARK: - Spiral line attributes
        .SpiralStartRadius: CGFloat.self,
        .SpiralSpacePerLoop: CGFloat.self,
        .SpiralStartTheta: CGFloat.self,
        .SpiralEndTheta: CGFloat.self,
        .SpiralThetaStep: CGFloat.self,
        
        //MARK: - Octagon attributes
        .OctagonWidth: Double.self,
        .OctagonHeight: Double.self,
        
        // MARK: - Hexagon attributes
        .HexagonWidth: Double.self,
        .HexagonHeight: Double.self,
        
        // MARK: - User shapes attributes
        .UserShapes: String.self,
        .CurrentUserShape: UUID.self,
        .ShowViewport: Bool.self,
        .ScaleToView: Bool.self,
        .UserShapeOptionsOrder: String.self,
        .PointsWhenSmooth: Bool.self,
        
        // MARK: - N-gon attributes
        .NGonVertexCount: Int.self,
        .NGonRotation: Double.self,
        .NGonWidth: Double.self,
        .NGonHeight: Double.self,
    ]
}
