//
//  URLRouter.swift
//  YouTubeCopy
//
//  Created by Gagan  Vishal on 8/16/20.
//

import Foundation

enum CollectionCell: Int {
    case feed
    case trending
    case subscriptions
    
    var urlStringForRoute: String {
        switch self {
        case .feed:
            return Constants.NetworkConstants.domain_url + "home.json"
        case .subscriptions:
            return Constants.NetworkConstants.domain_url + "subscriptions.json"
        case .trending:
            return Constants.NetworkConstants.domain_url + "trending.json"
        }
    }
}
