//
//  ShapeEditor.swift
//  TextLine
//
//  Created by Stuart Rankin on 9/30/21.
//

import Foundation
import UIKit

class ShapeEditor: UIViewController, UITableViewDelegate, UITableViewDataSource,
                   UITextFieldDelegate
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let RawOrder = Settings.GetString(.UserShapeOptionsOrder,
                                          "0,1,2,3,4,5,6,7,8,9")
        print("RawOrder=\(RawOrder)")
        for Item in RawOrder.components(separatedBy: ",")
        {
            guard let RawValue = Int(Item) else
            {
                Debug.FatalError("Invalid item (\(Item)) found in .UserShapeOptionsOrder.")
            }
            OptionOrder.append(RawValue)
        }
        print("OptionOrder=\(OptionOrder)")
        
        OptionsWindowTable.layer.borderColor = UIColor.gray.cgColor
        OptionsWindowTable.layer.borderWidth = 0.5
        OptionsWindowTable.layer.cornerRadius = 5.0
        OptionsHeight.constant = 50.0
        
        EditSurface.layer.borderColor = UIColor.gray.cgColor
        EditSurface.layer.borderWidth = 0.5
        EditSurface.layer.cornerRadius = 5.0
        
        InitializeTextField()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    var ViewsLaidOut = false
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        if ViewsLaidOut
        {
            return
        }
        ViewsLaidOut = true
        
        EditSurface.Initialize()
        EditSurface.SetSmoothing(On: false)
        EditSurface.CloseUserPath(true)
        EditSurface.SetViewportBorder(Visible: Settings.GetBool(.ShowViewport))
        EditSurface.ScaleUserShape(Settings.GetBool(.ScaleToView))
        EditSurface.SetFinalFrame(EditSurface.frame)
        
        PopulateFromShape(ShapeToEdit)
        InitializeFlyInSettings()
        let TableWidth = OptionsWindowTable.frame.width
        guard let InitialRowOptions = MakeOptionRows(Width: TableWidth) else
        {
            Debug.FatalError("No options returned from MakeOptionRows.")
        }
        RowOptions = InitialRowOptions
            OptionsWindowTable.reloadData()
    }
    
    var OptionsInitialized = false
    
    func InitializeFlyInSettings()
    {
        if OptionsInitialized
        {
            return
        }
        OptionsInitialized = true
        OptionsWindow?.layer.zPosition = 1000
        OptionsWindow?.layer.borderWidth = 2.0
        OptionsWindow?.layer.borderColor = UIColor.gray.cgColor
        OptionsWindow?.layer.cornerRadius = 5.0
        StartingY = OptionsWindow!.frame.origin.y
        
        let GrabPan = UIPanGestureRecognizer(target: self, action: #selector(HandleGrabPan))
        GrabView.addGestureRecognizer(GrabPan)
        let GrabTap = UITapGestureRecognizer(target: self, action: #selector(HandleGrabTap))
        GrabTap.numberOfTapsRequired = 2
        GrabView.addGestureRecognizer(GrabTap)
    }
    
    var StartingY: CGFloat = 0.0
    
    @objc func HandleGrabTap(_ Recognizer: UITapGestureRecognizer)
    {
        if ReorderingOptions
        {
            return
        }
        if !IsShowing
        {
            return
        }
        IsShowing = false
        SetStandardSettingsLocation(Show: false)
    }
    
    var PreviousPanPoint: CGPoint? = nil
    @objc func HandleGrabPan(_ Recognizer: UIPanGestureRecognizer)
    {
        if ReorderingOptions
        {
            return
        }
        let PanPoint = Recognizer.location(in: self.view)
        switch Recognizer.state
        {
            case .began:
                PreviousPanPoint = PanPoint
                let Velocity = Recognizer.velocity(in: self.view)
                if Velocity.y > 350
                {
                    IsShowing = false
                    SetStandardSettingsLocation(Show: false)
                    //Hide down.
                    //Cancels the current recognizer.
                    Recognizer.isEnabled = false
                    Recognizer.isEnabled = true
                    PreviousPanPoint = nil
                }
                if Velocity.y < -350
                {
                    IsShowing = true
                    SetStandardSettingsLocation(Show: true)
                    //Show up.
                    //Cancels the current recognizer.
                    Recognizer.isEnabled = false
                    Recognizer.isEnabled = true
                    PreviousPanPoint = nil
                }
                
            case .changed:
                if PanPoint.y <= EditSurface.frame.origin.y
                {
                    //Too high
                    break
                }
                let NewHeight = 50 + (StartingY - PanPoint.y)
                if NewHeight <= 50
                {
                    //Too low
                    IsShowing = false
                    UpdateChevronButton(ToShow: false)
                    break
                }
                IsShowing = true
                UpdateChevronButton(ToShow: true)
                OptionsHeight.constant = NewHeight
                
            case .ended:
                PreviousPanPoint = nil
                
            default:
                break
        }
    }
    
    var ShapeID: UUID? = nil
    {
        didSet
        {
            if ShapeID == nil
            {
                ShapeToEdit.ID = UUID()
                ShapeToEdit.Name = ""
                ShapeToEdit.ClosedLoop = true
                ShapeToEdit.SmoothLines = false
            }
            else
            {
                if UserShapeManager.HasShape(ID: ShapeID!)
                {
                    ShapeToEdit = UserShapeManager.GetShape(With: ShapeID!)!
                }
            }
        }
    }
    
    var ShapeToEdit = UserDefinedShape()
    
    weak var Delegate: ShapeManagerDelegate? = nil
    
    var IsSmoothed: Bool = false
    var IsClosed: Bool = true
    var Populated = false
    func PopulateFromShape(_ TheShape: UserDefinedShape)
    {
        if Populated
        {
            return
        }
        Populated = true
        NameBox.text = TheShape.Name
        IsClosed = TheShape.ClosedLoop
        IsSmoothed = TheShape.SmoothLines
        EditSurface.OriginalPoints = TheShape.Points
        if IsSmoothed
        {
            EditSurface.SetSmoothing(On: true)
        }
        EditSurface.Redraw()
    }
    
    // MARK: - Table view functions.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return RowOptions.count
    }
    
    /// Returns the height of each cell. If running on a relatively small screen, the height
    /// is multiplied by `0.85` to reduce the size a bit to make more room for the drawing view.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        var CellHeight = RowOptions[indexPath.row].CellHeight
        let CurrentHeight = UIScreen.main.bounds.height
        //The value 590 is slightly larger than than an iPhone 8 vertical screen size.
        if CurrentHeight < 590
        {
            CellHeight = CellHeight * 0.85
        }
        return CellHeight
    }
    
    var ModeSegment = 0
    var GridSegment = 0
    var InitialIndex = 0
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        return RowOptions[indexPath.row].Cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
    {
        return UITableViewCell.EditingStyle.none
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        OptionOrder.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        var NewOrder = ""
        for Index in OptionOrder
        {
            NewOrder = NewOrder + "\(Index)"
            if Index != OptionOrder.last
            {
                NewOrder = NewOrder + ","
            }
        }
        Settings.SetString(.UserShapeOptionsOrder, NewOrder)
        guard let NewRowOptions = MakeOptionRows(Width: OptionsWindowTable.frame.width) else
        {
            Debug.FatalError("No options returned from 'moveRowAt'.")
        }
        RowOptions = NewRowOptions
        OptionsWindowTable.reloadData()
    }
    
    @IBAction func SaveButtonHandler(_ sender: Any)
    {
        ShapeToEdit.Points = EditSurface.OriginalPoints
        if NameBox.text != nil
        {
            ShapeToEdit.Name = NameBox.text!
        }
        Delegate?.Done(ID: ShapeToEdit.ID, TheShape: ShapeToEdit)
        self.dismiss(animated: true)
    }
    
    @IBAction func CancelButtonHandler(_ sender: Any)
    {
        Delegate?.Canceled()
        self.dismiss(animated: true)
    }
    
    func InitializeTextField()
    {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Dismiss", style: .done,
                                         target: self, action: #selector(KeyboardDoneButtonTapped))
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        NameBox.inputAccessoryView = toolbar
    }
    
    @objc func KeyboardDoneButtonTapped()
    {
        self.view.endEditing(true)
    }
    
    var ReorderingOptions = false
    
    @IBAction func ReorderOptionsHandler(_ sender: Any)
    {
        ReorderingOptions = !ReorderingOptions
        let NewButtonTitle = ReorderingOptions ? "Done" : "Reorder"
        OptionsReorderButton.setTitle(NewButtonTitle, for: .normal)
        HideShowButton.isEnabled = !ReorderingOptions
        OptionsWindowTable.setEditing(ReorderingOptions, animated: true)
    }
    
    var PreviousChevronState: Bool? = nil
    
    func UpdateChevronButton(ToShow: Bool)
    {
        if PreviousChevronState != nil
        {
            if ToShow == PreviousChevronState
            {
                return
            }
        }
        PreviousChevronState = ToShow
        OptionsReorderButton.isEnabled = ToShow
        let RotationAngle = ToShow ? 180.0.Radians : 0.0.Radians
        let BorderColor = ToShow ? UIColor.black.cgColor : UIColor.gray.cgColor
        UIView.animate(withDuration: 0.35)
        {
            self.OptionsWindow.layer.borderColor = BorderColor
            self.HideShowButton.transform = CGAffineTransform(rotationAngle: RotationAngle)
        }
    }
    
    var IsShowing = false
    
    /// Show the settings pane in a standard size depending on the value
    /// of `Show`.
    /// - Parameter Show: Determines if the settings pane is in a standard size
    ///                   or mostlyl hidden.
    func SetStandardSettingsLocation(Show: Bool)
    {
        UpdateChevronButton(ToShow: Show)
        let NewHeight = Show ? 350.0 : 50.0
        OptionsHeight.constant = NewHeight
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: [.curveEaseIn])
        {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func HideShowButtonHandler(_ sender: Any)
    {
        IsShowing = !IsShowing
        SetStandardSettingsLocation(Show: IsShowing)
    }
    
    // MARK: - Extension variables.
    var OptionOrder = [Int]()
    var RowOptions = [(CellHeight: CGFloat, Cell: UITableViewCell)]()
    
    @IBOutlet weak var OptionsReorderButton: UIButton!
    @IBOutlet weak var HideShowButton: UIButton!
    @IBOutlet weak var EditSurfaceTop: NSLayoutConstraint!
    @IBOutlet weak var OptionsHeight: NSLayoutConstraint!
    @IBOutlet weak var GrabView: UIView!
    @IBOutlet weak var OptionsWindowTable: UITableView!
    @IBOutlet weak var OptionsWindow: UIView!
    @IBOutlet weak var NameBox: UITextField!
    @IBOutlet weak var EditSurface: UserShape!
}
