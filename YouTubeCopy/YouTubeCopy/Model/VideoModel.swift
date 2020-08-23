//
//  VideoModel.swift
//  YouTubeCopy
//
//  Created by Gagan  Vishal on 8/14/20.
//

import Foundation

struct VideoModel: Decodable, Hashable {

    var id = UUID()
    let title: String
    let number_of_views: Int
    let thumbnail_image_name: String
    let duration: Int
    let channel: Channel
    
    enum CodingKeys: String, CodingKey {
        case title
        case number_of_views
        case thumbnail_image_name
        case duration
        case channel
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.number_of_views = try container.decode(Int.self, forKey: .number_of_views)
        self.thumbnail_image_name = try container.decode(String.self, forKey: .thumbnail_image_name)
        self.duration = try container.decode(Int.self, forKey: .duration)
        self.channel = try container.decode(Channel.self, forKey: .channel)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static func == (lhs: VideoModel, rhs: VideoModel) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Channel: Decodable {
    let name: String
    let profile_image_name: String
}

