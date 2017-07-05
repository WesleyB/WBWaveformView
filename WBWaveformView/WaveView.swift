//
//  WaveView.swift
//  Audiate
//
//  Created by Wesley Bevins on 11/28/16.
//  Copyright © 2016 Wesley Bevins. All rights reserved.
//

import UIKit

fileprivate let ActiveInactiveTransitionStep : CGFloat = 0.05
fileprivate let ColorTransitionStep : Float = 0.002
fileprivate let PrimaryWaveActiveColors = [UIColor.red, UIColor.lightGray, UIColor.blue]
fileprivate let PrimaryWaveColorCount = PrimaryWaveActiveColors.count
fileprivate let PrimaryWaveInactiveColor = UIColor.gray
fileprivate let SecondaryWaveColor = UIColor.gray
fileprivate let WaveLevel : CGFloat = 0.8
fileprivate let PrimaryWaveFrequency : CGFloat = 1.2
fileprivate let SecondaryWaveFrequency : CGFloat = 0.8
fileprivate let BaseDeviceRatio = 1.875

class WaveView: UIView {

    var active = false
    var scaleFactor : CGFloat = 1
    
    let frontWaveView = SineView()
    let backWaveView = SineView()
    fileprivate var waveLevel : CGFloat = 0
    fileprivate var colorLerp : Float = 0
    
    init() {
        super.init(frame: CGRect.zero)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setWaveViewActive(_ active: Bool) {
        self.active = active
    }
    
    fileprivate func setup() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        backWaveView.backgroundColor = UIColor.clear
        backWaveView.phaseShift = -0.022
        backWaveView.primaryLineWidth = 0.5
        backWaveView.primaryWaveColor = PrimaryWaveInactiveColor
        backWaveView.secondaryLineWidth = 0.5
        backWaveView.secondaryWaveColor = UIColor.darkGray
        backWaveView.updateWithLevel(0)
        backWaveView.translatesAutoresizingMaskIntoConstraints = false
        backWaveView.alpha = 0
        addSubview(backWaveView)
        
        frontWaveView.backgroundColor = UIColor.clear
        frontWaveView.phaseShift = -0.02
        frontWaveView.primaryLineWidth = 2
        frontWaveView.primaryWaveColor = PrimaryWaveInactiveColor
        frontWaveView.secondaryLineWidth = 0.5
        frontWaveView.secondaryWaveColor = SecondaryWaveColor
        frontWaveView.updateWithLevel(0)
        frontWaveView.translatesAutoresizingMaskIntoConstraints = false
        frontWaveView.alpha = 0
        addSubview(frontWaveView)
        
        frontWaveView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        frontWaveView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        frontWaveView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        frontWaveView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        backWaveView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backWaveView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        backWaveView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        backWaveView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        clipsToBounds = true
        
        let displayLink = CADisplayLink(target: self, selector: #selector(WaveView.displayLink(_:)))
        displayLink.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    
    @objc fileprivate func displayLink(_ sender: CADisplayLink) {
        
        colorLerp = (colorLerp + ColorTransitionStep).truncatingRemainder(dividingBy: Float(PrimaryWaveColorCount))
        let colorIndex = Int(colorLerp)
        let lerp = CGFloat(colorLerp - Float(colorIndex))
        let fromColor = PrimaryWaveActiveColors[colorIndex]
        let toColor = PrimaryWaveActiveColors[(colorIndex + 1) % PrimaryWaveColorCount]
        let currentColor = fromColor.lerp(toColor: toColor, step: lerp)
        
        if active && waveLevel < WaveLevel {
            waveLevel += ActiveInactiveTransitionStep
            frontWaveView.primaryWaveColor = PrimaryWaveInactiveColor.lerp(toColor: currentColor, step: waveLevel / WaveLevel)
        } else if !active && waveLevel > 0 {
            waveLevel -= ActiveInactiveTransitionStep
            frontWaveView.primaryWaveColor = currentColor.lerp(toColor: PrimaryWaveInactiveColor, step: WaveLevel - waveLevel)
        } else if active {
            frontWaveView.primaryWaveColor = currentColor
        }
        
        if active {
            backWaveView.updateWithLevel(waveLevel - 0.1)
            frontWaveView.updateWithLevel(waveLevel*scaleFactor)
            frontWaveView.alpha = min(1, frontWaveView.alpha + 0.2)
            backWaveView.alpha = min(1, backWaveView.alpha + 0.2)
        } else {
            if waveLevel >= 0 {
                waveLevel -= 0.1
                frontWaveView.alpha = max(0, frontWaveView.alpha - 0.2)
                backWaveView.alpha = max(0, backWaveView.alpha - 0.2)
                backWaveView.updateWithLevel(max(0, waveLevel))
                frontWaveView.updateWithLevel(max(0, waveLevel))
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let freqMult : CGFloat = bounds.width / bounds.height / CGFloat(BaseDeviceRatio)
        frontWaveView.frequency = PrimaryWaveFrequency * freqMult
        backWaveView.frequency = SecondaryWaveFrequency * freqMult
    }
    

}

extension UIColor {
    
    func lerp(toColor: UIColor, step: CGFloat) -> UIColor {
        
        var fromR : CGFloat = 0, fromG : CGFloat = 0, fromB : CGFloat = 0
        getRed(&fromR, green: &fromG, blue: &fromB, alpha: nil)
        
        var toR : CGFloat = 0, toG : CGFloat = 0, toB : CGFloat = 0
        toColor.getRed(&toR, green: &toG, blue: &toB, alpha: nil)
        
        let r = fromR + (toR - fromR) * step
        let g = fromG + (toG - fromG) * step
        let b = fromB + (toB - fromB) * step
        
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
    
}










































