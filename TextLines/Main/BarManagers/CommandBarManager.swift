//
//  CommandBarManager.swift
//  TextLines
//
//  Created by Stuart Rankin on 10/24/21.
//

import Foundation
import UIKit

class CommandBarManager: NSObject, UIScrollViewDelegate, CommandBarControlProtocol
{
    /// Delegate to the main view. When set, late initialization is executed.
    public weak var delegate: CommandBarProtocol? = nil
    {
        didSet
        {
            LateInitialization()
        }
    }
    
    /// Initializer.
    /// - Parameter CommandBar: The `UIScrollView` used for command buttons.
    /// - Note: In order for full functionality, `delegate` must be assigned by the caller
    ///         immediately after instantiating this class.
    /// - Parameter Buttons: List of buttons for the command bar.
    /// - Parameter EnableLongPress: If true, long press gestures are enabled and
    ///                              returned to the delegate. Default is `false`.
    /// - Parameter EnableDoubleTap: If true, double tap gestures are enabled and
    ///                              returned to the delegate. Default is `false`.
    init(CommandBar: UIScrollView,
         Buttons: [String],
         EnableLongPress: Bool = false,
         EnableDoubleTap: Bool = false)
    {
        super.init()
        self.CommandBar = CommandBar
        ButtonSource = Buttons
        self.EnableLongPress = EnableLongPress
        self.EnableDoubleTap = EnableDoubleTap
    }
    
    var EnableDoubleTap: Bool = false
    var EnableLongPress: Bool = false
    var ButtonSource = [String]()
    
    /// Called when the main view delegate is set.
    /// - Important: Requires the delegate to the main view to be valid. If not, at the very least,
    ///              a fatal error will result.
    func LateInitialization()
    {
        PopulateCommandBar()
    }
    
    func ShowOverlay(_ DoShow: Bool)
    {
        if DoShow
        {
            let OverlayFrame = CGRect(x: 0, y: 0,
                                      width: CommandBar!.frame.width,
                                      height: CommandBar!.frame.height)
            VisualOverlay = UIView(frame: OverlayFrame)
            VisualOverlay!.layer.backgroundColor = UIColor.black.withAlphaComponent(UIConstants.CommandBarOverlayAlpha).cgColor
            CommandBar!.addSubview(VisualOverlay!)
            VisualOverlay?.layer.zPosition = 5000
        }
        else
        {
            VisualOverlay?.removeFromSuperview()
            VisualOverlay = nil
        }
    }
    
    /// Overylay displayed when the keyboard is active. This prevents the user from
    /// selecting commands as well as indicating they shouldn't do so.
    var VisualOverlay: UIView? = nil
    
    var SmallDevice = false
    
    func UpdateButtons(NewButtons: [String])
    {
        ButtonSource = NewButtons
        for SubView in CommandBar!.subviews
        {
            SubView.removeFromSuperview()
        }
        PopulateCommandBar()
    }
    
    func PopulateCommandBar()
    {
        MakeCommandButtons(With: ButtonSource)
    }
    
    @objc func HandleCommandIconTapped(_ Recognizer: UITapGestureRecognizer2)
    {
        delegate?.ExecuteCommand(self, Command: Recognizer.ForCommand)
    }
    
    func MakeCommandButtons(With Raw: [String])
    {
        CurrentCommandButtons.removeAll()
        let HGap = delegate?.ButtonHorizontalGap(self) ?? UIConstants.HorizontalGap
        var Index = 0
        var CumulativeWidth: CGFloat = 0.0
        for SomeCommand in Raw
        {
            if let ActualCommand = CommandButtons(rawValue: SomeCommand)
            {
                if let CommandImage = MakeCommandButtonImage(For: ActualCommand,
                                                             Index: Index)
                {
                    let CommandTap = UITapGestureRecognizer2(target: self,
                                                             action: #selector(HandleCommandIconTapped))
                    CommandTap.ForCommand = ActualCommand
                    CommandImage.addGestureRecognizer(CommandTap)
                    if EnableLongPress
                    {
                        let LongPress = UILongPressGestureRecognizer2(target: self,
                                                                      action: #selector(HandleLongTap))
                        LongPress.minimumPressDuration = UIConstants.CommandLongPressDuration
                        LongPress.ForCommand = ActualCommand
                        CommandImage.addGestureRecognizer(LongPress)
                    }
                    if EnableDoubleTap
                    {
                        let DoubleTap = UITapGestureRecognizer2(target: self,
                                                                action: #selector(HandleDoubleTap))
                        DoubleTap.numberOfTapsRequired = 2
                        DoubleTap.ForCommand = ActualCommand
                        CommandImage.addGestureRecognizer(DoubleTap)
                    }
                    CurrentCommandButtons.append((ActualCommand, CommandImage))
                    CommandBar?.addSubview(CommandImage)
                    CumulativeWidth = CumulativeWidth + CommandImage.frame.width + HGap
                    Index = Index + 1
                }
            }
        }
        CommandBar?.contentSize = CGSize(width: CumulativeWidth,
                                         height: CommandBar!.contentSize.height)
        CommandBar!.layoutIfNeeded()
    }
    
    /// Long press handler. Sends message to delegate.
    /// - Parameter Recognizer: Long press recognizer.
    @objc func HandleLongTap(_ Recognizer: UILongPressGestureRecognizer2)
    {
        switch Recognizer.state
        {
            case .began:
                print("Long press on \(Recognizer.ForCommand.rawValue)")
                
            default:
                break
        }
    }
    
    /// Handles double tap returns to the delegate.
    @objc func HandleDoubleTap(_ Recognizer: UITapGestureRecognizer2)
    {
        delegate?.DoubleTap(self, Command: Recognizer.ForCommand)
    }
    
    /// Returns a `UIView2` object of the command image and name to be displayed in the
    /// command bar.
    /// - Parameter For: The command whose image and title will be returned.
    /// - Parameter Index: Determines where order in which the button will be displayed.
    /// - Returns: `UIView2` containing the image and title on success, nil on error.
    func MakeCommandButtonImage(For: CommandButtons, Index: Int) -> UIView2?
    {
        var Image: UIImage? = nil
        var SVGImage: Bool = false
        let ButtonColor = delegate?.ButtonColor(self, Command: For) ?? UIColor.systemBlue
        let ImageName = ReturnButtonImageName(For: For)
        switch For
        {
            case .ActionButton:
                Image = LoadImage(Name: ImageName, Type: .SVG)
                SVGImage = true
                
            case .ProjectButton:
                Image = LoadImage(Name: ImageName, Type: .System)
                
            case .CameraButton:
                Image = LoadImage(Name: ImageName, Type: .System)
                
            case .FontButton:
                Image = LoadImage(Name: ImageName, Type: .System)
                
            case .TextFormatButton:
                Image = LoadImage(Name: ImageName, Type: .System)
                
            case .PlayButton:
                if Settings.GetBool(.Animating)
                {
                    Image = LoadImage(Name: ImageName, Type: .System)
                }
                else
                {
                    Image = LoadImage(Name: ImageName, Type: .System)
                }
                
            case .SaveButton:
                Image = LoadImage(Name: ImageName, Type: .System)
                
            case .ShareButton:
                Image = LoadImage(Name: ImageName, Type: .System)
                
            case .UserButton:
                Image = LoadImage(Name: ImageName, Type: .System)
                
            case .VideoButton:
                Image = LoadImage(Name: ImageName, Type: .SVG)
                SVGImage = true
                
            case .BackgroundButton:
                Image = LoadImage(Name: ImageName, Type: .System)
        
            case .ShapeOptionsButton:
                Image = LoadImage(Name: ImageName, Type: .System)
                
            case .ShapeCommonOptionsButton:
                Image = LoadImage(Name: ImageName, Type: .System)
                
            case .AnimationButton:
                Image = LoadImage(Name: ImageName, Type: .System)
                
            case .DimensionsButton:
                Image = LoadImage(Name: ImageName, Type: .System)
        
            case .GuidelinesButton:
                Image = LoadImage(Name: ImageName, Type: .System)
                
                #if DEBUG
            case .DebugButton:
                Image = LoadImage(Name: ImageName, Type: .System)
                #endif
        }
        guard let FinalImage = Image else
        {
            Debug.FatalError("Error creating button image")
        }
        let ImageSize = delegate?.CommandButtonSize(self, Command: For) ?? CGSize(width: UIConstants.MainIconWidth, height: UIConstants.MainIconHeight)
        let IView = UIImageView2(frame: CGRect(origin: .zero, size: ImageSize))
        IView.image = FinalImage
        if SVGImage
        {
            IView.image = IView.image?.withRenderingMode(.alwaysTemplate)
            IView.tintColor = ButtonColor
        }
        else
        {
            IView.tintColor = ButtonColor
        }
        IView.contentMode = .scaleAspectFit
        IView.isUserInteractionEnabled = true
        let Name = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: UIConstants.ButtonLabelWidth,
                                                                     height: UIConstants.ButtonLabelHeight)))
        Name.text = NameForCommand(For)
        Name.textAlignment = .center
        let TextColor = delegate?.TitleColor(self, Command: For) ?? UIColor(named: "GeneralTextColor")
        Name.textColor = TextColor
        let FontSize = delegate?.TitleFontSize(self, Command: For) ?? UIConstants.ButtonLabelDefaultFontSize
        Name.font = UIFont.boldSystemFont(ofSize: FontSize)
        let VStack = UIStackView(arrangedSubviews: [IView, Name])
        VStack.frame = CGRect(x: 0,
                              y: 0,
                              width: max(ImageSize.width, UIConstants.ButtonLabelWidth),
                              height: ImageSize.height + UIConstants.ButtonLabelHeight)
        VStack.axis = .vertical
        let HGap = delegate?.ButtonHorizontalGap(self) ?? UIConstants.HorizontalGap
        let InitialGap = delegate?.InitialGap(self) ?? UIConstants.InitialGap
        let FinalView = UIView2(frame: CGRect(x: InitialGap + (CGFloat(Index) * (ImageSize.width + HGap)),
                                              y: UIConstants.ButtonYLocation,
                                              width: max(ImageSize.width, UIConstants.ButtonLabelWidth),
                                              height: UIConstants.FinalButtonHeight))
        FinalView.addSubview(VStack)
        FinalView.isUserInteractionEnabled = true
        FinalView.Tag = For
        FinalView.layer.zPosition = UIConstants.VisibleZ
        return FinalView
    }
    
    /// Returns a name for the passed command.
    /// - Parameter Command: The command whose name will be returned.
    /// - Returns: Short name of the command.
    func NameForCommand(_ Command: CommandButtons) -> String
    {
        switch Command
        {
            case .UserButton:
                return "User"
                
            case .ActionButton:
                return "Action"
                
            case .ShareButton:
                return "Share"
                
            case .SaveButton:
                return "Save"
                
            case .PlayButton:
                if Settings.GetBool(.Animating)
                {
                    return "Stop"
                }
                else
                {
                    return "Play"
                }
                
            case .TextFormatButton:
                return "Format"
                
            case .FontButton:
                return "Fonts"
                
            case .ProjectButton:
                return "Project"
                
            case .CameraButton:
                return "Camera"
                
            case .VideoButton:
                return "Video"
                
            case .BackgroundButton:
                return "Back"
                
            case .ShapeOptionsButton:
                return "Shape"
                
            case .ShapeCommonOptionsButton:
                return "Common"
                
            case .AnimationButton:
                return "Motion"
                
            case .DimensionsButton:
                return "Size"
                
            case .GuidelinesButton:
                return "Lines"
                
                #if DEBUG
            case .DebugButton:
                return "Debug"
                #endif
        }
    }
    
    /// Load the image whose name is passed.
    /// - Parameter Name: The name of the image. Only images that reside in the assets
    ///                   collection are loaded.
    /// - Parameter Type: The type of the image. Determines how the image is loaded.
    /// - Returns: A UIImage object on success, nil on error.
    func LoadImage(Name: String, Type: ImageTypes) -> UIImage?
    {
        switch Type
        {
            case .Normal:
                return UIImage(named: Name)
                
            case .System:
                return UIImage(systemName: Name)
                
            case .SVG:
                return UIImage(named: Name)
        }
    }
    
    /// Holds current command buttons.
    var CurrentCommandButtons = [(ButtonAction: CommandButtons, ButtonImage: UIView2)]()
    
    /// Returns the current index of the passed button.
    /// - Parameter Button: The button whose index (into the button array) is returned.
    /// - Returns: Index of `Button` if found, nil if not found.
    func IndexOfButton(_ Button: CommandButtons) -> Int?
    {
        for Index in 0 ..< CurrentCommandButtons.count
        {
            if CurrentCommandButtons[Index].ButtonAction == Button
            {
                return Index
            }
        }
        return nil
    }
    
    /// Determines if the passed button exists in the current set of buttons.
    /// - Parameter Button: The button to determine existence.
    /// - Returns: True if the button exists, false if not.
    func ActionButtonExists(_ Button: CommandButtons) -> Bool
    {
        for (TheAction, _) in CurrentCommandButtons
        {
            if TheAction == Button
            {
                return true
            }
        }
        return false
    }
    
    /// Add a new button to the command bar.
    /// - Note: `.ActionButton` and `.ShapeOptionsButton` cannot be added.
    /// - Parameter Add: The new button to add.
    func AddCommandButton(_ Add: CommandButtons)
    {
        if Add == .ActionButton || Add == .ShapeOptionsButton
        {
            return
        }
        if ActionButtonExists(Add)
        {
            return
        }
    }
    
    /// Remove the passed button from the command bar.
    /// - Note: `.ActionButton` and `.ShapeOptionsButton` cannot be removed.
    /// - Parameter Remove: The new button to remove.
    func RemoveCommandButton(_ Remove: CommandButtons)
    {
        if Remove == .ActionButton || Remove == .ShapeOptionsButton
        {
            return
        }
        if !ActionButtonExists(Remove)
        {
            return
        }
    }
    
    var CommandBar: UIScrollView? = nil
    var CommandView: UIView? = nil
    
    // MARK: - Command bar controlling protocol functions.
    
    /// Return the title for the passed button.
    /// - Parameter For: The button whose title will be returned.
    /// - Returns: Title for the passed button.
    func ReturnButtonTitle(For: CommandButtons) -> String
    {
        return NameForCommand(For)
    }
    
    /// Return a long title for the passed button.
    /// - Parameter For: The button whose long title will be returned.
    /// - Returns: The long title for the passed button.
    func ReturnButtonLongTitle(For: CommandButtons) -> String
    {
        switch For
        {
            case .UserButton:
                return "User shape manager"
                
            case .ActionButton:
                return "Actions and settings"
                
            case .ShareButton:
                return "Share image"
                
            case .SaveButton:
                return "Save image"
                
            case .PlayButton:
                if Settings.GetBool(.Animating)
                {
                    return "Stop animation"
                }
                else
                {
                    return "Play animation"
                }
                
            case .TextFormatButton:
                return "Format text"
                
            case .FontButton:
                return "Text font"
                
            case .ProjectButton:
                return "Project settings"
                
            case .CameraButton:
                return "Take a picture"
                
            case .VideoButton:
                return "Make a video"
                
            case .BackgroundButton:
                return "Background settings"
                
            case .ShapeOptionsButton:
                return "Current shape options"
                
            case .ShapeCommonOptionsButton:
                return "Shape common options"
                
            case .AnimationButton:
                return "Animation settings"
                
            case .DimensionsButton:
                return "Image size setting"
                
            case .GuidelinesButton:
                return "Gridlines and shape lines"
                
#if DEBUG
            case .DebugButton:
                return "Debug"
#endif
        }
    }
    
    /// Return the name of the image for the passed button command.
    /// - Parameter For: The command whose image name is returned.
    /// - Returns: Name of the image to use for the passed command.
    func ReturnButtonImageName(For: CommandButtons) -> String
    {
        switch For
        {
            case .ActionButton:
                return "ThreeDotsInCircleIcon"
                
            case .ProjectButton:
                return "square.3.stack.3d"
                
            case .CameraButton:
                return "camera"
                
            case .FontButton:
                return "f.circle"
                
            case .TextFormatButton:
                return "bold.italic.underline"
                
            case .PlayButton:
                if Settings.GetBool(.Animating)
                {
                    return "stop"
                }
                else
                {
                   return "play"
                }
                
            case .SaveButton:
                return "square.and.arrow.down"
                
            case .ShareButton:
                return "square.and.arrow.up"
                
            case .UserButton:
                return "person.crop.circle"
                
            case .VideoButton:
                return "VideoCamera"
                
            case .BackgroundButton:
                return "photo.fill.on.rectangle.fill"
                
            case .ShapeOptionsButton:
                return "square.on.circle"
                
            case .ShapeCommonOptionsButton:
                return "square.fill.on.circle.fill"
                
            case .AnimationButton:
                return "film.circle"
                
            case .DimensionsButton:
                return "square.dashed.inset.filled"
                
            case .GuidelinesButton:
                return "squareshape.split.3x3"
                
                #if DEBUG
            case .DebugButton:
                return "ant.fill"
                #endif
        }
    }
    
    /// Return a `UIImageView2` that represents an image (with appropriate tinting) of the passed
    /// command.
    /// - Parameter For: The command whose image will be returned.
    /// - Parameter Size: The size of the image to return.
    /// - Parameter ButtonColor: The color to use to tint the button.
    /// - Returns: `UIImageView2` instance holding the image of the button.
    func ReturnButtonImage(For: CommandButtons, Size: CGSize,
                           ButtonColor: UIColor) -> UIImageView2
    {
        var Image: UIImage? = nil
        var SVGImage = false
        let ImageName = ReturnButtonImageName(For: For)
        switch For
        {
            case .ActionButton:
                Image = LoadImage(Name: ImageName, Type: .SVG)
                SVGImage = true
                
            case .ProjectButton:
                Image = LoadImage(Name: ImageName, Type: .System)
                
            case .CameraButton:
                Image = LoadImage(Name: ImageName, Type: .System)
                
            case .FontButton:
                Image = LoadImage(Name: ImageName, Type: .System)
                
            case .TextFormatButton:
                Image = LoadImage(Name: ImageName, Type: .System)
                
            case .PlayButton:
                    Image = LoadImage(Name: ImageName, Type: .System)
                
            case .SaveButton:
                Image = LoadImage(Name: ImageName, Type: .System)
                
            case .ShareButton:
                Image = LoadImage(Name: ImageName, Type: .System)
                
            case .UserButton:
                Image = LoadImage(Name: ImageName, Type: .System)
                
            case .VideoButton:
                Image = LoadImage(Name: ImageName, Type: .SVG)
                SVGImage = true
                
            case .BackgroundButton:
                Image = LoadImage(Name: ImageName, Type: .System)
                
            case .ShapeOptionsButton:
                Image = LoadImage(Name: ImageName, Type: .System)
                
            case .ShapeCommonOptionsButton:
                Image = LoadImage(Name: ImageName, Type: .System)
                
            case .AnimationButton:
                Image = LoadImage(Name: ImageName, Type: .System)
                
            case .DimensionsButton:
                Image = LoadImage(Name: ImageName, Type: .System)
                
            case .GuidelinesButton:
                Image = LoadImage(Name: ImageName, Type: .System)
                
                #if DEBUG
            case .DebugButton:
                Image = LoadImage(Name: ImageName, Type: .System)
                #endif
        }
        
        guard let FinalImage = Image else
        {
            Debug.FatalError("Error creating button image")
        }
        
        let IView = UIImageView2(frame: CGRect(origin: .zero, size: Size))
        IView.image = FinalImage
        if SVGImage
        {
            IView.image = IView.image?.withRenderingMode(.alwaysTemplate)
            IView.tintColor = ButtonColor
        }
        else
        {
            IView.tintColor = ButtonColor
        }
        IView.contentMode = .scaleAspectFit
        IView.isUserInteractionEnabled = true
        
        return IView
    }
}
