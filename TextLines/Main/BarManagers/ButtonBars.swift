//
//  ButtonBars.swift
//  ButtonBars
//
//  Created by Stuart Rankin on 8/24/21.
//

import Foundation
import UIKit

/// Manages the UI controls that allow the user to select Bezier shapes for the text.
class ButtonBars: NSObject, UIScrollViewDelegate
{
    /// Delegate to the main view. When set, late initialization is executed.
    public weak var delegate: MainProtocol? = nil
    {
        didSet
        {
            LateInitialization()
        }
    }
    
    /// Initializer.
    /// - Parameter MainView: Shape category bar.
    /// - Parameter ShapeContainerView: The `UIView` used for shape categories.
    init(MainView: UIScrollView,
         ShapeContainerView: UIView)
    {
        super.init()
        MainBar = MainView
        ShapeContainer = ShapeContainerView
    }
    
    var ShapeContainer: UIView = UIView()
    
    /// Called when the main view delegate is set.
    /// - Important: Requires the delegate to the main view to be valid. If not, at the very least,
    ///              a fatal error will result.
    func LateInitialization()
    {
        InitializeShapeRelatedButtons()
        CurrentMainShape = Settings.GetEnum(ForKey: .MainShape, EnumType: ShapeCategories.self, Default: .Shapes)
        CurrentSubShape = Settings.GetEnum(ForKey: .CurrentShape, EnumType: Shapes.self, Default: .Circle)
        SelectMainShape(CurrentMainShape)
        PopulateShapeContainer(CurrentSubShape)
    }
    
    /// Initialize the shape and category buttons.
    ///   - Sets up a tap gesture recognizer for each button.
    ///   - Initializes the category buttons.
    func InitializeShapeRelatedButtons()
    {
        guard let MainButtons = delegate?.GetMainImages() else
        {
            Debug.FatalError("Error retrieving main buttons")
        }
        
        let MainShapeTap = UITapGestureRecognizer2(target: self, action: #selector(CategoryButtonTapped))
        MainShapeTap.ForCategory = .Shapes
        let MainLineTap = UITapGestureRecognizer2(target: self, action: #selector(CategoryButtonTapped))
        MainLineTap.ForCategory = .Lines
        let MainFreeTap = UITapGestureRecognizer2(target: self, action: #selector(CategoryButtonTapped))
        MainFreeTap.ForCategory = .Freeform
        MainButtons[.Shapes]?.addGestureRecognizer(MainShapeTap)
        MainButtons[.Lines]?.addGestureRecognizer(MainLineTap)
        MainButtons[.Freeform]?.addGestureRecognizer(MainFreeTap)
    }
    
    var MainShapeButton: UIImageView = UIImageView()
    var MainLineButton: UIImageView = UIImageView()
    var MainFreeButton: UIImageView = UIImageView()
    
    /// Handle taps on category buttons.
    /// - Parameter recognizer: The gesture recognizer.
    @objc private func CategoryButtonTapped(_ recognizer: UITapGestureRecognizer)
    {
        guard let Recognizer = recognizer as? UITapGestureRecognizer2 else
        {
            fatalError("CategoryButtonTapped: Error converting tap gesture recognizer.")
        }
        CurrentMainShape = Recognizer.ForCategory
        SelectMainShape(CurrentMainShape)
        PopulateShapeContainer(CurrentSubShape)
    }
    
    /// Sets the visual state of category buttons. All buttons are set to normal tint except
    /// for the passed button type.
    /// - Note: This function will also highlight the appropriate shape button if it is in
    ///         the passed category.
    /// - Parameter NewShape: The button to highlight.
    func SelectMainShape(_ NewShape: ShapeCategories)
    {
        if let MainImages = delegate?.GetMainImages()
        {
            for (SomeType, SomeImage) in MainImages
            {
                SomeImage.tintColor = SomeType == CurrentMainShape ? .systemYellow : .systemBlue
            }
        }
    }
    
    /// Populate the shape container with shapes for the shape category in `CurrentMainShape`.
    /// - Parameter Shapes: The currently selected shape. If this shape is in the set of shapes defined
    ///                    by `CurrentMainShape`, it will be highlighted.
    func PopulateShapeContainer(_ Selected: Shapes)
    {
        for SomeShape in ShapeContainer.subviews
        {
            SomeShape.removeFromSuperview()
        }
        guard let NewButtons = ShapeStructure[CurrentMainShape] else
        {
            Debug.FatalError("No shape buttons for \(CurrentMainShape)")
        }
        CurrentShapeButtons.removeAll()
        var Index = 0
        let Offset: CGFloat = 10.0
        for NewButton in NewButtons
        {
            let ButtonView = MakeShapeButton(For: NewButton)
            if NewButton == Selected
            {
                ButtonView.tintColor = UIColor.systemYellow
            }
            ButtonView.frame = CGRect(x: Offset + CGFloat((Index * 45)),
                                      y: 2,
                                      width: 45.0,
                                      height: 45.0)
            ShapeContainer.addSubview(ButtonView)
            Index = Index + 1
            CurrentShapeButtons.append(ButtonView)
        }
    }
    
    var CurrentShapeButtons = [UIImageView2]()
    
    func MakeShapeButton(For Shape: Shapes) -> UIImageView2
    {
        let IView = UIImageView2(frame: CGRect(origin: .zero, size: CGSize(width: 42, height: 42)))
        IView.isUserInteractionEnabled = true
        IView.contentMode = .scaleAspectFit
        var Image: UIImage? = nil
        guard let ImageName = ShapeImages[Shape] else
        {
            Debug.FatalError("Error getting image name for \(Shape)")
        }
        
        if SVGShapes.contains(Shape)
        {
            Image = UIImage(named: ImageName)
        }
        else
        {
            Image = UIImage(systemName: ImageName)
        }
        
        guard let FinalImage = Image else
        {
            Debug.FatalError("Error creating button image")
        }
        IView.image = FinalImage
        if SVGShapes.contains(Shape)
        {
            IView.image = IView.image?.withRenderingMode(.alwaysTemplate)
            IView.tintColor = UIColor.systemBlue
        }
        let Recognizer = UITapGestureRecognizer2(target: self,
                                                 action: #selector(ShapeButtonTapped2))
        Recognizer.ForShape = Shape
        IView.addGestureRecognizer(Recognizer)
        IView.Tag = Shape
        
        return IView
    }
    
    /// Sets the visual state of shape buttons. All buttons are set to normal tint execpt for
    /// the passed button type.
    /// - Parameter Highlight: The button to show as highlighted.
    func SetShapeButtons2(_ Highlight: Shapes)
    {
        for ShapeButton in CurrentShapeButtons
        {
            guard let ForShape = ShapeButton.Tag as? Shapes else
            {
                Debug.FatalError("Error converting ShapeButton.Tag to Shapes.")
            }
            ShapeButton.tintColor = ForShape == Highlight ? .systemYellow : .systemBlue
        }
        Settings.SetEnum(Highlight, EnumType: Shapes.self, ForKey: .CurrentShape)
    }
    
    @objc func ShapeButtonTapped2(_ Recognizer: UITapGestureRecognizer2)
    {
        print("Shape \(Recognizer.ForShape) tapped")
        SetShapeButtons2(Recognizer.ForShape)
        Settings.SetEnum(Recognizer.ForShape, EnumType: Shapes.self, ForKey: .CurrentShape)
    }
    
    
    var MainBar: UIScrollView? = nil
    var CurrentMainShape: ShapeCategories = .Shapes
    var CurrentSubShape: Shapes = .Circle
    
    var Buttons: [Shapes: UIButton]? = nil
    
    /// Dictionary of shape categories and associated shapes in each.
    let ShapeStructure: [ShapeCategories: [Shapes]] =
    [
        .Shapes: [.Circle, .Ellipse, .Triangle, .Rectangle, .Hexagon, .Octagon, .Infinity, .Heart, .Bezier],
        .Lines: [.Line, .Spiral, .Scribble],
        .Freeform: [.User]
    ]
    
    /// Contains the names of shape images, whether from SF Symbols or from .SVG images in the project.
    let ShapeImages: [Shapes: String] =
    [
        .Circle: "circle",
        .Ellipse: "oval",
        .Triangle: "triangle",
        .Rectangle: "squareshape",
        .Hexagon: "hexagon",
        .Octagon: "octagon",
        .Infinity: "infinity",
        .Line: "line.diagonal",
        .Spiral: "SpiralIcon",
        .Bezier: "point.topleft.down.curvedto.point.bottomright.up",
        .Scribble: "scribble",
        .Heart: "heart",
        .User: "person.crop.circle"
    ]
    
    /// SVG Shapes that are implemented as .SVG images.
    let SVGShapes: [Shapes] = [.Spiral]
}
