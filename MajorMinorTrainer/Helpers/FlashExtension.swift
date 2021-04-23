//
//  FlashExtension.swift
//  MajorMinorTrainer
//
//  Created by Alexander Nagel on 23.04.21.
//

import UIKit

//
// MARK: - flash extension for buttons
//
internal extension UIButton {

    func flash(intervalDuration duration: Double = 0.1,
               intervals repeatCount: Float = 5 ) {
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = duration
        flash.fromValue = 1
        flash.toValue = 0.0
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = repeatCount
        layer.add(flash, forKey: nil)
    }
}

internal extension UIImageView {

    func flash(intervalDuration duration: Double = 0.1,
               intervals repeatCount: Float = 5 ) {
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = duration
        flash.fromValue = 1
        flash.toValue = 0.0
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = repeatCount
        layer.add(flash, forKey: nil)
    }
}
