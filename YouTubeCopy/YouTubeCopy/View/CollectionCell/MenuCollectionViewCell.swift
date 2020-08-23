//
//  MenuCollectionViewCell.swift
//  YouTubeCopy
//
//  Created by Gagan  Vishal on 8/13/20.
//

import UIKit

class MenuCollectionViewCell: BaseCollectionViewCell {
    fileprivate let arrayOfImages: [UIImage] = [UIImage(named: "home")!,UIImage(named: "trending")!,UIImage(named: "subscriptions")!,UIImage(named: "account")!]
    //imageview
    let cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "home")
        imageView.tintColor = UIColor.unselectedColor
        return imageView
    }()
    
    override var isHighlighted: Bool {
        didSet {
            cellImageView.tintColor =  isHighlighted ? UIColor.white : UIColor.unselectedColor
        }
    }
    
    override var isSelected: Bool {
        didSet {
            cellImageView.tintColor =  isSelected ? UIColor.white : UIColor.unselectedColor
        }
    }
    
    //MARK:- Setup
    override func setupCollectionView() {
        //1.
        self.addSubview(self.cellImageView)
        self.cellImageView.centerInSuperview()
    }
    
    //MARK:- Set Image at index
    func setImage(at index: Int) {
        guard index < arrayOfImages.count  else {
            return
        }
        self.cellImageView.image = arrayOfImages[index].withRenderingMode(.alwaysTemplate)
        self.tintColor = UIColor.unselectedColor
    }
}
