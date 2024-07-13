//
//  UIColorMarshalling.swift
//  Tracker
//
//  Created by Andrey Lazarev on 12.07.2024.
//

import UIKit

extension UIColor {
    convenience init(hexString: String) {
        var formattedString = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if formattedString.hasPrefix("#") {
            formattedString.remove(at: formattedString.startIndex)
        }
        
        var rgb: UInt64 = 0
        Scanner(string: formattedString).scanHexInt64(&rgb)
        
        self.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgb & 0x0000FF) / 255.0,
                  alpha: 1.0)
    }
    
    func toHexString() -> String {
        guard let components = self.cgColor.components else {
            return ""
        }
        
        let r = components[0]
        let g = components[1]
        let b = components[2]
        
        return String(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
    }
}
