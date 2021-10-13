//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let Infinity = InfinitySymbol(frame: CGRect(x: 0, y: 0,
                                                    width: 800, height: 800))
        Infinity.Left = CGPoint(x: 100, y: 400)
        Infinity.Right = CGPoint(x: 600, y: 400)
        Infinity.Radius = 200
        view.addSubview(Infinity)
        Infinity.setNeedsDisplay()
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()


class InfinitySymbol: UIView
{
    var Left: CGPoint = CGPoint(x: 100, y: 100)
    var Right: CGPoint = CGPoint(x: 200, y: 100)
    var Radius: CGFloat = 50
    
    func CreateInfinityPath(LeftCenter: CGPoint,
                            RightCenter: CGPoint,
                            Radius: CGFloat,
                            Width: CGFloat = 1.0) -> UIBezierPath?
    {
        let XDelta = (abs(RightCenter.x - LeftCenter.x) / 2) + LeftCenter.x
        print("XDelta = \(XDelta)")
        let YDelta = (abs(RightCenter.y - LeftCenter.y) / 2) + LeftCenter.y
        print("YDelta = \(YDelta)")
        let Center = CGPoint(x: XDelta, y: YDelta)
        let Path = UIBezierPath()
        let LeftArc = UIBezierPath(arcCenter: LeftCenter,
                                   radius: Radius,
                                   startAngle: CGFloat.pi / 2,
                                   endAngle: CGFloat.pi * 1.5,
                                   clockwise: true)
        let RightArc = UIBezierPath(arcCenter: RightCenter,
                                    radius: Radius,
                                    startAngle: CGFloat.pi / 2,
                                    endAngle: CGFloat.pi * 1.5,
                                    clockwise: false)
        Path.append(LeftArc)
        Path.append(RightArc)
        
        let LeftToRight = UIBezierPath()
        LeftToRight.move(to: CGPoint(x: LeftCenter.x,
                                     y: LeftCenter.y - Radius))
        LeftToRight.addCurve(to: CGPoint(x: RightCenter.x,
                                         y: RightCenter.y + Radius),
                             controlPoint1: CGPoint(x: XDelta,
                                                    y: Radius),
                             controlPoint2: CGPoint(x: XDelta,
                                                    y: YDelta + Radius))
        let RightToLeft = UIBezierPath()
        RightToLeft.move(to: CGPoint(x: LeftCenter.x,
                                     y: RightCenter.y + Radius))
        RightToLeft.addCurve(to: CGPoint(x: RightCenter.x,
                                         y: RightCenter.y - Radius),
                             controlPoint1: CGPoint(x: XDelta,
                                                    y: YDelta + Radius),
                             controlPoint2: CGPoint(x: XDelta,
                                                    y: Radius))

        Path.append(LeftToRight)
        Path.append(RightToLeft)
        
        Path.lineWidth = Width
        Path.lineJoinStyle = .round
        UIColor.systemYellow.setStroke()
        
        return Path
    }
    
    override func draw(_ rect: CGRect)
    {
        let Path = CreateInfinityPath(LeftCenter: Left,
                                      RightCenter: Right,
                                      Radius: Radius,
                                      Width: 5.0)
        Path?.stroke()
    }
}
