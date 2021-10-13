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
        
        OptionsWindowTable.layer.borderColor = UIColor.gray.cgColor
        OptionsWindowTable.layer.borderWidth = 0.5
        OptionsWindowTable.layer.cornerRadius = 5.0
        
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
    }
    
    var OptionsInitialized = false
    
    func InitializeFlyInSettings()
    {
        if OptionsInitialized
        {
            return
        }
        OptionsInitialized = true
        OptionsWindow?.alpha = 0.0
        OptionsWindow?.layer.zPosition = 1000
        ShowingOptions = false
        OptionsWindow?.layer.borderWidth = 2.0
        OptionsWindow?.layer.borderColor = UIColor.black.cgColor
        OptionsWindow?.layer.cornerRadius = 5.0
        
        let GrabPan = UIPanGestureRecognizer(target: self, action: #selector(HandleGrapPan))
        GrabView.addGestureRecognizer(GrabPan)
    }
    
    var PreviousPanPoint: CGPoint? = nil
    @objc func HandleGrapPan(_ Recognizer: UIPanGestureRecognizer)
    {
        let PanPoint = Recognizer.location(in: self.view)
        print("PanPoint.y=\(PanPoint.y)")
        switch Recognizer.state
        {
            case .began:
                PreviousPanPoint = PanPoint
                
            case .changed:
                if PanPoint.y <= EditSurface.frame.origin.y
                {
                    break
                }
                if PanPoint.y >= ((EditSurface.frame.size.height + EditSurface.frame.origin.y) - 30)
                {
                    break
                }
                OptionsWindow.frame = CGRect(x: OptionsWindow.frame.origin.x,
                                             y: PanPoint.y,
                                             width: OptionsWindow.frame.size.width,
                                             height: OptionsWindow.frame.size.height)
                
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 10
    }
    
    /// Returns the height of each cell. If running on a relatively small screen, the height
    /// is multiplied by `0.85` to reduce the size a bit to make more room for the drawing view.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        var CellHeight: CGFloat = 0.0
        switch indexPath.row
        {
            case 0:
                CellHeight = SegmentCell.CellHeight
                
            case 1:
                CellHeight =  BooleanCell2.CellHeight
                
            case 2:
                CellHeight =  BooleanCell2.CellHeight
                
            case 3:
                CellHeight =  SegmentCell.CellHeight
                
            case 4:
                CellHeight =  ButtonCell.CellHeight
                
            case 5:
                CellHeight =  ButtonCell.CellHeight
                
            case 6:
                CellHeight =  BooleanCell2.CellHeight
                
            case 7:
                CellHeight =  BooleanCell2.CellHeight
                
            case 8:
                CellHeight =  SegmentCell.CellHeight
                
            case 9:
                CellHeight =  SegmentCell.CellHeight
                
            default:
                CellHeight = 0.0
        }
        let CurrentHeight = UIScreen.main.bounds.height
        //The value 590 is slightly larger than than an iPhone 8 vertical screen size.
        if CurrentHeight < 590
        {
            CellHeight = CellHeight * 0.85
        }
        return CellHeight
    }
    
    func CellBackground(For Multiple: Int) -> UIColor
    {
        return Multiple.isMultiple(of: 2) ? UIColor(named: "OptionsColor0")! : UIColor(named: "OptionsColor1")!
    }
    
    var ModeSegment = 0
    var GridSegment = 0
    var InitialIndex = 0
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch indexPath.row
        {
            case 0:
                let SegCell = SegmentCell(style: .default, reuseIdentifier: "SegmentCell")
                SegCell.LoadCell(Title: "Tap actions",
                                 Names: ["Add", "Move", "Delete"],
                                 Width: tableView.frame.width,
                                 InitialIndex: ModeSegment)
                {
                    Index in
                    guard Index >= 0 && Index < EditTypes.allCases.count else
                    {
                        return
                    }
                    self.ModeSegment = Index
                    let Mode = [EditTypes.Add, EditTypes.Move, EditTypes.Delete][Index]
                    self.EditSurface.SetEditMode(Mode)
                }
                SegCell.backgroundColor = CellBackground(For: indexPath.row)
                return SegCell
                
            case 1:
                let BoolCell = BooleanCell2(style: .default, reuseIdentifier: "BooleanCell2")
                BoolCell.LoadCell(InitialValue: IsSmoothed, Header: "Smooth lines", Width: tableView.frame.width)
                {
                    DoSmooth in
                    self.EditSurface.SetSmoothing(On: DoSmooth)
                    self.ShapeToEdit.SmoothLines = DoSmooth
                    self.IsSmoothed = DoSmooth
                }
                BoolCell.backgroundColor = CellBackground(For: indexPath.row)
                return BoolCell
                
            case 2:
                let BoolCell = BooleanCell2(style: .default, reuseIdentifier: "BooleanCell2")
                BoolCell.LoadCell(InitialValue: IsClosed, Header: "Closed path", Width: tableView.frame.width)
                {
                    ClosedPath in
                    self.EditSurface.CloseUserPath(ClosedPath)
                    self.ShapeToEdit.ClosedLoop = ClosedPath
                    self.IsClosed = ClosedPath
                }
                BoolCell.backgroundColor = CellBackground(For: indexPath.row)
                return BoolCell
                
            case 3:
                let SegNames = ["None", "8", "16", "32", "64"]
                let SegCell = SegmentCell(style: .default, reuseIdentifier: "SegmentCell")
                SegCell.LoadCell(Title: "Snap to grid",
                                 Names: SegNames,
                                 Width: tableView.frame.width,
                                 InitialIndex: GridSegment)
                {
                    Index in
                    guard Index >= 0 && Index < SegNames.count else
                    {
                        return
                    }
                    self.GridSegment = Index
                    let Raw = SegNames[Index]
                    var Final = 0
                    switch Raw
                    {
                        case "None":
                            Final = 0
                            
                        case "8":
                            Final = 8
                            
                        case "16":
                            Final = 16
                            
                        case "32":
                            Final = 32
                            
                        case "64":
                            Final = 64
                            
                        default:
                            Final = 0
                    }
                    self.EditSurface.SetGridVisibility(Final)
                }
                SegCell.backgroundColor = CellBackground(For: indexPath.row)
                return SegCell
                
            case 4:
                let ButtonCell = ButtonCell(style: .default, reuseIdentifier: "ButtonCell")
                ButtonCell.LoadCell(Header: "Clone as copy", Title: "Copy",
                                    Width: tableView.frame.width)
                {
                    print("Current shape cloned")
                }
                ButtonCell.backgroundColor = CellBackground(For: indexPath.row)
                return ButtonCell
                
            case 5:
                let ButtonCell = ButtonCell(style: .default, reuseIdentifier: "ButtonCell")
                ButtonCell.LoadCell(Header: "Center in viewport", Title: "Center",
                                    Width: tableView.frame.width)
                {
                    self.EditSurface.CenterShapeInCanvas()
                }
                ButtonCell.backgroundColor = CellBackground(For: indexPath.row)
                return ButtonCell
                
            case 6:
                let BoolCell = BooleanCell2(style: .default, reuseIdentifier: "BooleanCell2")
                BoolCell.LoadCell(InitialValue: Settings.GetBool(.ScaleToView),
                                  Header: "Scale viewport", Width: tableView.frame.width)
                {
                    DoScale in
                    Settings.SetBool(.ScaleToView, DoScale)
                    self.EditSurface.ScaleUserShape(DoScale)
                }
                BoolCell.backgroundColor = CellBackground(For: indexPath.row)
                return BoolCell
                
            case 7:
                let BoolCell = BooleanCell2(style: .default, reuseIdentifier: "BooleanCell2")
                BoolCell.LoadCell(InitialValue: Settings.GetBool(.ShowViewport),
                                  Header: "Show viewport", Width: tableView.frame.width)
                {
                    ShowViewport in
                    Settings.SetBool(.ShowViewport, ShowViewport)
                    self.EditSurface.SetViewportBorder(Visible: ShowViewport)
                }
                BoolCell.backgroundColor = CellBackground(For: indexPath.row)
                return BoolCell
                
            case 8:
                let OriginalWidth = ShapeToEdit.ViewportWidth
                
                switch OriginalWidth
                {
                    case 500:
                        InitialIndex = 0
                        
                    case 1000:
                        InitialIndex = 1
                        
                    case 1500:
                        InitialIndex = 2
                        
                    default:
                        InitialIndex = 1
                }
                let SegCell = SegmentCell(style: .default, reuseIdentifier: "SegmentCell")
                SegCell.LoadCell(Title: "Viewport width",
                                 Names: ["500", "1000", "1500"],
                                 Width: tableView.frame.width,
                                 InitialIndex: InitialIndex)
                {
                    NewIndex in
                    self.InitialIndex = NewIndex
                    switch NewIndex
                    {
                        case 0:
                            self.ShapeToEdit.ViewportWidth = 500
                            
                        case 1:
                            self.ShapeToEdit.ViewportWidth = 1000
                            
                        case 2:
                            self.ShapeToEdit.ViewportWidth = 1500
                            
                        default:
                            self.ShapeToEdit.ViewportWidth = 1000
                    }
                }
                SegCell.backgroundColor = CellBackground(For: indexPath.row)
                return SegCell
                
            case 9:
                let OriginalHeight = ShapeToEdit.ViewportHeight
                switch OriginalHeight
                {
                    case 500:
                        InitialIndex = 0
                        
                    case 1000:
                        InitialIndex = 1
                        
                    case 1500:
                        InitialIndex = 2
                        
                    default:
                        InitialIndex = 1
                }
                let SegCell = SegmentCell(style: .default, reuseIdentifier: "SegmentCell")
                SegCell.LoadCell(Title: "Viewport height",
                                 Names: ["500", "1000", "1500"],
                                 Width: tableView.frame.width,
                                 InitialIndex: InitialIndex)
                {
                    NewIndex in
                    self.InitialIndex = NewIndex
                    switch NewIndex
                    {
                        case 0:
                            self.ShapeToEdit.ViewportHeight = 500
                            
                        case 1:
                            self.ShapeToEdit.ViewportHeight = 1000
                            
                        case 2:
                            self.ShapeToEdit.ViewportHeight = 1500
                            
                        default:
                            self.ShapeToEdit.ViewportHeight = 1000
                    }
                }
                SegCell.backgroundColor = CellBackground(For: indexPath.row)
                return SegCell
                
            default:
                return UITableViewCell()
        }
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
                                         target: self, action: #selector(DoneButtonTapped))
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        NameBox.inputAccessoryView = toolbar
    }
    
    @objc func DoneButtonTapped()
    {
        self.view.endEditing(true)
    }
    
    var OriginalOptionWindowHeight: CGFloat? = nil
    var OriginalOptionWindowY: CGFloat? = nil
    
    @IBAction func EditorOptionsButtonHandler(_ sender: Any)
    {
        ShowingOptions = !ShowingOptions
        if OriginalOptionWindowY == nil
        {
            OriginalOptionWindowY = OptionsWindow.frame.origin.y
        }
        if OriginalOptionWindowHeight == nil
        {
            OriginalOptionWindowHeight = OptionsWindow.frame.size.height
            print(">>>> OriginalOptionWindowHeight=\(OriginalOptionWindowHeight!)")
        }
        let NewAlpha = ShowingOptions ? 1.0 : 0.0
        let ChangeDuration = ShowingOptions ? 0.35 : 0.2
        UIView.animate(withDuration: ChangeDuration,
                       delay: 0.0,
                       options: [.curveEaseIn],
                       animations:
                        {
            self.OptionsWindow.alpha = NewAlpha
        },
                       completion: {
            _ in
            if !self.ShowingOptions
            {
                self.OptionsWindow.frame = CGRect(x: 0,
                                                  y: 582,
                                                  width: self.view.frame.size.width,
                                                  height: 300)
            }
        }
        )
    }
    
    var ShowingOptions = false
    
    var IsSemiTransparent = false
    @IBAction func TransparencyButtonHandler(_ sender: Any)
    {
        IsSemiTransparent = !IsSemiTransparent
        OptionsWindow.alpha = IsSemiTransparent ? 0.6 : 1.0
    }
    
    @IBAction func OptionsDoneButtonHandler(_ sender: Any)
    {
        EditorOptionsButtonHandler(sender)
    }
    
    @IBOutlet weak var GrabView: UIView!
    @IBOutlet weak var OptionsWindowTable: UITableView!
    @IBOutlet weak var OptionsDonebutton: UIButton!
    @IBOutlet weak var OptionsWindow: UIView!
    @IBOutlet weak var EditorOptionsButton: UIButton!
    @IBOutlet weak var NameBox: UITextField!
    @IBOutlet weak var EditSurface: UserShape!
}
