//
//  UIColor.swift
//  Pods
//
//  Created by Thuong Nguyen on 1/9/16.
//
//

import UIKit

public extension UIColor {
    class func color(hexString: String) -> UIColor? {
        if (hexString.characters.count > 7 || hexString.characters.count < 7) {
            return nil
        } else {
            let hexInt = Int(hexString.substringFromIndex(hexString.startIndex.advancedBy(1)), radix: 16)
            if let hex = hexInt {
                let components = (
                    R: CGFloat((hex >> 16) & 0xff) / 255,
                    G: CGFloat((hex >> 08) & 0xff) / 255,
                    B: CGFloat((hex >> 00) & 0xff) / 255
                )
                return UIColor(red: components.R, green: components.G, blue: components.B, alpha: 1)
            } else {
                return nil
            }
        }
    }
}
