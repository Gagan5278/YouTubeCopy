//
//  Int+Extension.swift
//  YouTubeCopy
//
//  Created by Gagan  Vishal on 8/14/20.
//

import Foundation
extension Int {
    fileprivate func minuetsFormat() -> String {
        return String(format: "%02d", ((self % 3600) / 60))
    }
    
    fileprivate func secondsFormat() -> String {
        return String(format: "%02d", ((self % 3600) % 60))
    }
    
    fileprivate func hoursFormat() -> String {
        return String(format: "%02d", (self / 3600))
    }
    
    func timeDurationDisplay() -> String {
        if self > 3600 {
            return  hoursFormat() + ":" +  minuetsFormat()  + ":" +  secondsFormat()
        }
        return minuetsFormat() + ":" + secondsFormat()

    }
}
