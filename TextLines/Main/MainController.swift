//
//  ViewController.swift
//  TextLine
//
//  Created by Stuart Rankin on 8/10/21.
//

import Foundation
import UIKit

class ViewController: UIViewController, UITextViewDelegate, MainProtocol
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
        /*
        if let Voynich = UIFont(name: "Voynich-123", size: 56)
        {
            print("Voynich font created OK")
        }
        else
        {
            print("!!!!! Error creating Voynich font")
        }
        */
        Settings.Initialize()
        Settings.AddSubscriber(self)
        Settings.SetBool(.Animating, false)
        BarController = ButtonBars(CommandBar: CommandScroller,
                                   MainView: ShapeCategoryScroller,
                                   ShapeContainerView: ShapeView)
        BarController?.delegate = self
        InitializeSVGImages()
        InitializeToolBar()
        DeviceType = UIDevice.current.userInterfaceIdiom
        
        #if !DEBUG
        SettingCommands = SettingCommands.dropLast()
        #endif
        SettingPanelGearButton.setTitle("", for: .normal)
        SettingPanel.alpha = 0.0
        SettingPanel.layer.zPosition = -1000
        SettingPanel.resignFirstResponder()
        SettingPanel.layer.maskedCorners = [CACornerMask.layerMaxXMaxYCorner,
                                          CACornerMask.layerMinXMaxYCorner]
        SettingPanel.layer.cornerRadius = 5.0
        SettingPanelCommandTable.layer.borderColor = UIColor.gray.cgColor
        SettingPanelCommandTable.layer.borderWidth = 0.5
        SettingPanelCommandTable.layer.cornerRadius = 5.0
        
        SettingOptionTable.layer.borderColor = UIColor.gray.cgColor
        SettingOptionTable.layer.borderWidth = 0.5
        SettingOptionTable.layer.cornerRadius = 5.0
        
        let OptionDrag = UIPanGestureRecognizer(target: self,
                                                action: #selector(HandleSettingDragging))
        SettingsPanelDragBar.addGestureRecognizer(OptionDrag)
        SettingsPanelDragBar.layer.cornerRadius = 4.0
        let ResetDragBar = UITapGestureRecognizer(target: self,
                                                  action: #selector(HandleResetSettingsPanel))
        ResetDragBar.numberOfTapsRequired = 2
        SettingsPanelDragBar.addGestureRecognizer(ResetDragBar)
        
        InitializeKeyboard()
        StartText = "TextLine Version \(Versioning.VerySimpleVersionString()), Build \(Versioning.Build)"
        CurrentText = StartText
        UpdateOutput()
        TextInput.text = StartText
        UserShapeManager.LoadUserShapes()
        
        print("Screen.height=\(UIScreen.main.bounds.height)")
    }
    
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
        let NewName = Settings.GetString(.ActionIconName, "CogIcon")
        ActionImage.image = UIImage(named: NewName)
        ActionImage.image = ActionImage.image?.withRenderingMode(.alwaysTemplate)
        ActionImage.tintColor = UIColor.systemBlue
        ShapesImage.image = ShapesImage.image?.withRenderingMode(.alwaysTemplate)
        ShapesImage.tintColor = UIColor.systemBlue
    }
    
    var StartText = ""
    var BarController: ButtonBars? = nil
    var OriginalOptionsHeight: CGFloat = 0.0
    var CurrentShape: Shapes? = nil
    var DeviceType: UIUserInterfaceIdiom = .mac
    
    /// Return a dictionary of main shape category `UIImageView`s. Called by `ShapeBars`.
    /// - Returns: Dictionary of `UIImageView`s.
    func GetMainImages() -> [ShapeCategories: UIImageView]
    {
        var Images = [ShapeCategories: UIImageView]()
        Images[.Shapes] = MainShapeImage
        Images[.Lines] = MainLineImage
        Images[.Freeform] = MainFreeImage
        return Images
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
    
    /// Initialize the animation button depending on the state of animation.
    /// - Parameter IsAnimating: The current animation state.
    func SetupAnimationButton(_ IsAnimating: Bool)
    {
        /*
        if IsAnimating
        {
        AnimateButton2.setImage(UIImage(systemName: "stop.circle"), for: .normal)
            PlayText.text = "Stop"
        }
        else
        {
            AnimateButton2.setImage(UIImage(systemName: "play"), for: .normal)
            PlayText.text = "Play"
        }
         */
    }
    
    /// Alternative animation toggling to `ToggleAnimation`.
    func SetAnimationState()
    {
        CurrentlyAnimating = Settings.GetBool(.Animating)
        SetupAnimationButton(CurrentlyAnimating)
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
    
    /// Toggle the running of animation of the text.
    /// - Parameter Button: The button in the UI that shows the current animation status - updated to reflect
    ///                     the user's action.
    func ToggleAnimation(_ Button: UIButton)
    {
        CurrentlyAnimating = !CurrentlyAnimating
        Settings.SetBool(.Animating, CurrentlyAnimating)
        SetupAnimationButton(CurrentlyAnimating)
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
    
    /// React to the UI animation button.
    /// - Parameter sender: Not used.
    @IBAction func AnimateButtonHandler(_ sender: Any)
    {
        if let Button = sender as? UIButton
        {
            ToggleAnimation(Button)
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
            if Settings.GetBool(.Animating)
            {
                Offset = AnimationOffset
            }
            if let NewImage = PlotText(CurrentText, On: Path, With: CGFloat(Offset))
            {
                TextOutput.image = NewImage
            }
            else
            {
                print("No image returned from PlotText.")
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
    
    /// Returns a dictionary of images for command buttons.
    /// - Returns: Dictionary of command button images keyed by `CommandButtons`.
    func GetCommandImages() -> [CommandButtons: UIImageView]
    {
        let Buttons =
        [
            CommandButtons.ActionButton: ActionImage!,
            CommandButtons.ProjectButton: ShapesImage!
        ]
        return Buttons
    }
    
    /// Return a reference to the scroll view in which the shapes container lives.
    func GetShapeScroller() -> UIScrollView
    {
        return ShapeScrollView
    }
    
    /// Execute the passed command. Commands are passed from the main command panel.
    /// - Note: Unknown/unimplemented commands are ignored.
    /// - Parameter Command: The command to execute.
    func ExecuteCommand(_ Command: CommandButtons)
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
    
    var PreviousShape: Shapes? = nil
    var CurrentText: String = ""
    /// ID used for settings subscriptions.
    var ClassID = UUID()
    
    // MARK: - Interface Builder outlets.
    
    @IBOutlet weak var TextOutput: UIImageView!
    @IBOutlet weak var TextInput: UITextView!
    @IBOutlet weak var ShapeScroller: UIScrollView!
    @IBOutlet weak var ShapeCategoryScroller: UIScrollView!
    @IBOutlet weak var CommandScroller: UIScrollView!
    
    @IBOutlet weak var ControlStack: UIStackView!
    
    @IBOutlet weak var MainLineImage: UIImageView!
    @IBOutlet weak var MainFreeImage: UIImageView!
    @IBOutlet weak var MainShapeImage: UIImageView!
    
    @IBOutlet weak var SettingPanelCommandTable: UITableView!
    @IBOutlet weak var SettingOptionTable: UITableView!
    @IBOutlet weak var SettingPanelGearButton: UIButton!
    @IBOutlet weak var SettingPanel: UIView!
    @IBOutlet weak var SettingsPanelDragBar: UIView!
    @IBOutlet weak var SettingsHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var GroupsLabel: UILabel!
    @IBOutlet weak var ShapesLabel: UILabel!
    
    @IBOutlet weak var ActionImage: UIImageView!
    @IBOutlet weak var ShapesImage: UIImageView!

    @IBOutlet weak var ShapeView: UIView!
    @IBOutlet weak var ShapeScrollView: UIScrollView!
}
