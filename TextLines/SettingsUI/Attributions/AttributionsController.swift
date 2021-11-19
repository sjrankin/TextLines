//
//  AttributionsController.swift
//  AttributionsController
//
//  Created by Stuart Rankin on 9/2/21.
//

import Foundation
import UIKit

class AttibutionsController: UIViewController, UITableViewDelegate, UITableViewDataSource,
                             AttributesProtocol
{
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        LocalAttributions = Attributions.sorted(by: {$0.Title < $1.Title})
        AttributionTable.layer.borderWidth = 0.5
        AttributionTable.layer.borderColor = UIColor.systemGray.cgColor
        AttributionTable.layer.cornerRadius = 5.0
        AttributionTable.reloadData()
        LinkText.layer.borderWidth = 0.5
        LinkText.layer.borderColor = UIColor.systemRed.cgColor
        LinkText.layer.cornerRadius = 5.0
    }
    
    var LocalAttributions: [Attribution]? = nil
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("Attributions.count=\(LocalAttributions!.count)")
        return LocalAttributions!.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return AttributionCell.CellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let Title = LocalAttributions![indexPath.row].Title
        let Text = LocalAttributions![indexPath.row].Text
        let Cell = AttributionCell(style: .default, reuseIdentifier: "AttributionCell")
        if LocalAttributions![indexPath.row].SeparateView
        {
            Cell.LoadCell(Header: Title, SubHeader: "License Agreement",
                          Width: AttributionTable.frame.width,
                          IsLink: false)
            Cell.selectionStyle = .default
            Cell.accessoryType = .disclosureIndicator
        }
        else
        {
            Cell.LoadCell(Header: Title, SubHeader: Text,
                          Width: AttributionTable.frame.width,
                          IsLink: true)
        }
        Cell.backgroundColor = CellCount.isMultiple(of: 2) ? UIColor.systemGray5 : UIColor.systemGray6
        CellCount = CellCount + 1
        return Cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        SelectedRow = indexPath.row
        if LocalAttributions![SelectedRow!].SeparateView
        {
            let Storyboard = UIStoryboard(name: "SettingsUI", bundle: nil)
            let Controller = Storyboard.instantiateViewController(withIdentifier: "BigAttributes") as! BigAttributes
            Controller.delegate = self
            self.present(Controller, animated: true, completion: nil)
        }
        else
        {
            if let url = URL(string: LocalAttributions![SelectedRow!].Link)
            {
                UIApplication.shared.open(url)
            }
        }
    }
    
    var SelectedRow: Int? = nil
    var CellCount = 0
    
    func GetTitle() -> String
    {
        if let SelectedRow = SelectedRow
        {
            if LocalAttributions![SelectedRow].SeparateView
            {
                return LocalAttributions![SelectedRow].Title
            }
        }
        return ""
    }
    
    func GetText() -> String
    {
        if let SelectedRow = SelectedRow
        {
            if LocalAttributions![SelectedRow].SeparateView
            {
                return LocalAttributions![SelectedRow].Text
            }
        }
        return ""
    }
    
    let Attributions: [Attribution] =
    [
        Attribution(Link: "https://medium.com/@avinapaner/converting-cgcolor-from-gray-spaces-to-rgb-spaces-coregraphics-ed49faecfc7f",
                    Text: "Converting CGColor from Grayspace.",
                    Title: "Grayscale to Color"),
        Attribution(Link: "https://stackoverflow.com/questions/20323180/interpolating-gradient-colors-as-with-nsgradient-on-ios",
                    Text: "Interpolating gradient colors",
                    Title: "Gradient Colors"),
        Attribution(Link: "https://en.wikipedia.org/wiki/YUV",
                    Text: "YUV Colorspace",
                    Title: "YUV"),
        Attribution(Link: "http://www.fourcc.org/fccyvrgb.php",
                    Text: "FourCC YUV to RGB Conversion",
                    Title: "FourCC"),
        Attribution(Link: "https://www.resene.co.nz/swatches/preview.php?chart=Resene%20Multi-finish%20range%20%282016%29&brand=Resene&name=Space%20Cadet",
                    Text: "Resene Space Cadet Color",
                    Title: "Resene Space Cadet"),
        Attribution(Link: "https://stackoverflow.com/questions/27092354/rotating-uiimage-in-swift/47402811#47402811",
                    Text: "Image rotation in iOS",
                    Title: "Image Rotation"),
        Attribution(Link: "https://stackoverflow.com/questions/31699235/rotate-UIImage-in-swift-cocoa-mac-osx",
                    Text: "Image rotation in macOS",
                    Title: "Image Rotation"),
        Attribution(Link: "https://stackoverflow.com/questions/28517866/how-to-set-the-alpha-of-an-uiimage-in-swift-programmatically",
                    Text: "Set opacity of image",
                    Title: "Image Opacity"),
        Attribution(Link: "https://stackoverflow.com/questions/3038820/how-to-save-a-UIImage-as-a-new-file",
                    Text: "How to save an UIImage as a file.",
                    Title: "Save UIImage"),
        Attribution(Link: "https://bluelemonbits.com/2019/12/30/creating-a-collage-by-combining-an-array-of-images-macos-ios/",
                    Text: "Create collage of images",
                    Title: "Collage Creation"),
        Attribution(Link: "https://github.com/apple/swift/blob/master/docs/ABI/Mangling.rst",
                    Text: "Type name demangling.",
                    Title: "Name Demangling"),
        Attribution(Link: "https://stackoverflow.com/questions/1324379/how-to-calculate-the-width-of-a-text-string-of-a-specific-font-and-font-size",
                    Text: "Calculate width of string",
                    Title: "Width of String"),
        Attribution(Link: "https://stackoverflow.com/questions/38395003/how-to-change-color-of-svg-images-in-ios",
                    Text: "Change color of SVG shapes in iOS",
                    Title: "SVG Colors"),
        Attribution(Link: "https://math.stackexchange.com/questions/925677/can-anyone-give-me-x-y-coordinates-for-an-octagon",
                    Text: "Generate octagon from points.",
                    Title: "Octagon Generation"),
        Attribution(Link: "https://kaushalelsewhere.medium.com/how-to-dismiss-keyboard-in-a-view-controller-of-ios-3b1bfe973ad1",
                    Text: "Dismiss keyboard in a ViewController.",
                    Title: "Dismiss Keyboard"),
        Attribution(Link: "https://stackoverflow.com/questions/38793536/possible-to-pass-an-enum-type-name-as-an-argument-in-swift",
                    Text: "Pass an enum type name",
                    Title: "Pass Enum Type"),
        Attribution(Link: "https://stackoverflow.com/questions/32771864/draw-text-along-circular-path-in-swift-for-ios",
                    Text: "Draw text along circular path in Swift for iOS",
                    Title: "Draw Text on Circle"),
        Attribution(Link: "https://github.com/mabdulsubhan/UIBezierPath-Spiral/blob/master/UIBezierPath%2BSpiral.swift",
                    Text: "Draw text on spiral Bezier curve",
                    Title: "Spiral Bezier Curve"),
        Attribution(Link: "https://github.com/ZevEisenberg/ZESpiral",
                    Text: "Swift conversion of ZESpiral",
                    Title: "ZESpiral to Swift"),
        Attribution(Link: "https://www.mathsisfun.com/geometry/ellipse-perimeter.html",
                    Text: "Calculate the perimeter of an ellipse",
                    Title: "Ellipse Perimeter"),
        Attribution(Link: "https://github.com/louisdh/bezierpath-length/tree/master/Source",
                    Text: "Calculate the length of a Bezier curve",
                    Title: "Bezier Curve Length"),
        Attribution(Link: "https://stackoverflow.com/questions/36702853/get-the-start-point-of-a-uibezierpath",
                    Text: "Calculate starting point of Bezier curve",
                    Title: "Bezier Curve Starting Point"),
        Attribution(Link: "http://pomax.github.io/bezierinfo/legendre-gauss.html",
                    Text: "Gaussian quadrature weights and abscissae",
                    Title: "Weights and Abscissae"),
        Attribution(Link: "",
                    Text:
"""
BezierString.swift

Created by Luka on 23. 11. 14.
Copyright (c) 2014 lvnyk

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
""",
                    Title: "Bezier String",
                    SeparateView: true),
        Attribution(Link: "",
                    Text:
"""
Geometry.swift

Created by Luka on 27. 08. 14.
Copyright (c) 2014 lvnyk

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
""",
                    Title: "Geomety",
                    SeparateView: true),
        Attribution(Link: "",
                    Text:
"""
BezierPath.swift

Created by Luka on 26/12/15.
Copyright (c) 2015 lvnyk.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
""",
                    Title: "Bezier Path",
                    SeparateView: true),
        Attribution(Link: "https://fonts.google.com/icons?icon.category=toggle",
                    Text: "Glyphs from Google Material Icons font",
                    Title: "Material Icons"),
        Attribution(Link: "https://opensource.org/licenses/MIT",
                    Text: "Shapes icon: MIT License",
                    Title: "Shapes Icon"),
        Attribution(Link: "https://www.w3.org/WAI/ER/WD-AERT/#color-contrast",
                    Text: "Calculating color contrast",
                    Title: "Color Contrast"),
        Attribution(Link: "https://www.bit-101.com/blog/2021/08/chaikins-algorithm-drawing-curves/",
                    Text: "Chaikin's line smoothing algorithm",
                    Title: "Line Smoothing"),
        Attribution(Link: "https://stackoverflow.com/questions/29227858/how-to-draw-heart-shape-in-uiview-ios",
                    Text: "Drawing heart shapes in iOS",
                    Title: "Heart Shapes"),
        Attribution(Link: "https://fontlibrary.org/en/font/voynich",
                    Text: "Voynich Manuscript Font courtesy Glenn Claston, 2005, distributed in the public domain, corrected for UTF-8 by William Porquet",
                    Title: "Voynich Font",
                    SeparateView: true),
        Attribution(Link: "https://stackoverflow.com/questions/25649926/trying-to-animate-a-constraint-in-swift",
                    Text: "Animating constraints at run-time",
                    Title: "Animating Constraints"),
        Attribution(Link: "https://stackoverflow.com/questions/6064630/get-angle-from-2-positions",
                    Text: "Angle between two points",
                    Title: "Calculating Angles"),
        Attribution(Link: "https://stackoverflow.com/questions/25477093/difficulty-allowing-user-interaction-during-uiview-animation",
                    Text: "Interactions during animation",
                    Title: "Animation Interaction")
        // Above to 19 November 2021
    ]
    
    @IBOutlet weak var LinkText: UITextView!
    @IBOutlet weak var AttributionTable: UITableView!
    
}

class Attribution
{
    init(Link: String, Text: String, Title: String, SeparateView: Bool = false)
    {
        self.Link = Link
        self.Text = Text
        self.Title = Title
        self.SeparateView = SeparateView
    }
    
    var Link: String = ""
    var Text: String = ""
    var Title: String = ""
    var SeparateView: Bool = false
}
