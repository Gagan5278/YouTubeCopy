//
//  NSNumber+Extension.swift
//  YouTubeCopy
//
//  Created by Gagan  Vishal on 8/14/20.
//

import Foundation
extension NSNumber {
    
    private static var decimalFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }
    
    func getHumanReabableNumber() -> String {
        NSNumber.decimalFormatter.string(from: self)!
    }
}
