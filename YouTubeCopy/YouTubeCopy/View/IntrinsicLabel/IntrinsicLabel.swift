//
//  IntrinsicLabel.swift
//  YouTubeCopy
//
//  Created by Gagan  Vishal on 8/14/20.
//

import UIKit

class IntrinsicLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += 10
        size.height += 5
        return size
    }
    

}
