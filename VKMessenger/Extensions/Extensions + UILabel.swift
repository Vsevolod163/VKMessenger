//
//  Extensions + UILabel.swift
//  WebViewApp
//
//  Created by Vsevolod Lashin on 14.07.2023.
//

import UIKit

extension UILabel {
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.fromValue = 0.95
        pulse.toValue = 1
        pulse.autoreverses = true
        pulse.repeatCount = 1
        pulse.duration = 0.6
        pulse.initialVelocity = 0.5
        pulse.damping = 1

        layer.add(pulse, forKey: nil)
    }
}
