//
//  VideoViewModel.swift
//  YouTubeCopy
//
//  Created by Gagan  Vishal on 8/14/20.
//

import Foundation
import Combine

protocol VideoViewModelProtocol {
    var videoTitle: String {get}
    var humanReadableViewCount: String {get}
    var humanReadbleDuuration: String {get}
    var formmattedDescription: String {get}
    var channelThumbnailURLString: String {get}
    var videoThumbnailURLString: String {get}
}

extension VideoModel: VideoViewModelProtocol {
    
    var videoTitle: String {
        return self.title
    }
    
    var humanReadableViewCount: String {
        return NSNumber(value: self.number_of_views).getHumanReabableNumber() + "Views"
    }
    
    var humanReadbleDuuration: String {
        return self.duration.timeDurationDisplay()
    }
    
    var formmattedDescription: String {
        return self.channel.name + " ▪ " + self.humanReadableViewCount
    }
    
    var channelThumbnailURLString: String {
        return self.channel.profile_image_name
    }
    
    var videoThumbnailURLString: String {
        return self.thumbnail_image_name
    }
}

//MARK: ViewModel
class VideoViewModel {
    let networkObject = NetworkRequest()
    var cancellable: AnyCancellable?
    public private(set) var allVideos: [VideoModel] = []
    public private(set) var collectionReloadSignalPassthroughSubject = PassthroughSubject<Bool, Never>()
    //MARK:- Fetch all videos fom server
    func fetchVideoListFromServer(cellLoaded: CollectionCell) {
        self.cancellable = networkObject.fetchItem(from: cellLoaded.urlStringForRoute, modelType: [VideoModel].self)
        .sink { (completioin) in
        } receiveValue: { (videos) in
            self.allVideos = videos
            self.collectionReloadSignalPassthroughSubject.send(true)
        }
    }
}
