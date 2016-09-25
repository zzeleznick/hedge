//
//  CoreExtension.swift
//  Hedge
//
//  Created by Zach Zeleznick on 9/24/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//

import UIKit

// MARK: Enables Colors from Hex Codes
extension UIColor{
    convenience init(rgb: UInt, alphaVal: CGFloat? = 1.0) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alphaVal!)
        )
    }
}
