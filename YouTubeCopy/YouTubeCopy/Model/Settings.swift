//
//  Settings.swift
//  YouTubeCopy
//
//  Created by Gagan  Vishal on 8/15/20.
//

import Foundation
import UIKit

struct Settings: Hashable {
    let id = UUID()
    let image: UIImage
    let settingName: String
    let router: UIViewController.Type?
    
    //MARK:- Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static func == (lhs: Settings, rhs: Settings) -> Bool {
        return lhs.id == rhs.id
    }
    
    //MARK: init
    init(name: String, imageName: String, conttoller: UIViewController.Type? = nil ) {
        self.image = UIImage(systemName: imageName)!
        self.settingName = name
        self.router = conttoller
    }
    
    //var to handle a list of option for setting
    static let settings = [
        Settings(name: "Settings", imageName: "gearshape.fill", conttoller: SettingsViewController.self),
        Settings(name: "Terms and Privacy Policy", imageName: "lock.circle.fill", conttoller: SettingsViewController.self),
        Settings(name: "Send Feedback", imageName: "paperplane.circle.fill", conttoller: SettingsViewController.self),
        Settings(name: "Help", imageName: "questionmark.circle.fill", conttoller: SettingsViewController.self),
        Settings(name: "Switch Account", imageName: "person.crop.circle.fill", conttoller: SettingsViewController.self),
        Settings(name: "Cancel", imageName: "xmark.circle.fill")
    ]
}
