//
//  ViewController.swift
//  WBWaveformView
//
//  Created by Wesley Bevins on 7/5/17.
//  Copyright © 2017 Wesley Bevins. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    weak var waveView : WaveView!
    var activateButton : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        
        waveView = WaveView()
        view.addSubview(waveView)
        waveView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        waveView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        waveView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        waveView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        waveView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        activateButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        activateButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activateButton)
        activateButton.setTitle("Activate", for: .normal)
        activateButton.setTitleColor(UIColor.black, for: .normal)
        activateButton.addTarget(self, action: #selector(activatePressed(_:)), for: .touchUpInside)
        activateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activateButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -30).isActive = true
    }
    
    func activatePressed(_ sender: UIButton) {
        
        waveView.setWaveViewActive(!waveView.active)
    }
}

