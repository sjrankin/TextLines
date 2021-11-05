//
//  SegmentCell.swift
//  TextLine
//
//  Created by Stuart Rankin on 9/16/21.
//

import Foundation
import UIKit

typealias SegmentAction = (Int) -> ()

class SegmentCell: UITableViewCell, CellProtocol
{
    func SetWidth(_ Width: CGFloat)
    {
        CurrentWidth = Width > 1000.0 ? 1000.0 : Width
        let SFrame = CGRect(x: 15,
                            y: 40,
                            width: CurrentWidth - 30,
                            height: 25)
        Segment.frame = SFrame
        AdjustedWidth = Width
    }
    
    var AdjustedWidth: CGFloat = 0.0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        InitializeUI()
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    func InitializeUI()
    {
        self.selectionStyle = .none
        HeaderLabel = UILabel(frame: CGRect(x: 15, y: 5, width: 300, height: 30))
        HeaderLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        HeaderLabel.textColor = UIColor.black
        contentView.addSubview(HeaderLabel)
    }
    
    public static var CellHeight: CGFloat
    {
        get
        {
            return 80
        }
    }
    
    func LoadCell(Title: String, Images: [UIImage], Width: CGFloat,
                  InitialIndex: Int = 0, Action: @escaping SegmentAction)
    {
        HeaderLabel.text = Title
        CurrentWidth = Width > 300.0 ? 300.0 : Width
        Segment = UISegmentedControl(items: Images)
        UsesImages = true
        SetSegmentAction(Action)
        Segment.addTarget(self, action: #selector(RunSegmentAction),
                          for: .valueChanged)
        InitializeControl()
        Segment.sendActions(for: UIControl.Event.valueChanged)
        if InitialIndex < Segment.numberOfSegments
        {
            Segment.selectedSegmentIndex = InitialIndex
        }
        contentView.addSubview(Segment!)
    }
    
    var UsesImages = false
    
    var ImageList = [UIImage]()
    
    func LoadCell(Title: String, Names: [String], Width: CGFloat,
                  InitialIndex: Int = 0, Action: @escaping SegmentAction)
    {
        PassedInitialIndex = InitialIndex
        HeaderLabel.text = Title
        CurrentWidth = Width > 300.0 ? 300.0 : Width
        Segment = UISegmentedControl(items: Names)
        SetSegmentAction(Action)
        Segment.addTarget(self, action: #selector(RunSegmentAction), for: .valueChanged)
        InitializeControl()
        Segment.sendActions(for: UIControl.Event.valueChanged)
        if InitialIndex < Segment.numberOfSegments
        {
            Segment.selectedSegmentIndex = InitialIndex
        }
        contentView.addSubview(Segment!)
    }
    
    var PassedInitialIndex: Int = 0
    var SegmentNames = [String]()
    
    func InitializeControl()
    {
        let SFrame = CGRect(x: 15, y: 40,
                            width: CurrentWidth - 30,
                            height: 25)
        Segment?.frame = SFrame
    }
    
    @objc func RunSegmentAction()
    {
        guard let SegmentControl = Segment else
        {
            return
        }
        let Index = SegmentControl.selectedSegmentIndex
        PressAction?(Index)
    }
    
    func SetSegmentAction(_ Action: @escaping SegmentAction)
    {
        PressAction = Action
    }
    
    var PressAction: SegmentAction? = nil
    var HeaderLabel: UILabel!
    var Segment: UISegmentedControl!
    var CurrentWidth: CGFloat = 0.0
}
