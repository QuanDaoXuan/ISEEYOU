//
//  UIColorExtension.swift
//  iseeyou
//
//  Created by resopt on 10/30/20.
//  Copyright © 2020 truc. All rights reserved.
//


import Foundation
import UIKit

extension UIColor {
    convenience init(hexString: String) {
        if hexString == "" {
            self.init(red: CGFloat(255) / 255, green: CGFloat(255) / 255, blue: CGFloat(255) / 255, alpha: CGFloat(255) / 255)
        } else {
            let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
            var int = UInt64()
            Scanner(string: hex).scanHexInt64(&int)
            let a, r, g, b: UInt64
            switch hex.count {
            case 3: // RGB (12-bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (255, 0, 0, 0)
            }
            self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
        }
    }

    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: 1)
    }

    public class var backgroundApp: UIColor {
        return UIColor(hexString: "#E5E5E5")
    }

    public class var backgroundLightgray: UIColor {
        return UIColor(hexString: "#F5F7FA")
    }

    public class var backgroundCheckin: UIColor {
        return UIColor(hexString: "#F195C7")
    }

    public class var backgroundCheckout: UIColor {
        return UIColor(hexString: "#5FBBEE")
    }

    public class var backgroundBreakStart: UIColor {
        return UIColor(hexString: "#FFAF75")
    }

    public class var backgroundBreakEnd: UIColor {
        return UIColor(hexString: "#6FCF97")
    }

    public class var backgroundDoneBtn: UIColor {
        return UIColor(hexString: "#27AE60")
    }
}
