//
//  UIStackView+Extension.swift
//  YouTubeCopy
//
//  Created by Gagan  Vishal on 8/22/20.
//

import UIKit

extension UIStackView {
    func addBackground(color: UIColor = .clear) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
