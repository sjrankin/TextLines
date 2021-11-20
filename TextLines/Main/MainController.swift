//
//  ViewController.swift
//  TextLine
//
//  Created by Stuart Rankin on 8/10/21.
//

import Foundation
import UIKit

class ViewController: UIViewController, UITextViewDelegate, ShapeBarProtocol,
                      CommandBarProtocol, SettingsWrapperDelegate
{
    /// Initialize the user interface and program.
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
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
                                                action: #selector(HandleSettingDragging))
        SettingsPanelDragBar.addGestureRecognizer(OptionDrag)
        SettingsPanelDragBar.layer.cornerRadius = UIConstants.DragCornerRadius
        let ResetDragBar = UITapGestureRecognizer(target: self,
                                                  action: #selector(HandleResetSettingsPanel))
        ResetDragBar.numberOfTapsRequired = 2
        SettingsPanelDragBar.addGestureRecognizer(ResetDragBar)
        
//        InitializeKeyboard()
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
        
        print("Screen.size=(\(UIScreen.main.bounds.width),\(UIScreen.main.bounds.height))")
    }
    
    @objc func TextInputNotifications(_ Notice: Notification)
    {
        print("Started editing text")
        TextDoneButton.isEnabled = true
    }
    
    @IBAction func TextDoneButtonHandler(_ sender: Any)
    {
        print("At text done button handler")
        TextDoneButton.isEnabled = false
        self.TextInput.resignFirstResponder()
    }
    
    var HideTap: UITapGestureRecognizer? = nil
    
    @objc func CloseMessage(_ Recognizer: UITapGestureRecognizer)
    {
        print("Short message tapped")
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
                let VAcc = PreviousPanningY > Location.y ? -1.0 : 1.0
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
    
    //https://stackoverflow.com/questions/25649926/trying-to-animate-a-constraint-in-swift
    @objc func HandleResetSettingsPanel(_ Recognizer: UITapGestureRecognizer)
    {
        self.SettingsHeightConstraint.constant = 240
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: [.curveEaseInOut])
        {
            self.view.layoutIfNeeded()
        }
    }
    
    var StartingSettingsHeight: CGFloat? = nil
    
    @objc func HandleSettingDragging(_ Recognizer: UIPanGestureRecognizer)
    {
        let DraggedTo = Recognizer.translation(in: self.view)
        switch Recognizer.state
        {
            case .began:
                if StartingSettingsHeight == nil
                {
                    StartingSettingsHeight = SettingPanel.frame.size.height
                }
                
            case .changed:
                let Delta = StartingSettingsHeight! + DraggedTo.y
                if Delta < 120
                {
                    return
                }
                if Delta > UIScreen.main.bounds.height - 30
                {
                    return
                }
                SettingsHeightConstraint.constant = Delta
                
            case .ended:
                StartingSettingsHeight = nil
                
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
            print("Shape.Name=\(Shape.Name)")
            let ShapeID = Shape.ID
            let NormalColor = CreateShapeThumbnail(Shape: Shape, Color: .Gray(Percent: 0.85))
            let Highlighted = CreateShapeThumbnail(Shape: Shape, Color: .systemYellow)
            UserShapeImageCache.SaveInCache(ID: ShapeID, Normal: NormalColor, Highlighted: Highlighted)
        }
        print("UserShapeImageCache.count=\(UserShapeImageCache.LocalCache.count)")
    }
    
    func CreateShapeThumbnail(Shape: UserDefinedShape, Color: UIColor) -> UIImage
    {
        var Thumbnail: UIImage = UIImage()
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
    
    /// Initialize the keyboard with a `Done` button in a toolbar. This provides an alternative
    /// way for the user to indicate no more editing.
    func InitializeKeyboard()
    {
        let KBToolbar = UIToolbar()
        let FlexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil, action: nil)
        let DoneButton = UIBarButtonItem(title: "Dismiss", style: .done,
                                         target: self, action: #selector(KeyboardDoneButtonTapped))
        
        KBToolbar.setItems([FlexSpace, DoneButton], animated: true)
        KBToolbar.sizeToFit()
        TextInput.inputAccessoryView = KBToolbar
    }
    
    /// Called by the `Done` button the program inserted into the keyboard's toolbar when the
    /// user has completed text entry.
    @objc func KeyboardDoneButtonTapped()
    {
        self.view.endEditing(true)
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
    
    var CurrentlyAnimating: Bool = false
    var TextAnimationTimer: Timer!
    
    /// Sets the current animation state.
    func SetAnimationState()
    {
        CurrentlyAnimating = !CurrentlyAnimating
        Settings.SetBool(.Animating, CurrentlyAnimating)
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
            TextAnimationTimer = Timer.scheduledTimer(timeInterval: 0.005,
                                                      target: self,
                                                      selector: #selector(HandleAnimation),
                                                      userInfo: nil,
                                                      repeats: true)
        }
        else
        {
            TextAnimationTimer.invalidate()
        }
    }
    
    var AnimationOffset: CGFloat = 0.0
    
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
            print("Offset=\(Offset)")
            /*
             //Create the image on a background thread to keep the UI responsive.
             DispatchQueue.global(qos: .userInitiated).async
             {
             if let NewImage = self.PlotText(self.CurrentText, On: Path, With: CGFloat(Offset))
             {
             DispatchQueue.main.async
             {
             self.TextOutput.image = NewImage
             }
             }
             else
             {
             print("No image to display.")
             }
             }
             */
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
    
    // MARK: - Command bar delegate functions.
    
    func HasTitles(_ sender: CommandBarManager) -> Bool
    {
        switch sender
        {                
            case CommandScroller:
                return true
                
            default:
                return false
        }
    }
    
    func TitleFontSize(_ sender: CommandBarManager, Command: CommandButtons) -> CGFloat
    {
        return 14.0
    }
    
    func TitleColor(_ sender: CommandBarManager, Command: CommandButtons) -> UIColor?
    {
        return nil
    }
    
    func ButtonHorizontalGap(_ sender: CommandBarManager) -> CGFloat
    {
        return 16.0
    }
    
    func InitialGap(_ sender: CommandBarManager) -> CGFloat
    {
        return 0.0
    }
    
    func DoubleTap(_ sender: CommandBarManager, Command: CommandButtons)
    {
        //Not used here.
    }
    
    /// Handle long taps on command buttons. Nothing done here.
    func LongTapOn(_ Command: CommandButtons)
    {
        //Not used here.
    }
    
    func LongTapOn(_ sender: CommandBarManager, Command: CommandButtons)
    {
        
    }
    
    func ButtonColor(_ sender: CommandBarManager, Command: CommandButtons) -> UIColor?
    {
        return UIColor.systemBlue
    }
    
    func HighlightTappedButtons(_ sender: CommandBarManager) -> Bool
    {
        return false
    }
    
    func CommandButtonSize(_ sender: CommandBarManager, Command: CommandButtons) -> CGSize?
    {
        switch sender
        {                
            case CommandScroller:
                return CGSize(width: UIConstants.MainIconWidth,
                              height: UIConstants.MainIconHeight)
                
            default:
                return CGSize(width: UIConstants.DefaultIconWidth,
                              height: UIConstants.DefaultIconHeight)
        }
    }
    
    /// Execute the passed command. Commands are passed from the main command panel.
    /// - Note: Unknown/unimplemented commands are ignored.
    /// - Parameter Command: The command to execute.
    func ExecuteCommand(_ sender: CommandBarManager, Command: CommandButtons)
    {
        switch Command
        {
            case .ActionButton:
                SettingPanel.layer.zPosition = 1000
                TextInput.isUserInteractionEnabled = false
                UIView.animate(withDuration: 0.3,
                               delay: 0.0,
                               options: [.curveEaseIn],
                               animations:
                                {
                    self.SettingPanel.alpha = 1.0
                },
                               completion:
                                {
                    _ in
                    self.SettingPanel.becomeFirstResponder()
                })
                
            case .ProjectButton:
                break
            case .CameraButton:
                break
            case .VideoButton:
                break
                
            case .SaveButton:
                SaveCurrentImage()
                
            case .ShareButton:
                guard let ImageToShare = TextOutput.image else
                {
                    Debug.Print("No image to share")
                    return
                }
                SharedImage = ImageToShare
                ShareCurrentImage() 
                
            case .TextFormatButton:
                ShowSliceHandler(.TextFormatting)
                
            case .FontButton:
                RunSlicedSettings(StoryboardName: "SettingsUI",
                                  ControllerName: "FontPickerController")
                
            case .DimensionsButton:
                ShowSliceHandler(.ViewportSize)
                
            case .PlayButton:
                SetAnimationState()
             SetAnimationState2()
                
            case .UserButton:
                let Storyboard = UIStoryboard(name: "UserShapes", bundle: nil)
                let VC = Storyboard.instantiateViewController(withIdentifier: "UserShapeController") as! UserShapeController
                self.present(VC, animated: true)
                
            case .BackgroundButton:
                ShowSliceHandler(.BackgroundSettings)
                
            case .ShapeOptionsButton:
                switch Settings.GetEnum(ForKey: .CurrentShape, EnumType: Shapes.self, Default: .Circle)
                {
                    case .Circle:
                        ShowSliceHandler(.CircleSettings)
                        
                    case .Ellipse:
                        ShowSliceHandler(.EllipseSettings)
                        
                    default:
                        break
                }
                
            case .AnimationButton:
                ShowSliceHandler(.AnimationSettings)
                
            case .GuidelinesButton:
                ShowSliceHandler(.GuidelineSettings)
        }
    }
    
    var SharedImage: UIImage? = nil
    
    func SetAnimationState2()
    {
        let OldAnimation = Settings.GetBool(.Animating)
        CurrentlyAnimating = OldAnimation
        Settings.SetBool(.Animating, !OldAnimation)
    }
    
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
    
    func ShapeGroupSelected(_ sender: CommandBarManager, NewCategory: ShapeCategories)
    {
        
    }
    
    func ShapeSelected(_ sender: CommandBarManager, NewShape: Shapes)
    {
        
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
    
    @IBOutlet weak var TextStack: UIStackView!
    @IBOutlet weak var ShortMessageLabel: UILabel!

    @IBOutlet weak var TextDoneButton: UIButton!
    var PreviousController: UIViewController? = nil
}
