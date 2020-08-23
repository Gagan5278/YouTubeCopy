//
//  SettingCollectionViewCell.swift
//  YouTubeCopy
//
//  Created by Gagan  Vishal on 8/15/20.
//

import UIKit

class SettingCollectionViewCell: UICollectionViewListCell {
    var settingObject: Settings!

    //MARK:- View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var contentConfig = self.defaultContentConfiguration().updated(for: state)
        contentConfig.text = state.item?.settingName
        contentConfig.textProperties.color = self.isHighlighted ? UIColor.white : UIColor.black
        contentConfig.image = state.item?.image.withRenderingMode(.alwaysTemplate)
        contentConfig.imageProperties.tintColor = self.isHighlighted ? UIColor.white : UIColor.black
        self.contentConfiguration = contentConfig
    }

    override var configurationState: UICellConfigurationState {
        var config = super.configurationState
        config.item = self.settingObject
        return config
    }
    
    //MARK:- Setup items
    func didSetupView(for setting: Settings) {
        self.settingObject = setting
        super.setNeedsUpdateConfiguration()
    }
}


extension UIConfigurationStateCustomKey {
    static let key = UIConfigurationStateCustomKey("key")
}

extension UIConfigurationState {
    var item: Settings? {
        set {
             self[.key] = newValue 
        }
        get {
            return self[.key] as? Settings
        }
    }
}
