//
//  AnimationSettingsSlice.swift
//  TextLines
//
//  Created by Stuart Rankin on 11/6/21.
//

import Foundation
import UIKit

class AnimationSettingsSlice: UIViewController, ShapeSliceProtocol
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        self.view.layer.cornerRadius = UIConstants.CornerRadius
        self.view.layer.borderColor = UIConstants.DarkBorder
        self.view.layer.borderWidth = UIConstants.ThickBorder
        
        let AnimSpeed = Settings.GetInt(.AnimationSpeed)
        let Index = SpeedArray.firstIndex(of: AnimSpeed) ?? 2
        AnimationSpeedControl.selectedSegmentIndex = Index
        let AnimDir = Settings.GetBool(.AnimateClockwise)
        AnimationDirectionControl.selectedSegmentIndex = AnimDir ? 1 : 0
        
        let Tap = UITapGestureRecognizer(target: self, action: #selector(TapHandler))
        RunStateButton.addGestureRecognizer(Tap)
        let IsPlaying = Settings.GetBool(.Animating)
        RunStateButton.image = UIImage(systemName: IsPlaying ? "stop" : "play")
    }
    
    @objc func TapHandler(_ Recognizer: UITapGestureRecognizer)
    {
        let IsPlaying = Settings.GetBool(.Animating)
        let NewPlayState = !IsPlaying
        if IsPlaying
        {
            //Change visual to non-play
            RunStateButton.image = UIImage(systemName: "stop")
        }
        else
        {
            //Change visual to play
            RunStateButton.image = UIImage(systemName: "play")
        }
        Settings.SetBool(.Animating, NewPlayState)
    }
    
    let SpeedArray = [AnimationSpeeds.Slowest.rawValue, AnimationSpeeds.Slow.rawValue,
                      AnimationSpeeds.Medium.rawValue, AnimationSpeeds.Fast.rawValue,
                      AnimationSpeeds.Fastest.rawValue]
    
    @IBAction func AnimationSpeedControlChanged(_ sender: Any)
    {
        guard let Speed = sender as? UISegmentedControl else
        {
            Debug.Print("Incorrect control sent to AnimationSpeedControlChanged")
            return
        }
        let Index = Speed.selectedSegmentIndex
        let SpeedValue = AnimationSpeeds.allCases[Index].rawValue
        Settings.SetInt(.AnimationSpeed, SpeedValue)
    }
    
    @IBAction func AnimationDirectionControlChanged(_ sender: Any)
    {
        guard let Segment = sender as? UISegmentedControl else
        {
            Debug.Print("Incorrect control sent to AnimationDirectionControlChanged")
            return
        }
        let IsClockwise = Segment.selectedSegmentIndex == 1 ? true : false
        Settings.SetBool(.AnimateClockwise, IsClockwise)
    }
    
    func ResetSettings()
    {
        Settings.SetBoolDefault(For: .AnimateClockwise)
        let AnimDir = Settings.GetBool(.AnimateClockwise)
        AnimationDirectionControl.selectedSegmentIndex = AnimDir ? 1 : 0
        Settings.SetIntDefault(For: .AnimationSpeed)
        let AnimSpeed = Settings.GetInt(.AnimationSpeed)
        let Index = SpeedArray.firstIndex(of: AnimSpeed) ?? 2
        AnimationSpeedControl.selectedSegmentIndex = Index
        Settings.SetBoolDefault(For: .Animating)
        let IsAnimating = Settings.GetBool(.Animating)
        RunStateButton.image = UIImage(systemName: IsAnimating ? "stop" : "play")
    }
    
    @IBOutlet weak var RunStateButton: UIImageView!
    @IBOutlet weak var AnimationSpeedControl: UISegmentedControl!
    @IBOutlet weak var AnimationDirectionControl: UISegmentedControl!
}
