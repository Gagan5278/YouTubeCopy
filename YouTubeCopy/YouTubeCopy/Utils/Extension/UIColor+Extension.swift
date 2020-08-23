//
//  UIColor+Extension.swift
//  YouTubeCopy
//
//  Created by Gagan  Vishal on 8/13/20.
//

import UIKit

extension UIColor {
    
    fileprivate static func r(_ r : CGFloat, g: CGFloat, b: CGFloat) -> UIColor  {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    
    static let youtubeRedColor = r(245.0, g: 30.0, b: 30.0)
    static let unselectedColor = r(91.0, g: 13.0, b: 14.0)
}
