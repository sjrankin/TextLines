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
    public weak var delegate: ShapeBarProtocol? = nil
    {
        didSet
        {
            LateInitialization()
        }
    }
    
    /// Initializer.
    /// - Parameter ShapeCategoryScroller: Shape category bar.
    /// - Parameter ShapeScroller: The shape bar (contents will change depending on
    ///                            the selected category).
    init(ShapeCategoryScroller: UIScrollView,
         ShapeScroller: UIScrollView)
    {
        super.init()
        self.ShapeScroller = ShapeScroller
        self.ShapeCategoryScroller = ShapeCategoryScroller
    }
    
    var ShapeCategoryScroller: UIScrollView = UIScrollView()
    
    /// Called when the main view delegate is set.
    /// - Important: Requires the delegate to the main view to be valid. If not, at the very least,
    ///              a fatal error will result.
    func LateInitialization()
    {
        InitializeCategoryButtons()
        CurrentCategory = Settings.GetEnum(ForKey: .MainShape, EnumType: ShapeCategories.self, Default: .Shapes)
        CurrentShape = Settings.GetEnum(ForKey: .CurrentShape, EnumType: Shapes.self, Default: .Circle)
        SelectShapeCategory(CurrentCategory)
        PopulateShapeScroller(CurrentShape)
    }
    
    /// Initialize the category buttons.
    /// - Note: Creates, sets up and installs all category buttons.
    func InitializeCategoryButtons()
    {
        let ClosedShapes = MakeCategoryButton(For: .Shapes)
        let OpenedShapes = MakeCategoryButton(For: .Lines)
        let UserShapes = MakeCategoryButton(For: .Freeform)
        CategoryButtons.removeAll()
        CategoryButtons.append(ClosedShapes)
        CategoryButtons.append(OpenedShapes)
        CategoryButtons.append(UserShapes)
        
        var CumulativeWidth: CGFloat = 10.0
        for Index in 0 ..< CategoryButtons.count
        {
            let X = 10.0 + (CategoryButtons[Index].frame.width + 10.0) * CGFloat(Index)
            let Y = 2.0
            let Width = CategoryButtons[Index].frame.width
            let Height = CategoryButtons[Index].frame.height
            CategoryButtons[Index].frame = CGRect(x: X, y: Y, width: Width, height: Height)
            ShapeCategoryScroller.addSubview(CategoryButtons[Index])
            CumulativeWidth = CumulativeWidth + Width + 10.0
        }
        
        ShapeCategoryScroller.contentSize = CGSize(width: CumulativeWidth,
                                                   height: ShapeCategoryScroller.contentSize.height)
        ShapeCategoryScroller.layoutIfNeeded()
    }
    
    var CategoryButtons: [UIImageView2] = [UIImageView2]()
    
    /// Handle taps on category buttons.
    /// - Parameter recognizer: The gesture recognizer.
    @objc private func CategoryButtonTapped(_ recognizer: UITapGestureRecognizer)
    {
        guard let Recognizer = recognizer as? UITapGestureRecognizer2 else
        {
            fatalError("CategoryButtonTapped: Error converting tap gesture recognizer.")
        }
        CurrentCategory = Recognizer.ForCategory
        SelectShapeCategory(CurrentCategory)
        PopulateShapeScroller(CurrentShape)
    }
    
    /// Sets the visual state of category buttons. All buttons are set to normal tint except
    /// for the passed button type.
    /// - Note: This function will also highlight the appropriate shape button if it is in
    ///         the passed category.
    /// - Parameter NewCategory: The button to highlight.
    func SelectShapeCategory(_ NewCategory: ShapeCategories)
    {
        for Button in CategoryButtons
        {
            if let TagValue = Button.Tag as? ShapeCategories
            {
                if NewCategory == TagValue
                {
                    Button.tintColor = .systemYellow
                }
                else
                {
                    Button.tintColor = .NavyBlue
                }
            }
        }
    }
    
    /// Populate the shape container with shapes for the shape category in `CurrentMainShape`.
    /// - Parameter Shapes: The currently selected shape. If this shape is in the set of shapes defined
    ///                    by `CurrentMainShape`, it will be highlighted.
    func PopulateShapeScroller(_ Selected: Shapes)
    {
        guard let ShapeScroller = ShapeScroller else
        {
            Debug.FatalError("ShapeScroller is nil")
        }
        for SomeShape in ShapeScroller.subviews
        {
            SomeShape.removeFromSuperview()
        }
        guard let NewButtons = ShapeStructure[CurrentCategory] else
        {
            Debug.FatalError("No shape buttons for \(CurrentCategory)")
        }
        CurrentShapeButtons.removeAll()
        if CurrentCategory == .Freeform
        {
            PopulateFreeformShapes()
            return
        }
        var Index = 0
        let Offset: CGFloat = 10.0
        var CumulativeWidth: CGFloat = 0.0
        for NewButton in NewButtons
        {
            let ButtonView = MakeShapeButton(For: NewButton)
            if NewButton == Selected
            {
                ButtonView.tintColor = UIColor.systemYellow
            }
            ButtonView.frame = CGRect(x: Offset + CGFloat(Index * 45),
                                      y: 2,
                                      width: 45.0,
                                      height: 45.0)
            ShapeScroller.addSubview(ButtonView)
            Index = Index + 1
            CurrentShapeButtons.append(ButtonView)
            CumulativeWidth = CumulativeWidth + ButtonView.frame.width + 10.0
        }
        
        ShapeScroller.contentSize = CGSize(width: CumulativeWidth,
                                           height: ShapeScroller.contentSize.height)
        ShapeScroller.layoutIfNeeded()
    }
    
    func PopulateFreeformShapes()
    {
        guard let ShapeScroller = ShapeScroller else
        {
            Debug.FatalError("ShapeScroller is nil")
        }
        UserShapeManager.LoadUserShapes()
        UserShapeList = UserShapeManager.UserShapeList
        var Index = 0
        let Offset: CGFloat = 5.0
        var CumulativeWidth: CGFloat = 0.0
        let SelectedID = Settings.GetUUID(.CurrentUserShape)
        for SomeShape in UserShapeList
        {
            let ShapeID = SomeShape.ID
            if let ActualShape = GetUserShape(From: ShapeID)
            {
                #if true
                let BGColor = UIColor(HexString: "#2d2d2d")!
                let UserCreatedImage = GenerateThumbnail(From: ActualShape,
                                                         Background: BGColor,
                                                         IsSelected: ShapeID == SelectedID)
                #else
                let (Normal, Highlight) = UserShapeImageCache.GetCachedImageSet(ID: ShapeID)!
                #endif
                let ButtonSize = CGSize(width: 45.0, height: 45.0)
                let ButtonOrigin = CGPoint(x: 5.0 + (CGFloat(Index) * (45.0 + Offset)),
                                           y: 2)
                let UserButton = UIView(frame: CGRect(origin: ButtonOrigin, size: ButtonSize))
                let UserButtonImage = UIImageView2(frame: CGRect(origin: .zero, size: ButtonSize))
                UserButtonImage.Tag = ShapeID
                #if true
                UserButtonImage.image = UserCreatedImage
                #else
                UserButtonImage.image = Normal
                #endif
                UserButton.addSubview(UserButtonImage)
                UserButton.layer.cornerRadius = 4.0
                let BorderColor = ShapeID == SelectedID ? UIColor.systemOrange.cgColor : UIColor.black.cgColor
                UserButton.layer.borderColor = BorderColor
                UserButton.layer.borderWidth = 0.4
                UserButton.clipsToBounds = true
                                        
                ShapeScroller.addSubview(UserButton)
                
                let Recognizer = UITapGestureRecognizer2(target: self,
                                                         action: #selector(UserShapeButtonTapped))
                Recognizer.ForUserShape = ShapeID
                UserButton.addGestureRecognizer(Recognizer)
                
                CumulativeWidth = CumulativeWidth + UserButton.frame.width + 10.0
                Index = Index + 1
            }
        }
    }
    
    @objc func UserShapeButtonTapped(_ Recognizer: UITapGestureRecognizer2)
    {
        let NewID = Recognizer.ForUserShape
        Settings.SetUUID(.CurrentUserShape, NewID)
        ThumbnailCache.removeAll()
        PopulateFreeformShapes()
    }
    
    func GetUserShape(From ID: UUID) -> UserDefinedShape?
    {
        for SomeShape in UserShapeList
        {
            if SomeShape.ID == ID
            {
                return SomeShape
            }
        }
        return nil
    }
    
    /// Return a thumbnail of the shape with the specified shape.
    /// - Parameter From: The shape to use to generate a thumbnail.
    /// - Parameter Background: The background color.
    /// - Parameter IsSelected: If true, the image is for a selected shape. If false, for a
    ///                         non-selected shape.
    /// - Returns: Thumbnail image of the shape.
    @discardableResult func GenerateThumbnail(From Shape: UserDefinedShape,
                                              Background Color: UIColor,
                                              IsSelected: Bool) -> UIImage
    {
        var Thumbnail: UIImage = UIImage()
        if let Cached = GetCachedImage(ID: Shape.ID)
        {
            Thumbnail = Cached
        }
        else
        {
            let (UL, LR) = Utility.GetExtent(Points: Shape.Points)!
            let ShapeWidth = (LR.x - UL.x) + 40
            let ShapeHeight = (LR.y - UL.y) + 40
            let XOffset: CGFloat = 20
            let YOffset: CGFloat = 20
            var OffsetPoints = [CGPoint]()
            for Point in Shape.Points
            {
                let NewPoint = CGPoint(x: Point.x - UL.x + XOffset,
                                       y: Point.y - UL.y + YOffset)
                OffsetPoints.append(NewPoint)
            }
            let ImageView = UserShape(frame: CGRect(origin: .zero,
                                                    size: CGSize(width: ShapeWidth, height: ShapeHeight)))
            ImageView.Initialize(ReadOnly: true)
            ImageView.ShowPoints = false
            ImageView.OriginalPoints = OffsetPoints
            ImageView.SetSmoothing(On: Shape.SmoothLines)
            ImageView.ClosePath = Shape.ClosedLoop
            ImageView.backgroundColor = Color
            ImageView.Redraw()
            let Highlight = IsSelected ? UIColor.systemYellow : UIColor.systemBlue
            Thumbnail = ImageView.RenderToImage(Highlight)
            AddToImageCache(ID: Shape.ID, Image: Thumbnail)
        }
        return Thumbnail
    }
    
    func GetCachedImage(ID: UUID) -> UIImage?
    {
        return ThumbnailCache[ID]
    }
    
    func AddToImageCache(ID: UUID, Image: UIImage)
    {
        if ThumbnailCache.keys.contains(ID)
        {
            return
        }
        ThumbnailCache[ID] = Image
    }
    
    func UpdateImageCache(ID: UUID, Image: UIImage)
    {
        if ThumbnailCache.keys.contains(ID)
        {
            ThumbnailCache[ID] = Image
            return
        }
        Debug.Print("Should not get here - trying to add thumbnail to non-existant cached ID.")
    }
    
    func RemoveImageFromCache(ID: UUID)
    {
        if ThumbnailCache.keys.contains(ID)
        {
            ThumbnailCache.removeValue(forKey: ID)
        }
    }
    
    var ThumbnailCache = [UUID: UIImage]()
    var UserShapeList = [UserDefinedShape]()
    
    var CurrentShapeButtons = [UIImageView2]()
    
    /// Creates a button for the passed shape. The button (which is really a derivative of
    /// `UIImageView2`) will be placed (presumably) by the caller into a control that allows
    /// the user to select it.
    /// - Warning: Throws fatal errors **1**) when the button image name is not found, and
    ///            **2**) when the image cannot be created.
    /// - Parameter For: The shape whose representative button will be returned.
    /// - Returns: `UIImageView2` control that acts as a button. The image will be representative
    ///            of the shape.
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
    
    /// Creates buttons for the user to select shape categories.
    /// - Warning: Throws fatal errors when **1**) the image name cannot be determined, and
    ///            **2**) when the image cannot be created.
    /// - Parameter For: The category whose button will be created.
    /// - Returns: `UIImageView2` that represents (and acts like) a button for the user
    ///            to tap to select a new shape.
    func MakeCategoryButton(For Category: ShapeCategories) -> UIImageView2
    {
        let IView = UIImageView2(frame: CGRect(origin: .zero, size: CGSize(width: 42, height: 42)))
        IView.isUserInteractionEnabled = true
        IView.contentMode = .scaleAspectFit
        var Image: UIImage? = nil
        guard let ImageName = CategoryImages[Category] else
        {
            Debug.FatalError("Error getting image name for \(Category)")
        }
        Image = UIImage(systemName: ImageName)
        
        guard let FinalImage = Image else
        {
            Debug.FatalError("Error creating button image")
        }
        IView.image = FinalImage
        let Recognizer = UITapGestureRecognizer2(target: self,
                                                 action: #selector(CategoryButtonTapped))
        Recognizer.ForCategory = Category
        IView.addGestureRecognizer(Recognizer)
        IView.Tag = Category
        
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
    
    /// Called when the user taps a shape button. Highlights the tapped button and
    /// saves the new shape in user settings.
    /// - Parameter Recognizer: `UITapGestureRecognizer2` class.
    @objc func ShapeButtonTapped2(_ Recognizer: UITapGestureRecognizer2)
    {
        SetShapeButtons2(Recognizer.ForShape)
        Settings.SetEnum(Recognizer.ForShape, EnumType: Shapes.self, ForKey: .CurrentShape)
    }
    
    var ShapeScroller: UIScrollView? = nil
    var CurrentCategory: ShapeCategories = .Shapes
    var CurrentShape: Shapes = .Circle
    
    var Buttons: [Shapes: UIButton]? = nil
    
    /// Dictionary of shape categories and associated shapes in each.
    let ShapeStructure: [ShapeCategories: [Shapes]] =
    [
        .Shapes: [.Circle, .Ellipse, .Triangle, .Rectangle, .Hexagon, .Octagon, .NGon, .Infinity, .Heart, .Star],
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
        .Scribble: "scribble",
        .Heart: "heart",
        .Star: "star",
        .User: "person.crop.circle",
        .NGon: "NGonIcon",
    ]
    
    /// Dictionary of shape categories to shape category image names.
    let CategoryImages: [ShapeCategories: String] =
    [
        ShapeCategories.Shapes: "circle",
        ShapeCategories.Lines: "line.diagonal",
        ShapeCategories.Freeform: "person.crop.circle"
    ]
    
    /// SVG Shapes that are implemented as .SVG images.
    let SVGShapes: [Shapes] = [.Spiral, .NGon]
}
