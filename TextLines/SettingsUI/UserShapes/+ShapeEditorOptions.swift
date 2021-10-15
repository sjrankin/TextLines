//
//  +ShapeEditorOptions.swift
//  TextLines
//
//  Created by Stuart Rankin on 10/14/21.
//

import Foundation
import UIKit

extension ShapeEditor
{
    func MakeOptionRows(Width: CGFloat) -> [(CGFloat, UITableViewCell)]?
    {
        if OptionOrder.isEmpty
        {
            return nil
        }
        var Results = [(CGFloat, UITableViewCell)]()
        
        var Order: Int = 0
        for CellIndex in OptionOrder
        {
            switch CellIndex
            {
                case 0:
                    let SegCell = SegmentCell(style: .default, reuseIdentifier: "SegmentCell")
                    SegCell.LoadCell(Title: "Tap actions",
                                     Names: ["Add", "Move", "Delete"],
                                     Width: Width,
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
                    SegCell.backgroundColor = CellBackground(For: Order)
                    Results.append((SegmentCell.CellHeight, SegCell))
                    
                case 1:
                    let BoolCell = BooleanCell2(style: .default, reuseIdentifier: "BooleanCell2")
                    BoolCell.LoadCell(InitialValue: IsSmoothed, Header: "Smooth lines", Width: Width)
                    {
                        DoSmooth in
                        self.EditSurface.SetSmoothing(On: DoSmooth)
                        self.ShapeToEdit.SmoothLines = DoSmooth
                        self.IsSmoothed = DoSmooth
                    }
                    BoolCell.backgroundColor = CellBackground(For: Order)
                    Results.append((BooleanCell2.CellHeight, BoolCell))
                    
                case 2:
                    let BoolCell = BooleanCell2(style: .default, reuseIdentifier: "BooleanCell2")
                    BoolCell.LoadCell(InitialValue: IsClosed, Header: "Closed path", Width: Width)
                    {
                        ClosedPath in
                        self.EditSurface.CloseUserPath(ClosedPath)
                        self.ShapeToEdit.ClosedLoop = ClosedPath
                        self.IsClosed = ClosedPath
                    }
                    BoolCell.backgroundColor = CellBackground(For: Order)
                    Results.append((BooleanCell2.CellHeight, BoolCell))
                    
                case 3:
                    let SegNames = ["None", "8", "16", "32", "64"]
                    let SegCell = SegmentCell(style: .default, reuseIdentifier: "SegmentCell")
                    SegCell.LoadCell(Title: "Snap to grid",
                                     Names: SegNames,
                                     Width: Width,
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
                    SegCell.backgroundColor = CellBackground(For: Order)
                    Results.append((SegmentCell.CellHeight, SegCell))
                    
                case 4:
                    let BCell = ButtonCell(style: .default, reuseIdentifier: "ButtonCell")
                    BCell.LoadCell(Header: "Clone as copy", Title: "Copy",
                                        Width: Width)
                    {
                        print("Current shape cloned")
                    }
                    BCell.backgroundColor = CellBackground(For: Order)
                    Results.append((ButtonCell.CellHeight, BCell))
                    
                case 5:
                    let BCell = ButtonCell(style: .default, reuseIdentifier: "ButtonCell")
                    BCell.LoadCell(Header: "Center in viewport", Title: "Center",
                                        Width: Width)
                    {
                        self.EditSurface.CenterShapeInCanvas()
                    }
                    BCell.backgroundColor = CellBackground(For: Order)
                    Results.append((ButtonCell.CellHeight, BCell))
                    
                case 6:
                    let BoolCell = BooleanCell2(style: .default, reuseIdentifier: "BooleanCell2")
                    BoolCell.LoadCell(InitialValue: Settings.GetBool(.ScaleToView),
                                      Header: "Scale viewport", Width: Width)
                    {
                        DoScale in
                        Settings.SetBool(.ScaleToView, DoScale)
                        self.EditSurface.ScaleUserShape(DoScale)
                    }
                    BoolCell.backgroundColor = CellBackground(For: Order)
                    Results.append((BooleanCell2.CellHeight, BoolCell))
                    
                case 7:
                    let BoolCell = BooleanCell2(style: .default, reuseIdentifier: "BooleanCell2")
                    BoolCell.LoadCell(InitialValue: Settings.GetBool(.ShowViewport),
                                      Header: "Show viewport", Width: Width)
                    {
                        ShowViewport in
                        Settings.SetBool(.ShowViewport, ShowViewport)
                        self.EditSurface.SetViewportBorder(Visible: ShowViewport)
                    }
                    BoolCell.backgroundColor = CellBackground(For: Order)
                    Results.append((BooleanCell2.CellHeight, BoolCell))
                    
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
                                     Width: Width,
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
                    SegCell.backgroundColor = CellBackground(For: Order)
                    Results.append((SegmentCell.CellHeight, SegCell))
                    
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
                                     Width: Width,
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
                    SegCell.backgroundColor = CellBackground(For: Order)
                    Results.append((SegmentCell.CellHeight, SegCell))
                    
                default:
                    Debug.FatalError("Unexpected index (\(CellIndex)) for creating option table view cells.")
            }
            Order = Order + 1
        }
        
        return Results
    }
    
    func CellBackground(For Multiple: Int) -> UIColor
    {
        return Multiple.isMultiple(of: 2) ? UIColor(named: "OptionsColor0")! : UIColor(named: "OptionsColor1")!
    }
}
