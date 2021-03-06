//
//  ViewController.swift
//  TextLine
//
//  Created by Stuart Rankin on 8/10/21.
//

import Foundation
import UIKit

class ViewController: UIViewController, UITextViewDelegate, ShapeBarProtocol,
                      SettingsWrapperDelegate
{
    /// Initialize the user interface and program.
    override func viewDidLoad()
    {
        super.viewDidLoad()
        Debug.DumpVersion()
        /*
         for family: String in UIFont.familyNames
         {
         print(family)
         for names: String in UIFont.fontNames(forFamilyName: family)
         {
         print("== \(names)")
         }
         }
         */
        Settings.Initialize()
        Settings.AddSubscriber(self)
        Settings.SetBool(.Animating, false)
        
        CommandButtonList = Settings.GetStrings(.CommandButtonList,
                                                Delimiter: ",",
                                                Default: [CommandButtons.ActionButton.rawValue,
                                                          CommandButtons.ShapeOptionsButton.rawValue])
        print("CommandButtonList=\(CommandButtonList)")
        CmdController = CommandBarManager(CommandBar: CommandScroller,
                                          Buttons: CommandButtonList)
        CmdController?.delegate = self
        BarController = ButtonBars(ShapeCategoryScroller: ShapeCategoryScroller,
                                   ShapeScroller: ShapeScroller)
        BarController?.delegate = self
        InitializeSVGImages()
        InitializeToolBar()
        DeviceType = UIDevice.current.userInterfaceIdiom
        
#if !DEBUG
        SettingCommands = SettingCommands.dropLast()
#endif
        SettingPanelGearButton.setTitle("", for: .normal)
        SettingPanel.alpha = 0.0
        SettingPanel.layer.zPosition = UIConstants.HiddenZ
        SettingPanel.resignFirstResponder()
        SettingPanel.layer.maskedCorners = [CACornerMask.layerMaxXMaxYCorner,
                                            CACornerMask.layerMinXMaxYCorner]
        SettingPanel.layer.cornerRadius = UIConstants.CornerRadius
        SettingPanelCommandTable.layer.borderColor = UIConstants.BorderColor
        SettingPanelCommandTable.layer.borderWidth = UIConstants.BorderThickness
        SettingPanelCommandTable.layer.cornerRadius = UIConstants.CornerRadius
        
        SettingOptionTable.layer.borderColor = UIConstants.BorderColor
        SettingOptionTable.layer.borderWidth = UIConstants.BorderThickness
        SettingOptionTable.layer.cornerRadius = UIConstants.CornerRadius
        
        SettingSlicePanel.alpha = 0.0
        SettingSlicePanel.layer.zPosition = UIConstants.HiddenSliceZ
        SettingSlicePanel.resignFirstResponder()
        SettingSlicePanel.layer.maskedCorners = [CACornerMask.layerMaxXMaxYCorner,
                                            CACornerMask.layerMinXMaxYCorner]
        SettingSlicePanel.layer.cornerRadius = UIConstants.CornerRadius
       
        let OptionDrag = UIPanGestureRecognizer(target: self,
                                                action: #selector(HandleSliceDragging))
        SliceStretchBar.addGestureRecognizer(OptionDrag)
        let ResetDragBar = UITapGestureRecognizer(target: self,
                                                  action: #selector(HandleResetSlicePanel))
        ResetDragBar.numberOfTapsRequired = 2
        SliceStretchBar.addGestureRecognizer(ResetDragBar)
        
        StartText = "\(Versioning.ApplicationName) Version \(Versioning.VerySimpleVersionString()), Build \(Versioning.Build)"
        CurrentText = StartText
        UpdateOutput()
        TextInput.text = StartText
        UserShapeManager.LoadUserShapes()
        
        ShortMessageLabel.layer.borderColor = UIConstants.BorderColor
        ShortMessageLabel.layer.borderWidth = UIConstants.BorderThickness
        ShortMessageLabel.layer.cornerRadius = UIConstants.CornerRadius
        ShortMessageLabel.isHidden = true
        ShortMessageLabel.alpha = 0.0
        ShortMessageLabel.layer.zPosition = UIConstants.HiddenZ
        ShortMessageLabel.isUserInteractionEnabled = true
        HideTap = UITapGestureRecognizer(target: self,
                                         action: #selector(CloseMessage))
        ShortMessageLabel.addGestureRecognizer(HideTap!)
        
        GenerateUserThumbnails()
        
        //let SurfacePanGesture = UIPanGestureRecognizer(target: self, action: #selector(PanGestureHandler))
        //TextOutput.addGestureRecognizer(SurfacePanGesture)
        
        TextDoneButton.isEnabled = false
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(TextInputNotifications(_:)),
                                               name: UITextView.textDidBeginEditingNotification,
                                               object: TextInput)
        
        //print("Screen.size=(\(UIScreen.main.bounds.width),\(UIScreen.main.bounds.height))")
    
        HideKeyboardTapA = UITapGestureRecognizer(target: self,
                                                 action: #selector(HideKeyboardTapEvent))
        HideKeyboardTapB = UITapGestureRecognizer(target: self,
                                                  action: #selector(HideKeyboardTapEvent))
    }
    
    /// Handle the hide keyboard tap event. When the user starts to enter text, a different
    /// function adds a tap gesture recognizer to the UI and this function is called when
    /// a tap occurs.
    /// - Parameter Recognizer: The tap recognizer. Not used.
    @objc func HideKeyboardTapEvent(_ Recognizer: UITapGestureRecognizer)
    {
        TextInput.resignFirstResponder()
        TextOutput.removeGestureRecognizer(HideKeyboardTapA!)
        TextDoneButton.isEnabled = false
        CommandScroller.isScrollEnabled = true
        CmdController?.VisualOverlay?.removeGestureRecognizer(HideKeyboardTapB!)
        CmdController?.ShowOverlay(false)
    }
    
    var HideKeyboardTapA: UITapGestureRecognizer? = nil
    var HideKeyboardTapB: UITapGestureRecognizer? = nil
    
    /// User started to enter/edit text. Enable the text done button.
    /// - Parameter Notice: Not used.
    @objc func TextInputNotifications(_ Notice: Notification)
    {
        TextDoneButton.isEnabled = true
        TextOutput.addGestureRecognizer(HideKeyboardTapA!)
        CommandScroller.isScrollEnabled = false
        CmdController?.ShowOverlay(true)
        CmdController?.VisualOverlay?.addGestureRecognizer(HideKeyboardTapB!)
    }
    
    /// Used finished editing text. disable the text done button and resign first responder for the
    /// text field to force the keyboard to disappear and the get the final text.
    /// - Parameter sender: Not used.
    @IBAction func TextDoneButtonHandler(_ sender: Any)
    {
        TextDoneButton.isEnabled = false
        self.TextInput.resignFirstResponder()
        TextOutput.removeGestureRecognizer(HideKeyboardTapA!)
        CommandScroller.isScrollEnabled = true
        CmdController?.VisualOverlay?.removeGestureRecognizer(HideKeyboardTapB!)
        CmdController?.ShowOverlay(false)
    }
    
    var HideTap: UITapGestureRecognizer? = nil
    
    /// Respond to the user tapping the short message by closing the message immediately.
    /// - Parameter Recognizer: Not used.
    @objc func CloseMessage(_ Recognizer: UITapGestureRecognizer)
    {
        ShortMessageLabel.layer.removeAllAnimations()
        ShortMessageLabel.layer.zPosition = UIConstants.HiddenZ
        ShortMessageLabel.alpha = 0.0
        ShortMessageLabel.isHidden = true
        ShortMessageLabel.resignFirstResponder()
    }
    
    var CommandButtonList = [String]()
    var UpdateTextOffset: Bool? = nil
    var NewTextOffset: CGFloat = 0.0
    
    @objc func PanGestureHandler(_ Recognizer: UIPanGestureRecognizer)
    {
        if Settings.GetBool(.Animating)
        {
            Recognizer.isEnabled = false
            Recognizer.isEnabled = true
            return
        }
        let Location = Recognizer.location(in: TextOutput)
        let SurfaceWidth = TextOutput.frame.width
        let SurfaceHeight = TextOutput.frame.height
        switch Recognizer.state
        {
            case .began:
                PreviousPanningX = Location.x
                PreviousPanningY = Location.y
                PanningOffset = 0.0
                UpdateTextOffset = true
                
            case .changed:
                let HAcc = PreviousPanningX > Location.x ? -1.0 : 1.0
                //let VAcc = PreviousPanningY > Location.y ? -1.0 : 1.0
                PreviousPanningX = Location.x
                PreviousPanningY = Location.y
                let PercentX = Location.x / SurfaceWidth
                let PercentY = Location.y / SurfaceHeight
                print("PercentXY=(\(PercentX),\(PercentY))")
                PanningOffset! = PanningOffset! + (HAcc * 1.0)
                print("PanningOffset=\(PanningOffset!) [\(HAcc)]")
                if PanningOffset! < 0
                {
                    PanningOffset! = PathLength
                }
                if PanningOffset! > PathLength
                {
                    PanningOffset! = 0
                }
                NewTextOffset = PanningOffset!
                UpdateShape()
                
            case .ended:
                PanningOffset = nil
                PreviousPanningX = 0
                PreviousPanningY = 0
                UpdateTextOffset = nil
                
            default:
                break
        }
    }
    
    var PreviousPanningX: CGFloat = 0
    var PreviousPanningY: CGFloat = 0
    var PanningOffset: CGFloat? = nil
    
    /// Reset the size of the slice panel.
    /// - Note: See [Constraint animation](https://stackoverflow.com/questions/25649926/trying-to-animate-a-constraint-in-swift)
    /// - Parameter Recognizer: Not used.
    @objc func HandleResetSlicePanel(_ Recognizer: UITapGestureRecognizer)
    {
        guard let BaseHeight = CurrentSliceHeight else
        {
            return
        }
        self.SliceControllerHeight.constant = BaseHeight
        UIView.animate(withDuration: UIConstants.SlicePanelResetDuration,
                       delay: UIConstants.NoDelay,
                       options: [.curveEaseInOut])
        {
            self.view.layoutIfNeeded()
        }
    }
    
    var SettingSliceHeight: CGFloat? = nil
    
    /// Handle slice container dragging by the user.
    /// - Parameter Recognizer: Used to determine where the user is dragging the slice.
    @objc func HandleSliceDragging(_ Recognizer: UIPanGestureRecognizer)
    {
        let DraggedTo = Recognizer.translation(in: self.view)
        switch Recognizer.state
        {
            case .began:
                if SettingSliceHeight == nil
                {
                    SettingSliceHeight = SettingSlicePanel.frame.size.height
                }
                
            case .changed:
                let Delta = SettingSliceHeight! + DraggedTo.y
                if Delta < UIConstants.MinimumSliceHeight
                {
                    return
                }
                if Delta > UIScreen.main.bounds.height + UIConstants.MaximumSliceHeightOffset
                {
                    return
                }
                SliceControllerHeight.constant = Delta
                
            case .ended:
                SettingSliceHeight = nil
                
            default:
                break
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.willTransition(to: newCollection, with: coordinator)
        coordinator.animate(alongsideTransition:
                                {
            (context) in
            guard let WindowInterfaceOrientation = self.WindowInterfaceOrientation else
            {
                return
            }
            if WindowInterfaceOrientation.isLandscape
            {
                print("In landscape orientation")
            }
            else
            {
                print("In portrait orientation")
            }
        }
        )
    }
    
    /// Generate and cache user shape thumbnails.
    func GenerateUserThumbnails()
    {
        UserShapeManager.LoadUserShapes()
        let UserShapeList = UserShapeManager.UserShapeList
        for Shape in UserShapeList
        {
            let ShapeID = Shape.ID
            let NormalColor = CreateShapeThumbnail(Shape: Shape, Color: .Gray(Percent: 0.85))
            let Highlighted = CreateShapeThumbnail(Shape: Shape, Color: .systemYellow)
            UserShapeImageCache.SaveInCache(ID: ShapeID, Normal: NormalColor, Highlighted: Highlighted)
        }
    }
    
    /// Create a thumbnail image of the specified user-defined shape.
    /// - Parameter Shape: The user-defined shape to use to create the image.
    /// - Parameter Color: The background color of the shape.
    /// - Returns: A `UIImage` thumnail of the user-defined shape.
    func CreateShapeThumbnail(Shape: UserDefinedShape, Color: UIColor) -> UIImage
    {
        var Thumbnail: UIImage = UIImage()
        let (UL, LR) = Utility.GetExtent(Points: Shape.Points)!
        let ShapeWidth = (LR.x - UL.x) + UIConstants.UserShapeThumbnailWidth
        let ShapeHeight = (LR.y - UL.y) + UIConstants.UserShapeThumbnailHeight
        let XOffset: CGFloat = UIConstants.UserShapeHorizontalOffset
        let YOffset: CGFloat = UIConstants.UserShapeVerticalOffset
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
        Thumbnail = ImageView.RenderToImage()
        return Thumbnail
    }
    
    private var WindowInterfaceOrientation: UIInterfaceOrientation?
    {
        if #available(iOS 15, *)
        {
            let Scenes = UIApplication.shared.connectedScenes
            let WindowScene = Scenes.first as? UIWindowScene
            let Orientation = WindowScene?.interfaceOrientation
            return Orientation
        }
        else
        {
            return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        }
    }
    
    /// Initialize any SVG images used in places of `UIImage(systemImage)`s. Essentially this
    /// is nothing more than setting the render mode and initial tint color.
    /// - Note:
    ///    - .SVG images used for shapes are initialized in `ButtonBars`.
    ///    - [Change color of SVG images](https://stackoverflow.com/questions/38395003/how-to-change-color-of-svg-images-in-ios)
    func InitializeSVGImages()
    {
        /*
         let NewName = Settings.GetString(.ActionIconName, "CogIcon")
         ActionImage = UIImageView()
         ActionImage.image = UIImage(named: NewName)
         ActionImage.image = ActionImage.image?.withRenderingMode(.alwaysTemplate)
         ActionImage.tintColor = UIColor.systemBlue
         //ShapesImage.image = ShapesImage.image?.withRenderingMode(.alwaysTemplate)
         //ShapesImage.tintColor = UIColor.systemBlue
         */
    }
    
    var StartText = ""
    var BarController: ButtonBars? = nil
    var CmdController: CommandBarManager? = nil
    var OriginalOptionsHeight: CGFloat = 0.0
    var CurrentShape: Shapes? = nil
    var DeviceType: UIUserInterfaceIdiom = .mac
    
    /// Return an array of shape categories to display.
    /// - Returns: Array of `ShapeCategories` to display in the shape category control.
    func GetCategories() -> [ShapeCategories]
    {
        return [ShapeCategories.Shapes, ShapeCategories.Lines, ShapeCategories.Freeform]
    }
    
    /// Initialize the tool bar. Debug components removed if `#!DEBUG`.
    func InitializeToolBar()
    {
#if DEBUG
#else
        DebugButtonContainer.removeFromSuperview()
#endif
    }
    
    var TextAnimationTimer: Timer? = nil
    
    /// Sets the current animation state.
    func SetAnimationState()
    {
        let Current = Settings.GetBool(.Animating)
        Settings.SetBool(.Animating, !Current)
    }
    
    /// Enables animation of text based on the previously set animation state.
    func SetAnimation()
    {
        let CurrentlyAnimating = Settings.GetBool(.Animating)
        if CurrentlyAnimating
        {
            UpdateTextOffset = true
        }
        else
        {
            UpdateTextOffset = nil
        }
        if CurrentlyAnimating
        {
            TextAnimationTimer = Timer.scheduledTimer(timeInterval: UIConstants.TextAnimationInterval,
                                                      target: self,
                                                      selector: #selector(HandleAnimation),
                                                      userInfo: nil,
                                                      repeats: true)
        }
        else
        {
            TextAnimationTimer?.invalidate()
        }
    }
    
    var AnimationOffset: CGFloat = UIConstants.InitialAnimationOffset
    
    /// Handle the debug button action.
    /// - Notes: Code not included in non-`#DEBUG` schemes.
    @IBAction func DebugButtonHandler(_ sender: Any)
    {
#if DEBUG
        let Storyboard = UIStoryboard(name: "DebugUI2", bundle: nil)
        let nextViewController = Storyboard.instantiateViewController(withIdentifier: "DebugUI2") as! DebugUI2Root
        self.present(nextViewController, animated: true, completion: nil)
#endif
    }
    
    func UpdateShape()
    {
        if let ShapeToUse = Settings.GetEnum(ForKey: .CurrentShape, EnumType: Shapes.self)
        {
            SetShape(ShapeToUse)
        }
    }
    
    /// Update the current Bezier shape to the passed value. Updates the output image.
    /// - Note: As an efficiency, the caller should check if the old shape is the same
    ///         as the new shape and *not* call this function if the shapes are the
    ///         same and there are no other changes.
    /// - Parameter NewShape: The new shape for the output.
    func SetShape(_ NewShape: Shapes)
    {
        if let Path = MakePath(For: NewShape)
        {
            var Offset = CGFloat(Settings.GetInt(.TextOffset))
#if false
            if let _ = UpdateTextOffset
            {
                //If UpdateTextOffset is non-nil, it's always true.
                Offset = NewTextOffset
            }
#else
            if Settings.GetBool(.Animating)
            {
                Offset = AnimationOffset
            }
#endif
//            print("Offset=\(Offset)")
            if let NewImage = PlotText(CurrentText, On: Path,
                                       With: CGFloat(Offset))
            {
                TextOutput.image = NewImage
            }
            else
            {
                print("No image to display.")
            }
        }
    }
    
    /// Called by the OS when the text in the text entry control changes. Immediately
    /// updates the output.
    func textViewDidChange(_ textView: UITextView)
    {
        CurrentText = textView.text
        UpdateOutput()
    }
    
    /// Called by the OS when the user ends editing (by pressing the Return key). Immediately
    /// updates the output. Also, closes the keyboard.
    func textViewDidEndEditing(_ textView: UITextView)
    {
        self.view.endEditing(true)
        CurrentText = textView.text
        UpdateOutput()
    }

    /// Return a reference to the scroll view in which the shapes container lives.
    func GetShapeScroller() -> UIScrollView
    {
        return ShapeScroller
    }
    
    var SharedImage: UIImage? = nil
    
    /// Name of the storyboard where the sliced setting exists.
    var WrappedStoryboard: String? = nil
    /// Name of the controller for the sliced setting.
    var WrappedController: String? = nil
    
    /// Called by the sliced settings navigation controller to know where to find
    /// the controller to display.
    /// - Return: Tuple with the storyboard name and controller name. Nil if values
    ///           are not available.
    func GetTarget() -> (StoryboardName: String, ControllerName: String)?
    {
        guard let StoryboardName = WrappedStoryboard else
        {
            return nil
        }
        guard let ControllerName = WrappedController else
        {
            return nil
        }
        
       return (StoryboardName, ControllerName)
    }
    
    /// Run a sliced settings controller.
    /// - Note: Sliced settings are usually (but not always) a controller off of the
    ///         main settings view controller. It is "sliced" and shown in isolation
    ///         when called from here.
    /// - Note: Controllers run when sliced do not have their parent controllers so if
    ///         data from a parent controller is needed, it cannot be provided.
    /// - Parameter StoryboardName: The name of the storyboard file.
    /// - Parameter ControllerName: The name of the controller for the storyboard.
    func RunSlicedSettings(StoryboardName: String, ControllerName: String)
    {
        WrappedStoryboard = StoryboardName
        WrappedController = ControllerName
        let Storyboard = UIStoryboard(name: "SettingsUI", bundle: nil)
        let VC = Storyboard.instantiateViewController(withIdentifier: "SettingsWrapper") as! SettingsWrapperController
        VC.WrapperDelegate = self
        self.present(VC, animated: true)
        {
            self.WrappedController = nil
            self.WrappedStoryboard = nil
        }
    }
    
    /// Update the output - something changed somewhere that requires the output
    /// to change.
    /// - Notes: User changes are all stored in settings or the user interface. Rather
    ///          than send many parameters, those mechanisms are used instead.
    func UpdateOutput()
    {
        if let ShapeToUse = Settings.GetEnum(ForKey: .CurrentShape, EnumType: Shapes.self)
        {
            SetShape(ShapeToUse)
        }
        else
        {
            Debug.Print("No ShapeToUse")
        }
    }
    
    @IBAction func RunViewportSizeSliceHandler(_ sender: Any)
    {
    }
    
    // MARK: - Setting panel variables.
    
    var SettingCommands =
    [
        "Save/Share",
        "Shape",
        "Rotation",
        "Alignment",
        "Animation",
        "Velocity",
        "Reset",
        "About",
        "Debug"
    ]
    
    var SliceViewController: UIViewController? = nil
    
    var CurrentSliceHeight: CGFloat? = nil
    
    /// Heights of different slice views. If not here, a default value is used in `HeightFor`.
    let SliceHeights: [SliceTypes: CGFloat] =
    [
        .TextFormatting: 184.0,
        .RectangleSettings: 265.0,
        .TriangleSettings: 265.0,
        .DebugSlice: 300.0,
        .SpiralLineSettings: 374.0,
        .CircleSettings: 170.0,
        .EllipseSettings: 218.0,
        .LineSettings: 275.0,
        .HexagonSettings: 220.0,
        .OctagonSettings: 220.0,
        .NoShapeOptions: 240.0,
        .ViewportSize: 300.0,
        .AnimationSettings: 240.0,
        .GuidelineSettings: 240.0,
        .BackgroundSettings: 240.0,
        .FontSlice: 358.0,
        .NGonSlice: 459.0,
        .StarSlice: 464.0,
        .CommonSettings: 240.0,
    ]
    
    let ShapeToSlice: [Shapes: SliceTypes] =
    [
        .Circle: .CircleSettings,
        .Ellipse: .EllipseSettings,
        .Rectangle: .RectangleSettings,
        .Triangle: .TriangleSettings,
        .Octagon: .OctagonSettings,
        .Hexagon: .HexagonSettings,
        .Line: .LineSettings,
        .Spiral: .SpiralLineSettings
    ]
    
    var SettingCellHeight: CGFloat = 40
    var OptionGroup: Int = 0
    var SettingTableItemCount: Int = 0
    var CommandSelected: Int? = nil
    
    public static var InstalledFonts = [FontInfo]()
    var PathLength: CGFloat = 0.0
    var HAdder: CGFloat = 0
    var VAdder: CGFloat = 0
    var CharLocations = [CGPoint]()
    
    var PreviousShape: Shapes? = nil
    var CurrentText: String = ""
    /// ID used for settings subscriptions.
    var ClassID = UUID()
    
    var PreviousController: UIViewController? = nil
    
    // MARK: - Interface Builder outlets.
    
    @IBOutlet weak var TextOutput: UIImageView!
    @IBOutlet weak var TextInput: UITextView!
    @IBOutlet weak var ShapeCategoryScroller: UIScrollView!
    @IBOutlet weak var ShapeScroller: UIScrollView!
    @IBOutlet weak var CommandScroller: UIScrollView!
    
    @IBOutlet weak var SettingPanelCommandTable: UITableView!
    @IBOutlet weak var SettingOptionTable: UITableView!
    @IBOutlet weak var SettingPanelGearButton: UIButton!
    @IBOutlet weak var SettingPanel: UIView!
    @IBOutlet weak var SettingsPanelDragBar: UIView!
    @IBOutlet weak var SettingsHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var SettingSlicePanel: UIView!
    @IBOutlet weak var SliceContainer: UIView!
    @IBOutlet weak var SliceStretchBar: UIImageView!
    @IBOutlet weak var SliceControllerHeight: NSLayoutConstraint!
    @IBOutlet weak var RunViewportSizeButton: UIButton!
    
    @IBOutlet weak var TextStack: UIStackView!
    @IBOutlet weak var ShortMessageLabel: UILabel!

    @IBOutlet weak var TextDoneButton: UIButton!
}
