//
//  ProfileImageView.swift
//  YouTubeCopy
//
//  Created by Gagan  Vishal on 8/14/20.
//

import UIKit
import Combine
let imageDownloadedCache = NSCache<NSString, UIImage>()
class ProfileImageView: UIImageView {
    let networkRequest = NetworkRequest()
    var cancellable: AnyCancellable?
    var urlStringForFetch: String!
    //MARK:- Download image or fetch from cache
    func downloadImage(from urlString: String, completion:@escaping () -> Void) {
        //1.
        if let savedImage = imageDownloadedCache.object(forKey: urlString as NSString)  {
            self.image = savedImage
            return
        }
        self.image =  nil
        self.urlStringForFetch = urlString
        self.cancellable = self.networkRequest.fetchImage(from: urlString).sink(receiveCompletion: {print($0)}, receiveValue: { (img) in
            if self.urlStringForFetch  == urlString {
                self.image = img
                completion()
            }
            imageDownloadedCache.setObject(img, forKey: urlString as NSString)
        })
    }
}
