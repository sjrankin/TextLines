//
//  ShapeManager.swift
//  TextLine
//
//  Created by Stuart Rankin on 9/30/21.
//

import Foundation
import UIKit

class ShapeManager: UIViewController, UITableViewDelegate, UITableViewDataSource,
                    ShapeManagerDelegate
{
    override func viewDidLoad()
    {
        UserShapesTable.layer.borderWidth = 0.5
        UserShapesTable.layer.borderColor = UIColor.gray.cgColor
        UserShapesTable.layer.cornerRadius = 5.0
        
        UserShapeManager.LoadUserShapes()
        UserShapeList = UserShapeManager.UserShapeList
        let PreviouslySelected = Settings.GetUUID(.CurrentUserShape, UUID.Empty)
        SelectedShape = nil
        for Index in 0 ..< UserShapeList.count
        {
            if UserShapeList[Index].ID == PreviouslySelected
            {
                SelectedShape = UserShapeList[Index].ID
                break
            }
        }
        PreloadThumbnailCache()
        UserShapesTable.reloadData()
    }
    
    var ThumbnailCache = [UUID: UIImage]()
    var UserShapeList = [UserDefinedShape]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return UserShapeList.count
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
    /// - Returns: Thumbnail image of the shape.
    @discardableResult func GenerateThumbnail(From Shape: UserDefinedShape) -> UIImage
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
            ImageView.OriginalPoints = OffsetPoints
            ImageView.SetSmoothing(On: Shape.SmoothLines)
            ImageView.ClosePath = Shape.ClosedLoop
            ImageView.backgroundColor = UIColor.yellow
            ImageView.Redraw()
            Thumbnail = ImageView.RenderToImage()
            AddToImageCache(ID: Shape.ID, Image: Thumbnail)
        }
        return Thumbnail
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let Cell = UserShapeCell(style: .default, reuseIdentifier: "UserShapeCell")
        var Name = UserShapeList[indexPath.row].Name
        if Name.isEmpty
        {
            Name = "no name"
        }
        guard let Thumbnail = GetCachedImage(ID: UserShapeList[indexPath.row].ID) else
        {
            Debug.FatalError("Error retrieving thumbnail")
        }
        Cell.LoadCell(Header: Name, Title: "Edit", Width: tableView.frame.width,
                      Image: Thumbnail)
        {
            self.RunShapeEditor(ForShape: self.UserShapeList[indexPath.row].ID)
        }
        Cell.SelectShape(false)
        if let SelectedShapeID = SelectedShape
        {
            if UserShapeList[indexPath.row].ID == SelectedShapeID
            {
                Cell.SelectShape(true)
            }
        }
        let BGColor = indexPath.row.isMultiple(of: 2) ? UIColor(named: "OptionsColor0")! :
                                                        UIColor(named: "OptionsColor1")!
        Cell.backgroundColor = BGColor
        return Cell
    }
    
    /// Pre-load all of the thumbnails from the existing user-defined shapes.
    func PreloadThumbnailCache()
    {
        for SomeShape in UserShapeList
        {
            let ShapeID = SomeShape.ID
           if let ActualShape = GetUserShape(From: ShapeID)
            {
               GenerateThumbnail(From: ActualShape)
           }
        }
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return !UserShapeList[indexPath.row].Predefined
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
    {
        if UserShapeList[indexPath.row].Predefined
        {
            return UITableViewCell.EditingStyle.none
        }
        else
        {
            return UITableViewCell.EditingStyle.delete
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        UserShapeManager.SwapShapes(Index1: sourceIndexPath.row,
                                    Index2: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let DeletedID = UserShapeList[indexPath.row].ID
            UserShapeList.remove(at: indexPath.row)
            UserShapeManager.RemoveShape(With: DeletedID)
            RemoveImageFromCache(ID: DeletedID)
        }
        UserShapesTable.reloadData()
    }
    
    func RunShapeEditor(ForShape: UUID?, Action: ShapeManagerActions = .Edit)
    {
        CurrentAction = Action
        let Storyboard = UIStoryboard(name: "UserShapes", bundle: nil)
        let nextViewController = Storyboard.instantiateViewController(withIdentifier: "ShapeEditor") as! ShapeEditor
        nextViewController.ShapeID = ForShape
        nextViewController.Delegate = self
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    @IBAction func RunNewShapeEditor(_ sender: Any)
    {
        RunShapeEditor(ForShape: nil, Action: .New)
    }
    
    var CurrentAction: ShapeManagerActions = .Edit
    
    //https://stackoverflow.com/questions/56435510/presenting-modal-in-ios-13-fullscreen
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil)
    {
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    var SelectedShape: UUID? = nil
    
    @IBAction func SelectButtonHandler(_ sender: Any)
    {
        let SelectedRow = UserShapesTable.indexPathForSelectedRow
        if let Selected = SelectedRow?.row
        {
            if Selected > -1
            {
                Settings.SetUUID(.CurrentUserShape, UserShapeList[Selected].ID)
                SelectedShape = UserShapeList[Selected].ID
                UserShapesTable.reloadData()
                UserShapesTable.selectRow(at: SelectedRow,
                                          animated: true,
                                          scrollPosition: UITableView.ScrollPosition.middle)
            }
        }
    }
    
    @IBAction func DoneButtonHandler(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func EditShapeTableContents(_ sender: Any)
    {
        CurrentlyEditing = !CurrentlyEditing
        NewButton.isEnabled = !CurrentlyEditing
        UseButton.isEnabled = !CurrentlyEditing
        EditButton.setTitle(CurrentlyEditing ? "Done" : "Edit", for: .normal)
        /*
        #if os(macOS)
        EditButton.setTitle(CurrentlyEditing ? "Done" : "Edit", for: .normal)
        #else
        if var Config = EditButton.configuration
        {
            Config.title = CurrentlyEditing ? "Done" : "Edit"
            //        let ButtonTitle = CurrentlyEditing ? "Done" : "Edit"
            //        EditButton.setTitle(ButtonTitle, for: .normal)
            EditButton.configuration = Config
        }
        #endif
         */
        EditButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        UserShapesTable.setEditing(CurrentlyEditing, animated: true)
    }
    
    var CurrentlyEditing = false
    
    func Done(ID: UUID?, TheShape: UserDefinedShape)
    {
        guard let EditID = ID else
        {
            Debug.Print("Unexpected ID passed.")
            return
        }
        if CurrentAction == .Edit
        {
            RemoveImageFromCache(ID: EditID)
            if let ItemIndex = UserShapeList.firstIndex(where: {$0.ID == EditID})
            {
                let _ = GenerateThumbnail(From: UserShapeList[ItemIndex])
            }
            UserShapeManager.UpdateShape(Updated: TheShape, AndSave: true)
            UserShapeList = UserShapeManager.UserShapeList
        }
        if CurrentAction == .New
        {
            let _ = GenerateThumbnail(From: TheShape)
            UserShapeManager.UpdateShape(Updated: TheShape, AndSave: true)
            UserShapeList = UserShapeManager.UserShapeList
        }

        UserShapesTable.reloadData()
    }
    
    func Canceled()
    {
        UserShapesTable.reloadData()
    }
    
    @IBOutlet weak var NewButton: UIButton!
    @IBOutlet weak var UseButton: UIButton!
    @IBOutlet weak var EditButton: UIButton!
    @IBOutlet weak var UserShapesTable: UITableView!
}

enum ShapeManagerActions
{
    case Edit
    case New
}
