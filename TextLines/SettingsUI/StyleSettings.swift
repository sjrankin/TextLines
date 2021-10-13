//
//  StyleSettings.swift
//  TextLine
//
//  Created by Stuart Rankin on 9/18/21.
//

import Foundation
import UIKit

class StyleSettings: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource,
UICollectionViewDelegate, UICollectionViewDataSource
{

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        StylePicker.layer.borderColor = UIColor.gray.cgColor
        StylePicker.layer.borderWidth = 0.5
        StylePicker.layer.cornerRadius = 5.0
        StylePicker.reloadAllComponents()
        let Name = Settings.GetString(.ActionIconName, "CogIcon")
        let NameIndex = IconNames.firstIndex(of: Name) ?? 0
        StylePicker.selectRow(NameIndex, inComponent: 0, animated: true)
        
        SampleScroller.layer.backgroundColor = UIColor.clear.cgColor
        SampleScroller.layer.borderWidth = 0.5
        SampleScroller.layer.cornerRadius = 5.0
        SampleScroller.layer.borderColor = UIColor.white.cgColor
        SampleView.layer.backgroundColor = UIColor.clear.cgColor
        
        SampleBarContainer.layer.backgroundColor = UIColor.black.cgColor
        SampleBarContainer.layer.borderWidth = 0.5
        SampleBarContainer.layer.borderColor = UIColor.white.cgColor
        SampleBarContainer.layer.cornerRadius = 5.0
        
        CommandPalette.layer.borderColor = UIColor.gray.cgColor
        CommandPalette.layer.borderWidth = 0.5
        CommandPalette.layer.cornerRadius = 5.0
        
        LoadIconSets()
        LoadSampleCommandView()
        LoadSamplePaletteView()
    }
    
    // MARK: - Command palette and sample
    
    func LoadSamplePaletteView()
    {
        CommandPalette.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return CommandIcons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
        Cell.addSubview(CommandIcons[indexPath.row])
        return Cell
    }
    
    func LoadSampleCommandView()
    {
        for SView in SampleBarContainer.subviews
        {
            SView.removeFromSuperview()
        }
        var Index = 0
        print("CurrentCommandIcons.count=\(CurrentCommandIcons.count)")
        for Icon in CurrentCommandIcons
        {
            SampleBarContainer.insertSubview(Icon, at: Index)
            Index = Index + 1
        }
    }
    
    var StartPosition: CGFloat = 10.0
    
    /// Titled icons for the sample bar.
    func MakeSampleBarIcon(Index: Int, _ Name: String, Title: String, Type: ImageTypes = .Normal,
                        ReadOnly: Bool = false) -> TitledImage
    {
        let Start = StartPosition + ((50.0 + StartPosition) * CGFloat(Index))
        let IconFrame = CGRect(origin: CGPoint(x: Start, y: 4),
                               size: CGSize(width: 80, height: 80))
        print("IconFrame[\(Title)]=\(IconFrame)")
        let ImageBlock = TitledImage(ImageName: Name,
                                     ImageType: Type,
                                     Frame: IconFrame,
                                     Title: Title,
                                     TitleColor: UIColor.white,
                                     Background: UIColor.clear,
                                     ID: Title)
        {
            ID in
            if let RawID = ID
            {
                if let FinalID = RawID as? String
                {
                    print("\(FinalID) tapped")
                }
            }
        }
        ImageBlock.IsReadOnly = ReadOnly
        return ImageBlock
    }
    
    /// Titled icons for the collection view.
    func MakeIconPaletteIcon(_ Name: String, Title: String, Type: ImageTypes = .Normal,
                        ReadOnly: Bool = false) -> TitledImageUI
    {
        let IconFrame = CGRect(origin: CGPoint(x: 0, y: 0),
                               size: CGSize(width: 80, height: 80))
        print("IconFrame[\(Title)]=\(IconFrame)")
        let ImageBlock = TitledImageUI(frame: IconFrame,
                                       Image: Name,
                                       Title: Title,
                                       ImageType: Type,
                                       ID: Title)
        {
            ID in
            if let RawID = ID
            {
                if let FinalID = RawID as? String
                {
                    print("\(FinalID) tapped")
                }
            }
        }
        
        ImageBlock.IsReadOnly = ReadOnly
        return ImageBlock
    }
    
    var SampleBlocks = [TitledImage]()
    

    
    var CurrentCommandIcons: [TitledImage] = [TitledImage]()
    var CommandIcons: [TitledImageUI] = [TitledImageUI]()
    
    func LoadIconSets()
    {
        // Command sample bar
        let NewIcon = MakeSampleBarIcon(Index: 0,
                                     Settings.GetString(.ActionIconName, "CogIcon"),
                                     Title: "Action",
                                     Type: .SVG,
                                     ReadOnly: true)
        if CurrentCommandIcons.count > 0
        {
            CurrentCommandIcons.remove(at: 0)
            CurrentCommandIcons.insert(NewIcon, at: 0)
        }
        else
        {
            CurrentCommandIcons.append(NewIcon)
        }
        LoadSampleCommandView()
        
        // All commands palette
        
        let ActionIcon = MakeIconPaletteIcon(Settings.GetString(.ActionIconName, "CogIcon"),
                                        Title: "Action",
                                        Type: .SVG,
                                        ReadOnly: true)
        let ProjectIcon = MakeIconPaletteIcon("square.3.stack.3d",
                                        Title: "Project",
                                        Type: .System,
                                        ReadOnly: false)
        let CameraIcon = MakeIconPaletteIcon("camera",
                                        Title: "Camera",
                                        Type: .System,
                                        ReadOnly: false)
        let VideoCameraIcon = MakeIconPaletteIcon("VideoCamera",
                                        Title: "Movie",
                                        Type: .SVG,
                                        ReadOnly: false)
        let SaveIcon = MakeIconPaletteIcon("square.and.arrow.down",
                                      Title: "Save",
                                      Type: .System,
                                      ReadOnly: false)
        let ShareIcon = MakeIconPaletteIcon("square.and.arrow.up",
                                       Title: "Share",
                                       Type: .System,
                                       ReadOnly: false)
        let FontIcon = MakeIconPaletteIcon("textformat.abc",
                                      Title: "Font",
                                      Type: .System,
                                      ReadOnly: false)
        let AnimationIcon = MakeIconPaletteIcon("play",
                                           Title: "Animate",
                                           Type: .System,
                                           ReadOnly: false)
        CommandIcons.append(ActionIcon) //MUST always be in position 0.
        CommandIcons.append(ProjectIcon)
        CommandIcons.append(CameraIcon)
        CommandIcons.append(VideoCameraIcon)
        CommandIcons.append(SaveIcon)
        CommandIcons.append(ShareIcon)
        CommandIcons.append(FontIcon)
        CommandIcons.append(AnimationIcon)
        LoadSamplePaletteView()
    }
    
    // MARK: - Action button
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return IconNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let View = UIImageView()
        View.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 64, height: 64))
        let Icon = UIImage(named: IconNames[row])
        View.image = Icon
        return View
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return 70
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        Settings.SetString(.ActionIconName, IconNames[row])
        if CurrentCommandIcons.count > 0
        {
            let Count = SampleBarContainer.subviews.count
            if Count == 0
            {
                LoadSampleCommandView()
            }
            else
            {
                let NewIcon = MakeSampleBarIcon(Index: 0, IconNames[row], Title: "Action",
                                             Type: .SVG, ReadOnly: true)
                CurrentCommandIcons[0] = NewIcon
               LoadSampleCommandView()
            }
        }
    }
    
    let IconNames = ["CogIcon", "ThreeDotsInCircleIcon", "WrenchInCircleIcon",
                     "StarIcon", "SolidStarIcon", "StarInCircleIcon", "MoonIcon", "HotSpringsIcon",
                     "HeartIcon", "CatIcon", "DogIcon", "BirdIcon", "DragonIcon", "LightBulbIcon"]

    @IBOutlet weak var SampleScroller: UIScrollView!
    @IBOutlet weak var SampleView: UIView!
    @IBOutlet weak var CommandPalette: UICollectionView!
    @IBOutlet weak var StylePicker: UIPickerView!
    @IBOutlet weak var SampleBarContainer: UIView!
}

