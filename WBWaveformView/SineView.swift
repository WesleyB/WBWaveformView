//
//  SineView.swift
//  Audiate
//
//  Created by Wesley Bevins on 9/3/16.
//  Copyright © 2016 Wesley Bevins. All rights reserved.
//

import UIKit

class SineView: UIView {
    
    var phase = CGFloat()
    var primaryWaveColor = UIColor.white
    var secondaryWaveColor = UIColor.white
    var frequency = Default.Frequency
    var amplitude = Default.Amplitude
    var idleAmplitude = Default.IdleAmplitude
    var numberOfWaves = Default.WaveNumber
    var phaseShift = Default.PhaseShift
    var density = Default.Density
    var primaryLineWidth = Default.PrimaryLineWidth
    var secondaryLineWidth = Default.SecondaryLineWidth
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
    }
    
    func setup() {
        
        primaryWaveColor = UIColor.white
        frequency = Default.Frequency
        amplitude = Default.Amplitude
        idleAmplitude = Default.IdleAmplitude
        numberOfWaves = Default.WaveNumber
        phaseShift = Default.PhaseShift
        density = Default.Density
        primaryLineWidth = Default.PrimaryLineWidth
        secondaryLineWidth = Default.SecondaryLineWidth
    }
    
    func updateWithLevel(_ level: CGFloat) {
        
        self.phase += self.phaseShift
        self.amplitude = max(level*0.66, self.idleAmplitude)
        
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let aContext = UIGraphicsGetCurrentContext() else { return }
        
        aContext.clear(self.bounds)
        
        self.backgroundColor?.set()
        aContext.fill(rect)
        
        for i in stride(from: Int(numberOfWaves), through: 0, by: -1) {
            
            guard let context = UIGraphicsGetCurrentContext() else { return }
            
            context.setLineWidth((i == 0 ? self.primaryLineWidth : self.secondaryLineWidth))
            
            let halfHeight = self.bounds.height / 2
            let width = self.bounds.width
            let mid = width / 2
            
            let maxAmp = halfHeight - 4
            
            let progress = 1 - CGFloat(i) / numberOfWaves
            let normedAmp = (1.5 * progress - 0.5) * amplitude
            
            let multiplier = min(1, (progress / 3 * 2) + (1 / 3))
            i == 0 ? primaryWaveColor.withAlphaComponent(multiplier * self.primaryWaveColor.cgColor.alpha).set() :
                secondaryWaveColor.withAlphaComponent(multiplier * self.secondaryWaveColor.cgColor.alpha).set()
            
            
            for x in stride(from: 0, to: Int(width + density), by: Int(density)) {
                
                let scaling = -pow(1 / mid * (CGFloat(x) - mid), 2) + 1
                
                let y = scaling * maxAmp * normedAmp * sin(2 * CGFloat(M_PI) * (CGFloat(x) / width) * frequency + phase) + halfHeight
                
                if x == 0 {
                    
                    context.move(to: CGPoint(x: CGFloat(x), y: y))

                } else {
                    
                    context.addLine(to: CGPoint(x: CGFloat(x), y: y))
                }

            }
            
            context.strokePath()
        }
    }

}

fileprivate struct Default {
    
    static let Frequency : CGFloat = 1.5
    static let Amplitude : CGFloat = 1
    static let IdleAmplitude : CGFloat = 0.01
    static let WaveNumber : CGFloat = 5
    static let PhaseShift : CGFloat = -0.15
    static let Density : CGFloat = 3
    static let PrimaryLineWidth : CGFloat = 3
    static let SecondaryLineWidth : CGFloat = 1
}




























