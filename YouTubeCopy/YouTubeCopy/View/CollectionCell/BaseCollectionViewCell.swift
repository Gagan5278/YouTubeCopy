//
//  BaseCollectionViewCell.swift
//  YouTubeCopy
//
//  Created by Gagan  Vishal on 8/13/20.
//

import UIKit
class BaseCollectionViewCell: UICollectionViewCell {
    //MARK:- View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK:- COllection Setup
    func setupCollectionView() {}
}
