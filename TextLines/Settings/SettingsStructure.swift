//
//  SettingsStructure.swift
//  SettingsStructure
//
//  Created by Stuart Rankin on 9/13/21.
//

import Foundation
import UIKit

class SettingsStructure
{
    public static var Groups: [StructureNode] =
    [
        StructureNode(Name: "Initialization", Keys: [(.InitializationFlag, true)]),
        StructureNode(Name: "Shapes", Keys: .MainShape, .CurrentShape),
        StructureNode(Name: "Image Rendering", Keys: .ImageTextFont, .ImageTextFontSize,
                      .TextColor, .BackgroundColor, .GuidelineColor, .ShowGuidelines,
                      .ImageWidth, .ImageHeight, .ClockwiseText, .ShowCheckerboard,
                      .BackgroundType, .RotateCharacters, .TextOffset, .ShapeAlignment,
                      .ActionIconName, .CommandButtonList, .ViewportWidth, .ViewportHeight,
                      .CircleRadiusPercent, .GridColor, .ShowGridLines),
        StructureNode(Name: "Debug", Keys: .ShowGuideMarks, .GuidelineWidth),
        StructureNode(Name: "Animation", Keys: .AnimationSpeed, .AnimateClockwise,
                      .Animating),
        StructureNode(Name: "Common Parameters", Keys: .CommonSmoothing),
        StructureNode(Name: "Circle Parameters", Keys: .CircleAngle, .CircleDiameter),
        StructureNode(Name: "Ellipse Parameters", Keys: .EllipseAngle, .EllipseMajor, .EllipseMinor),
        StructureNode(Name: "Rectangle Parameters", Keys: .RectangleWidth, .RectangleHeight,
                      .RectangleRoundedCorners),
        StructureNode(Name: "Triangle Parameters", Keys: .TriangleBase, .TriangleHeight, .TriangleRounded),
        StructureNode(Name: "Line Parameters", Keys: .LineLength, .LineType, .LineStyle),
        StructureNode(Name: "Spiral Line Parameters", Keys: .SpiralStartRadius, .SpiralSpacePerLoop,
                      .SpiralStartTheta, .SpiralEndTheta, .SpiralThetaStep,
                      .SpiralSquare, .SpiralSquareSmooth),
        StructureNode(Name: "Octagon Parameters", Keys: .OctagonWidth, .OctagonHeight),
        StructureNode(Name: "Hexagon Parameters", Keys: .HexagonWidth, .HexagonHeight),
        StructureNode(Name: "User Shape Parameters", Keys: .UserShapes, .CurrentUserShape,
                      .ShowViewport, .ScaleToView, .UserShapeOptionsOrder, .PointsWhenSmooth),
        StructureNode(Name: "N-Gon Parameters", Keys: .NGonVertexCount, .NGonRotation,
                      .NGonWidth, .NGonHeight, .NGonDrawSmooth),
        StructureNode(Name: "Star Parameters", Keys: .StarVertexCount, .StarInnerRadius,
                      .StarOuterRadius, .StarRotation, .StarDrawSmooth),
    ]
}

class StructureNode
{
    init(Name: String, Keys: [SettingKeys])
    {
        GroupName = Name
        for Key in Keys
        {
            GroupSettings.append((Key, false))
        }
    }
    
    init(Name: String, Keys: SettingKeys...)
    {
        GroupName = Name
        for Key in Keys
        {
            GroupSettings.append((Key, false))
        }
    }
    
    init(Name: String, Keys: [(SettingKeys, Bool)])
    {
        GroupName = Name
        for (Key, ReadOnly) in Keys
        {
            GroupSettings.append((Key, ReadOnly))
        }
    }
    
    var GroupName: String = ""
    var GroupSettings: [(SettingKeys, Bool)] = [(SettingKeys, Bool)]()
}
