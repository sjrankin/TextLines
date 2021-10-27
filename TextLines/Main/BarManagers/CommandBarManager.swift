//
//  CommandBarManager.swift
//  TextLines
//
//  Created by Stuart Rankin on 10/24/21.
//

import Foundation
import UIKit

class CommandBarManager: NSObject, UIScrollViewDelegate
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
    init(CommandBar: UIView,
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
        var Index = 0
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
                        LongPress.minimumPressDuration = 0.75
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
                    Index = Index + 1
                }
            }
        }
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
        switch For
        {
            case .ActionButton:
                Image = LoadImage(Name: "ThreeDotsInCircleIcon", Type: .SVG)
                SVGImage = true
                
            case .ProjectButton:
                Image = LoadImage(Name: "square.3.stack.3d", Type: .System)
                
            case .CameraButton:
                Image = LoadImage(Name: "camera", Type: .System)
                
            case .FontButton:
                Image = LoadImage(Name: "textformat.abc", Type: .System)
                
            case .PlayButton:
                Image = LoadImage(Name: "play", Type: .System)
                
            case .SaveButton:
                Image = LoadImage(Name: "square.and.arrow.down", Type: .System)
                
            case .ShareButton:
                Image = LoadImage(Name: "square.and.arrow.up", Type: .System)
                
            case .UserButton:
                Image = LoadImage(Name: "scribble", Type: .System)
                
            case .VideoButton:
                Image = LoadImage(Name: "VideoCamera", Type: .SVG)
                SVGImage = true
        }
        guard let FinalImage = Image else
        {
            Debug.FatalError("Error creating button image")
        }
        let ImageSize = delegate?.CommandButtonSize(self, Command: For) ?? CGSize(width: 64, height: 64)
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
        IView.isUserInteractionEnabled = true
        let Name = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 60, height: 40)))
        Name.text = NameForCommand(For)
        Name.textAlignment = .center
        let TextColor = delegate?.TitleColor(self, Command: For) ?? UIColor(named: "GeneralTextColor")
        Name.textColor = TextColor 
        Name.font = UIFont.boldSystemFont(ofSize: 16.0)
        let VStack = UIStackView(arrangedSubviews: [IView, Name])
        VStack.frame = CGRect(x: 0,
                              y: 0,
                              width: ImageSize.width,
                              height: ImageSize.height + 20)
        VStack.axis = .vertical
        let HGap = delegate?.ButtonHorizontalGap(self) ?? 10.0
        let FinalView = UIView2(frame: CGRect(x: HGap + (CGFloat(Index) * (ImageSize.width + HGap)),
                                              y: 5,
                                              width: ImageSize.width,
                                              height: 90))
        FinalView.addSubview(VStack)
        FinalView.isUserInteractionEnabled = true
        FinalView.Tag = For
        FinalView.layer.zPosition = 1000
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
                return "Play"
                
            case .FontButton:
                return "Fonts"
                
            case .ProjectButton:
                return "Project"
                
            case .CameraButton:
                return "Camera"
                
            case .VideoButton:
                return "Video"
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
    
    func AddCommandButton(_ Add: CommandButtons)
    {
        if Add == .ActionButton
        {
            return
        }
        if ActionButtonExists(Add)
        {
            return
        }
    }
    
    func RemoveCommandButton(_ Remove: CommandButtons)
    {
        if Remove == .ActionButton
        {
            return
        }
        if !ActionButtonExists(Remove)
        {
            return
        }
    }
    
    var CommandBar: UIView? = nil
}