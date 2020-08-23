//
//  CustomDownSwipeGestureRecognizer.swift
//  YouTubeCopy
//
//  Created by Gagan  Vishal on 8/22/20.
//

import UIKit

final class CustomDownSwipeGestureRecognizer: UISwipeGestureRecognizer {
    private var action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
        super.init(target: nil, action: nil)
        direction = .down
        self.addTarget(self, action: #selector(execute))
    }

    @objc private func execute() {
        
        action()
    }
}
