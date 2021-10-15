//
//  UserShape.swift
//  TextLine
//
//  Created by Stuart Rankin on 9/30/21.
//

import Foundation
import UIKit

/// Code to allow the user to create lines and closed-loops on the fly.
class UserShape: UIView
{
    var ScaleFactor: CGFloat = 1.0
    var DrawToScale: Bool = true
    var ClosePath: Bool = true
    var SmoothedPoints: [CGPoint] = [CGPoint]()
    var OriginalPoints: [CGPoint] = [CGPoint]()
    var EditMode: EditTypes = .Add
    var ShowPoints: Bool = false
    var InSmoothMode = false
    var CloseTap: Int? = nil
    var GridGap: Int = 0
    var MainLineWidth: CGFloat = 2.0
    var MainLineColor: UIColor = .systemBlue
    var ShowViewportBorder: Bool = false
    var CurrentViewport: CGRect = CGRect(origin: .zero,
                                         size: CGSize(width: 1000, height: 1000))
    var FinalFrame: CGRect = .zero
    
    /// Initialize the class.
    /// - Parameter ReadOnly: If true, taps will be disabled.
    func Initialize(ReadOnly: Bool = false)
    {
        self.clipsToBounds = true
        
        let Pan = UIPanGestureRecognizer(target: self, action: #selector(HandlePan))
        Pan.minimumNumberOfTouches = 1
        self.addGestureRecognizer(Pan)
        let Tap = UITapGestureRecognizer(target: self, action: #selector(HandleTap))
        Tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(Tap)
        ScaleFactor = CalculateScale()
        DrawTapView()
    }
    
    /// Set the additive offset for each point.
    /// - Notes:
    ///    - Offsets are applied at render time. **This function does not render the shape.**
    ///    - All smoothed points are removed. Smoothing must be executed again if the user so
    ///      desires it.
    ///    - Points are updated on this call. To under the offset, callers must keep track of
    ///      values passed here and apply the inverse.
    /// - Parameter NewOffset: The offset value (in the form of a `CGPoint`) to apply
    ///                        to each point.
    func SetPointOffset(_ NewOffset: CGPoint)
    {
        var OffsetPoints = [CGPoint]()
        for Point in OriginalPoints
        {
            OffsetPoints.append(CGPoint(x: Point.x + NewOffset.x,
                                        y: Point.y + NewOffset.y))
        }
        OriginalPoints = OffsetPoints
        SmoothedPoints.removeAll()
    }
    
    /// Resize the canvas to fit the size of the current shape.
    /// - Notes:
    ///    - All smoothed points are removed. Smoothing must be executed again if the user so
    ///      desires it.
    ///    - All points have their values changed to fit into the canvas. The shape and size of
    ///      the shape will be identical - it will just be in a different location.
    ///    - The frame of the `UIView` is set according to the size of the shape plus passed border.
    /// - Parameter Border: Number of pixels on each side to act as a border/keep-out.
    ///                     Defaults to `20`.
    func FitCanvasToShape(Border: CGFloat = 20)
    {
        if OriginalPoints.isEmpty
        {
            return
        }
        let (UL, LR) = Utility.GetExtent(Points: OriginalPoints)!
        let ShapeWidth = (LR.x - UL.x) + 40
        let ShapeHeight = (LR.y - UL.y) + 40
        let XOffset: CGFloat = 20
        let YOffset: CGFloat = 20
        var OffsetPoints = [CGPoint]()
        for Point in OriginalPoints
        {
            let NewPoint = CGPoint(x: Point.x - UL.x + XOffset,
                                   y: Point.y - UL.y + YOffset)
            OffsetPoints.append(NewPoint)
        }
        OriginalPoints = OffsetPoints
        SmoothedPoints.removeAll()
        self.frame = CGRect(origin: .zero,
                            size: CGSize(width: ShapeWidth, height: ShapeHeight))
    }
    
    /// Change the location of the user shape such that it is centered in the current
    /// canvas.
    /// - Notes:
    ///    - It is possible the shape may be drawn out of the bounds of the canvas after
    ///      calling this function.
    ///    - All smoothed points are removed. Smoothing must be executed again if the user so
    ///      desires it.
    ///    - If there are no user points, no action is taken.
    func CenterShapeInCanvas()
    {
        if OriginalPoints.isEmpty
        {
            return
        }
        let Center = ShapeCenter()!
        let CanvasCenter = CGPoint(x: self.frame.size.width / 2,
                                   y: self.frame.size.height / 2)
        let DeltaX = CanvasCenter.x - Center.x
        let DeltaY = CanvasCenter.y - Center.y
        var CenteredPoints = [CGPoint]()
        for Point in OriginalPoints
        {
            CenteredPoints.append(CGPoint(x: Point.x + DeltaX,
                                          y: Point.y + DeltaY))
        }
        SmoothedPoints.removeAll()
        OriginalPoints = CenteredPoints
        DrawTapView()
    }
    
    /// Returns the spatial center of the user shape. `OriginalPoints` is used to determine the center.
    /// - Returns: Center of the shape as currently constituted. `Nil` is there are no points in `OriginalPoints`.
    func ShapeCenter() -> CGPoint?
    {
        if OriginalPoints.isEmpty
        {
            return nil
        }
        let (UL, LR) = Utility.GetExtent(Points: OriginalPoints)!
        var CenterX = LR.x - UL.x
        CenterX = (CenterX / 2) + UL.x
        var CenterY = LR.y - UL.y
        CenterY = (CenterY / 2) + UL.y
        return CGPoint(x: CenterX, y: CenterY)
    }

    /// Change the canvas size (eg, drawing area) of the shape.
    /// - Note: Points are unaffected by this call so the shape may end up being drawn
    ///          off canvas (eg, not visible).
    /// - Parameter NewSize: The new size of the canvas.
    func ChangeCanvasSize(NewSize: CGSize)
    {
        self.frame = CGRect(origin: .zero,
                            size: CGSize(width: NewSize.width, height: NewSize.height))
    }
    
    /// Render the current user shape to an image.
    /// - Returns: UIImage of the current user shape, rendered with all current
    ///            settings in force.
    func RenderToImage() -> UIImage
    {
        let RenderBounds = CGRect(origin: .zero, size: CGSize(width: 1024, height: 1024))//Size)
        let OldGridGap = GridGap
        GridGap = 0
        let OldLineWidth = MainLineWidth
        MainLineWidth = 10.0
        let OldLineColor = MainLineColor
        MainLineColor = UIColor.black
        let OldShowPoints = ShowPoints
        
        DrawTapView()
        let renderer = UIGraphicsImageRenderer(size: RenderBounds.size)
        let image = renderer.image
        {
            ctx in
            self.drawHierarchy(in: RenderBounds, afterScreenUpdates: true)
        }
        
        GridGap = OldGridGap
        MainLineWidth = OldLineWidth
        MainLineColor = OldLineColor
        ShowPoints = OldShowPoints
        
        return image
    }
    
    /// Convenience function for callers to force a redraw.
    func Redraw()
    {
        DrawTapView()
    }
    
    /// Returns a string representing a `UIGestureRecognizer.State` value.
    /// - Returns: String representation of a `UIGestureRecognizer.State` value.
    func MakePrettyState(_ State: UIGestureRecognizer.State) -> String
    {
        switch State
        {
            case .ended:
                return "ended"
                
            case .changed:
                return "changed"
                
            case .began:
                return "began"
                
            case .cancelled:
                return "cancelled"
                
            case .failed:
                return "failed"
                
            case .possible:
                return "possible"
                
            @unknown default:
                return "unknown"
        }
    }
    
    // MARK: - Gesture functions.
    
    /// Handle pan gestures. Depending on the state of `LineType`, either existing points will
    /// be moved or a free-form line will be drawn.
    /// - Parameter Recognizer: The gesture recognizer.
    @objc func HandlePan(_ Recognizer: UIPanGestureRecognizer)
    {
        if EditMode != .Move
        {
            Recognizer.CancelRecognizer()
            return
        }
        let Location = Recognizer.location(in: self)
        switch Recognizer.state
        {
            case .began:
                let Closest = ClosestPoint(To: Location)
                if Closest.Distance <= 20
                {
                    CloseTap = Closest.Index
                }
                else
                {
                    CloseTap = nil
                    Recognizer.CancelRecognizer()
                }
                
            case .changed, .ended:
                OriginalPoints[CloseTap!] = Location
                
            default:
                return
        }
        DrawTapView()
    }
    
    /// Handle individual taps. `EditMode` controls the action taken when the user
    /// taps the screen.
    /// - Parameter Recognizer: The gesture recognizer.
    @objc func HandleTap(_ Recognizer: UITapGestureRecognizer)
    {
        var Location = Recognizer.location(in: self)
        Location = CGPoint(x: Int(Location.x), y: Int(Location.y))
        CloseTap = nil
        switch EditMode
        {
            case .Add:
                if GridGap > 0
                {
                    AddConstrainedPoint(Location)
                }
                else
                {
                    OriginalPoints.append(Location)
                }
                
            case .Delete:
                let Closest = ClosestPoint(To: Location)
                if Closest.Distance <= 10
                {
                    OriginalPoints.remove(at: Closest.Index)
                }
                
            default:
                break
        }
        DrawTapView()
    }
    
    /// Add the passed location to the set of original points after being constrained to the
    /// nearest grid intersection.
    /// - Parameter Location: The location to add.
    func AddConstrainedPoint(_ Location: CGPoint)
    {
        let Gap = CGFloat(GridGap)
        let XBase = Int(Location.x / Gap) * GridGap
        let XOver = fmod(Location.x, Gap)
        let XAdjustment = XOver < 0.5 ? 0.0 : 1.0
        let FinalX = CGFloat(XBase) + XAdjustment
        
        let YBase = Int(Location.y / Gap) * GridGap
        let YOver = fmod(Location.y, Gap)
        let YAdjustment = YOver < 0.5 ? 0.0 : 1.0
        let FinalY = CGFloat(YBase) + YAdjustment
        
        OriginalPoints.append(CGPoint(x: FinalX, y: FinalY))
    }
    
    /// Returns the distance between two points in 2D space.
    /// - Parameter P1: First point.
    /// - Parameter P2: Second point.
    /// - Returns: Distance between `P1` and `P2`.
    func Distance(_ P1: CGPoint, _ P2: CGPoint) -> CGFloat
    {
        let Dx = P1.x - P2.x
        let Dy = P1.y - P2.y
        let Dx2 = Dx * Dx
        let Dy2 = Dy * Dy
        return sqrt(Dx2 + Dy2)
    }
    
    /// Returns the point in `OriginalPoints` that is closest to the passed point.
    /// - Parameter To: The point used to determine the closest point returned.
    /// - Returns: Tuple of the index of the closest point and the distance to the
    ///            closest point. If two points have the same closest distance, the
    ///            first point encountered will be returned.
    func ClosestPoint(To: CGPoint) -> (Index: Int, Distance: CGFloat)
    {
        var ClosestIndex = -1
        var PointDistance: CGFloat = CGFloat.greatestFiniteMagnitude
        for Index in 0 ..< OriginalPoints.count
        {
            let D = Distance(To, OriginalPoints[Index])
            if D < PointDistance
            {
                PointDistance = D
                ClosestIndex = Index
            }
        }
        return (ClosestIndex, PointDistance)
    }
    
    /// Show or hide the viewport border.
    /// - Parameter Visible: If true, the border of the viewport is shown. Otherwise,
    ///                      it is not drawn.
    func SetViewportBorder(Visible: Bool)
    {
        ShowViewportBorder = Visible
        DrawTapView()
    }
    
    /// Sets the final frame size of the surface.
    /// - Parameter The final frame size.
    func SetFinalFrame(_ Frame: CGRect)
    {
        FinalFrame = Frame
        ScaleFactor = CalculateScale()
    }
    
    /// Draw the shape to scale to fit into the available view.
    /// - Note: This has the effect of setting the viewport size such that it fits
    ///         in the current view.
    /// - Parameter DoScale: If true, drawing (and user interaction) is done to scale. If false,
    ///                      the native size is used.
    func ScaleUserShape(_ DoScale: Bool)
    {
        DrawToScale = DoScale
        ScaleFactor = CalculateScale()
        DrawTapView()
    }
    
    /// Calculate the scale factor for drawing (if `DrawToScale` is enabled).
    /// - Note: If `FinalFrame` was not set, `1.0` is returned.
    /// - Returns: The scale factor to use.
    func CalculateScale() -> CGFloat
    {
        if FinalFrame == .zero
        {
            return 1.0
        }
        let XScale = FinalFrame.width / CurrentViewport.width
        let YScale = FinalFrame.height / CurrentViewport.height
        let NewScale = XScale < YScale ? XScale : YScale
        return NewScale
    }
    
    /// Set the viewport for the user shape.
    /// - Parameter NewViewport: The new viewport to use.
    func SetViewport(_ NewViewport: CGRect)
    {
        CurrentViewport = NewViewport
        DrawTapView()
    }
    
    /// Draws the view by setting the needs display flag on the drawing surface. Sets
    /// parameters before drawing.
    func DrawTapView()
    {
        if InSmoothMode && !SmoothedPoints.isEmpty
        {
            WorkingPoints = SmoothedPoints
        }
        else
        {
            WorkingPoints = OriginalPoints
        }
        self.setNeedsDisplay()
    }
    
    // MARK: - Run-time parameter setting.
    
    /// Sets the smoothing flag.
    /// - Note:
    ///   - Calling this multiple times with `true` has no effect - the set of original points is
    ///     used on each call so there will be no changes after the first call.
    ///   - This function will redraw the view when called.
    /// - Parameter On: If true, smoothing is enabled. If false, original points are used. If the
    ///                 value passed is identical to the previous call's value, no action is taken.
    func SetSmoothing(On: Bool)
    {
        InSmoothMode = On
        if InSmoothMode
        {
            SmoothedPoints = Chaikin.SmoothPoints(Points: OriginalPoints, Iterations: 5, Closed: ClosePath)
        }
        ShowPoints = !On
        DrawTapView()
    }
    
    /// Clear all points in the view (both smoothed and original). Redraws the view.
    func ClearPoints()
    {
        OriginalPoints.removeAll()
        SmoothedPoints.removeAll()
        DrawTapView()
    }
    
    /// Sets the edit mode so users can delete points by tapping on them.
    /// - Parameter NewMode: If true, points can be deleted. If false, they cannot be
    ///                      deleted when tapped.
    func SetEditMode(_ NewMode: EditTypes)
    {
        EditMode = NewMode
    }
    
    /// Display a grid (and cause points to snap to grid intersections).
    /// - Parameter Size: The size between both horizontal and vertical grid lines. If
    ///                   this value is `0`, no grid lines are drawn.
    func SetGridVisibility(_ Size: Int)
    {
        GridGap = Size
        DrawTapView()
    }
    
    /// Draws closed loops rather than open lines. Redraws the view when called.
    /// - Parameter DoClose: If true, paths are closed (eg, loops). If false, paths
    ///                      are not logically closed and are considered open lines.
    func CloseUserPath(_ DoClose: Bool)
    {
        ClosePath = DoClose
        if !SmoothedPoints.isEmpty
        {
            SmoothedPoints = Chaikin.SmoothPoints(Points: WorkingPoints, Iterations: 5, Closed: ClosePath)
        }
        DrawTapView()
    }
    
    /// Get the extreme of the specified extent of the current path.
    /// - Parameter For: Determines which side of the extent to return.
    /// - Parameter WhenSmoothed: If true, the smoothed path will be used. Otherwise, the
    ///                           original path is used.
    /// - Returns: The extreme extent for the specified side of the path. Nil if `WhenSmoothed`
    ///            is true but no smoothed path is available.
    func GetLimit(For: LimitSides, WhenSmoothed: Bool) -> CGFloat?
    {
        if WhenSmoothed && SmoothedPoints.isEmpty
        {
            Debug.Print("Cannot return limits of smoothed points - no smoothed points available.")
            return nil
        }
        
        switch For
        {
            case .Top:
                return GetTopMost(In: WhenSmoothed ? SmoothedPoints : OriginalPoints)
                
            case .Left:
                return GetLeftMost(In: WhenSmoothed ? SmoothedPoints : OriginalPoints)
                
            case .Bottom:
                return GetBottomMost(In: WhenSmoothed ? SmoothedPoints : OriginalPoints)
                
            case .Right:
                return GetRightMost(In: WhenSmoothed ? SmoothedPoints : OriginalPoints)
        }
    }
    
    /// Returns the extent of the current path.
    /// - Parameter WhenSmoothed: If true, the smoothed path is used (if available). Otherwise,
    ///                           the original path is used.
    /// - Returns: Tuple of the upper-left and lower-right corners of the extent of the path. Nil return
    ///            if `WhenSmoothed` is true but no smoothed points are available.
    func GetPathLimits(WhenSmoothed: Bool) -> (CGPoint, CGPoint)?
    {
        if WhenSmoothed && SmoothedPoints.isEmpty
        {
            Debug.Print("Cannot return limits of smoothed points - no smoothed points available.")
            return nil
        }
        let Top = GetTopMost(In: WhenSmoothed ? SmoothedPoints : OriginalPoints)
        let Left = GetLeftMost(In: WhenSmoothed ? SmoothedPoints : OriginalPoints)
        let Bottom = GetBottomMost(In: WhenSmoothed ? SmoothedPoints : OriginalPoints)
        let Right = GetRightMost(In: WhenSmoothed ? SmoothedPoints : OriginalPoints)
        return (CGPoint(x: Left, y: Top), CGPoint(x: Right, y: Bottom))
    }
    
    /// Returns the left-most coordinate in the set of passed points.
    /// - Parameter In: The points to check for leftness.
    /// - Returns: The value of the left-most `x` coordinate.
    func GetLeftMost(In: [CGPoint]) -> CGFloat
    {
        var Leftest = CGFloat.greatestFiniteMagnitude
        for Point in In
        {
            if Point.x < Leftest
            {
                Leftest = Point.x
            }
        }
        return Leftest
    }
    
    /// Returns the top-most coordinate in the set of passed points.
    /// - Parameter In: The points to check for topness.
    /// - Returns: The value of the top-most `y` coordinate.
    func GetTopMost(In: [CGPoint]) -> CGFloat
    {
        var Topest = CGFloat.greatestFiniteMagnitude
        for Point in In
        {
            if Point.y < Topest
            {
                Topest = Point.y
            }
        }
        return Topest
    }
    
    /// Returns the bottom-most coordinate in the set of passed points.
    /// - Parameter In: The points to check for bottomness.
    /// - Returns: The value of the bottom-most `y` coordinate.
    func GetBottomMost(In: [CGPoint]) -> CGFloat
    {
        var Bottomest: CGFloat = -100000000
        for Point in In
        {
            if Point.y < Bottomest
            {
                Bottomest = Point.y
            }
        }
        return Bottomest
    }
    
    /// Returns the right-most coordinate in the set of passed points.
    /// - Parameter In: The points to check for rightness.
    /// - Returns: The value of the right-most `y` coordinate.
    func GetRightMost(In: [CGPoint]) -> CGFloat
    {
        var Rightest: CGFloat = -100000000
        for Point in In
        {
            if Point.x < Rightest
            {
                Rightest = Point.x
            }
        }
        return Rightest
    }
    
    /// Sorts all original points, starting at index `0` for spatial closeness. Once called,
    /// unless the caller has saved the points, the order is permanently changed. Redraws the
    /// view when called.
    func SortPoints()
    {
        if OriginalPoints.isEmpty
        {
            return
        }
        var Source = OriginalPoints
        var Closest = [CGPoint]()
        Closest.append(Source.removeFirst())
        while (!Source.isEmpty)
        {
            var MinDistance = CGFloat.greatestFiniteMagnitude
            var MinIndex = -1
            for Index in 0 ..< Source.count
            {
                let PDist = Distance(Closest.last!, Source[Index])
                if PDist < MinDistance
                {
                    MinDistance = PDist
                    MinIndex = Index
                }
            }
            Closest.append(Source[MinIndex])
            Source.remove(at: MinIndex)
        }
        OriginalPoints = Closest
        DrawTapView()
    }
    
    /// Remove the last point in the working points array. If there are points in
    /// the smoothed points array, refresh the array. Refresh the view.
    func RemoveLastPoint()
    {
        guard WorkingPoints.count > 0 else
        {
            return
        }
        WorkingPoints.removeLast()
        if SmoothedPoints.count > 0
        {
            SmoothedPoints = Chaikin.SmoothPoints(Points: WorkingPoints, Iterations: 5, Closed: ClosePath)
        }
        DrawTapView()
    }
    
    // MARK: - Rendering functions
    
    var WorkingPoints = [CGPoint]()
    
    /// Draw the view.
    /// - Note: If no points are available, no action is taken.
    /// - Parameter rect: The size of the view to draw.
    override func draw(_ rect: CGRect)
    {
        if GridGap > 0
        {
            let VLines = UIBezierPath()
            for H in stride(from: 0, to: rect.size.width, by: CGFloat.Stride(GridGap))
            {
                VLines.move(to: CGPoint(x: H, y: 0))
                VLines.addLine(to: CGPoint(x: H, y: rect.size.height))
            }
            VLines.lineWidth = 1.0
            UIColor.orange.setStroke()
            VLines.stroke()
            let HLines = UIBezierPath()
            for V in stride(from: 0, to: rect.size.height, by: CGFloat.Stride(GridGap))
            {
                HLines.move(to: CGPoint(x: 0, y: V))
                HLines.addLine(to: CGPoint(x: rect.size.width, y: V))
            }
            HLines.lineWidth = 1.0
            UIColor.orange.setStroke()
            HLines.stroke()
        }
        let ScaleToUse: CGFloat? = DrawToScale ? ScaleFactor : nil
        let SomeShape = UserShape.GenerateShape(WorkingPoints,
                                                ShowPoints: ShowPoints,
                                                ClosePath: ClosePath,
                                                MainLineWidth: MainLineWidth,
                                                MainLineColor: MainLineColor,
                                                ShowViewportBorder: ShowViewportBorder,
                                                Viewport: CurrentViewport,
                                                Scale: ScaleToUse)
        SomeShape.stroke()
    }
    
    /// Create a UIBezier path from the set of passed points.
    /// - Parameter Points: The set of points that will define the returned `UIBezierPath`.
    /// - Parameter ShowPoints: Determines if points are shown. Used for initial drawing and editing.
    /// - Parameter ClosePath: If true, the path is closed (eg, forms a loop).
    /// - Parameter MainLineWidth: The width of the line. Defaults to `2.0`.
    /// - Parameter MainLineColor: The color of the line. Defaults to `.black`.
    /// - Parameter ShowViewportBorder: Determines if the viewport border is visible. Defaults to `false`.
    /// - Parameter Scale: The scale factor to use. If nil, no scaling factor is used.
    /// - Returns: A `UIBezierPath` based on the passed parameters.
    public static func GenerateShape(_ Points: [CGPoint],
                                     ShowPoints: Bool,
                                     ClosePath: Bool,
                                     MainLineWidth: CGFloat = 2.0,
                                     MainLineColor: UIColor = UIColor.black,
                                     ShowViewportBorder: Bool = false,
                                     Viewport: CGRect = CGRect(origin: .zero,
                                                               size: CGSize(width: 1024,
                                                                            height: 1024)),
                                     Scale: CGFloat?) -> UIBezierPath
    {
        let FinalPath = UIBezierPath()
        var PointPath = UIBezierPath()
        var LinePath = UIBezierPath()
        var ViewportPath =  UIBezierPath()
        if ShowViewportBorder
        {
            var FinalViewport = Viewport
            if let Scale = Scale
            {
                FinalViewport = CGRect(x: Viewport.origin.x * Scale,
                                       y: Viewport.origin.y * Scale,
                                       width: Viewport.size.width * Scale,
                                       height: Viewport.size.height * Scale)

            }
            ViewportPath = CreatePath(.Viewport, Viewport: FinalViewport)
            ViewportPath.stroke()
            //Appending the returned ViewportPath to FinalPath results in a thin blue line
            //drawn on top of the ViewportPath line. Commenting out the following line
            //stops that.
            //FinalPath.append(ViewportPath)
        }
        if ShowPoints
        {
            PointPath = CreatePath(.Points, Points: Points)
            PointPath.stroke()
            FinalPath.append(PointPath)
        }
        if Points.count > 2
        {
            LinePath = CreatePath(.Lines, Points: Points, ClosePath: ClosePath,
                                   MainLineWidth: MainLineWidth, MainLineColor: MainLineColor)
            LinePath.stroke()
            FinalPath.append(LinePath)
        }
        return FinalPath
    }
    
    public static func CreatePath(_ PathType: PathTypes,
                                  Points: [CGPoint] = [CGPoint](),
                                  ClosePath: Bool = true,
                                  MainLineWidth: CGFloat = 2.0,
                                  MainLineColor: UIColor = .black,
                                  Viewport: CGRect = .zero) -> UIBezierPath
    {
        switch PathType
        {
            case .Points:
                var Index = 0
                let PointsPath = UIBezierPath()
                for Point in Points
                {
                    let Circle = CGRect(x: Point.x - 8,
                                        y: Point.y - 8,
                                        width: 16.0,
                                        height: 16.0)
                    let PointPath = UIBezierPath(ovalIn: Circle)
                    let DrawText = "\(Index)" as NSString
                    let TextRect = CGRect(x: Point.x + 12,
                                          y: Point.y - 5,
                                          width: 30,
                                          height: 20)
                    DrawText.draw(in: TextRect, withAttributes: [:])
                    PointsPath.append(PointPath)
                    Index = Index + 1
                }
                PointsPath.lineWidth = 3.2
                UIColor.black.setStroke()
                //PointsPath.stroke()
                return PointsPath
                
            case .Viewport:
                let VPBorder = UIBezierPath()
                VPBorder.move(to: CGPoint(x: 2, y: 2))
                VPBorder.addLine(to: CGPoint(x: Viewport.size.width, y: 2))
                VPBorder.addLine(to: CGPoint(x: Viewport.size.width,
                                             y: Viewport.size.height - 2))
                VPBorder.addLine(to: CGPoint(x: 2, y: Viewport.size.height - 2))
                VPBorder.addLine(to: CGPoint(x: 2, y: 2))
                UIColor.red.setStroke()
                VPBorder.lineWidth = 4.0
                //VPBorder.stroke()
                return VPBorder
                
            case .Lines:
                let LinesPath = UIBezierPath()
                for Index in 0 ..< Points.count
                {
                    let LinePath = UIBezierPath()
                    LinePath.move(to: Points[Index])
                    if Index == Points.count - 1
                    {
                        if ClosePath
                        {
                            LinePath.addLine(to: Points[0])
                        }
                    }
                    else
                    {
                        LinePath.addLine(to: Points[Index + 1])
                    }
                    LinesPath.lineWidth = MainLineWidth
                    MainLineColor.setStroke()
                    LinesPath.append(LinePath)
                }
                //LinesPath.stroke()
                return LinesPath
        }
    }
}

/// Edit modes for user shapes.
enum EditTypes: CaseIterable
{
    /// Adding points.
    case Add
    /// Moving points
    case Move
    /// Deleting points.
    case Delete
}


enum LimitSides
{
    case Top
    case Left
    case Bottom
    case Right
}

/// Types of paths to generate/display.
enum PathTypes: String, CaseIterable
{
    /// Path for points.
    case Points = "Points"
    /// Path for lines.
    case Lines = "Lines"
    /// Path for viewport infrastructure.
    case Viewport = "Viewport"
}
