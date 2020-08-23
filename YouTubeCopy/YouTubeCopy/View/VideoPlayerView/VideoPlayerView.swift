//
//  VideoPlayerView.swift
//  YouTubeCopy
//
//  Created by Gagan  Vishal on 8/22/20.
//

import UIKit

class VideoPlayerView: NSObject {
    var videoPlayerView: YouTubeVideoPlayer! = nil
    //view to handle player
    lazy var playerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    //Close Player button when minimise
    lazy var closePlayerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isHidden = true
        button.setImage(UIImage(systemName: "xmark.circle")!, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(closePlayer), for: .touchUpInside)
        return button
    }()
    
    //Leading anchor
    var viewLeadingAnchor: NSLayoutConstraint! = nil
    //Top anchor
    var viewTopAnchor: NSLayoutConstraint! = nil
    var viewTrailingAnchor: NSLayoutConstraint! = nil
    var viewBottomAnchor: NSLayoutConstraint! = nil
    var vedioPlayerHeightAnchor: NSLayoutConstraint! = nil
    //MARK:- Init
    override init() {
        super.init()
    }

    //MARK:-
    func addPayerOnWindow() {
        if let winowObject = UIApplication.shared.windows.first {
            var heightConstraint: CGFloat = 0
            let intiitalFrameConstant: CGFloat = winowObject.frame.width/4
            winowObject.addSubview(self.playerView)
            winowObject.backgroundColor = .white
            viewLeadingAnchor = self.playerView.leadingAnchor.constraint(equalTo: winowObject.leadingAnchor, constant: intiitalFrameConstant*2)
            viewLeadingAnchor.isActive = true
            heightConstraint = winowObject.frame.height - intiitalFrameConstant*2
            viewTopAnchor = self.playerView.topAnchor.constraint(equalTo: winowObject.safeAreaLayoutGuide.topAnchor, constant: heightConstraint)
            viewTopAnchor.isActive = true

            self.viewTrailingAnchor = self.playerView.trailingAnchor.constraint(equalTo: winowObject.trailingAnchor, constant: 0)
            self.viewTrailingAnchor.isActive = true
            self.viewBottomAnchor = self.playerView.bottomAnchor.constraint(equalTo: winowObject.bottomAnchor, constant: 0)
            self.viewBottomAnchor.isActive = true

            videoPlayerView = YouTubeVideoPlayer(frame: .zero)
            self.playerView.addSubview(videoPlayerView)
            self.playerView.clipsToBounds = true
            let videoHeight: CGFloat = winowObject.frame.width * 9/16
            videoPlayerView.leadingAnchor.constraint(equalTo: self.playerView.leadingAnchor).isActive = true
            videoPlayerView.topAnchor.constraint(equalTo: self.playerView.topAnchor).isActive = true
            videoPlayerView.trailingAnchor.constraint(equalTo: self.playerView.trailingAnchor).isActive = true
            self.vedioPlayerHeightAnchor = videoPlayerView.heightAnchor.constraint(equalToConstant: videoHeight)
            self.vedioPlayerHeightAnchor.isActive = true
            viewTopAnchor.isActive = false
            viewTopAnchor.isActive = true
            viewLeadingAnchor.isActive = false
            viewLeadingAnchor.isActive = true
            viewLeadingAnchor.constant = 0.0
            viewTopAnchor.constant = 0.0
            //Add close button on top corner
            self.playerView.addSubview(self.closePlayerButton)
            self.closePlayerButton.anchor(top: self.playerView.topAnchor, leading: nil, bottom: nil, trailing: self.playerView.trailingAnchor, padding: UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 2), size: CGSize(width: 20.0, height: 20.0))
            winowObject.addConstraints([viewLeadingAnchor, viewTopAnchor, viewBottomAnchor,viewLeadingAnchor])
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut) {
                winowObject.layoutIfNeeded()
            } completion: { [weak self](_) in
                self?.playerView.layoutIfNeeded()
            }
            //Add Swipe Down Gesture for video minmize
            self.addSwipeDownGesture()
        }
    }
    
    //MARK:- Add Swipe Gesture
    fileprivate func addSwipeDownGesture() {
         let  _self = self
        //1. Handle Gesture
        let gestureRecognizer = CustomDownSwipeGestureRecognizer {
            if let winowObject = UIApplication.shared.windows.first {
                let intiitalFrameConstant: CGFloat = winowObject.frame.width/4
                _self.viewTopAnchor.constant = winowObject.frame.height - intiitalFrameConstant*2
                _self.viewLeadingAnchor.constant = intiitalFrameConstant*2
                _self.vedioPlayerHeightAnchor.constant = intiitalFrameConstant*1.2
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut) {
                    winowObject.layoutIfNeeded()
                } completion: { [weak self](_) in
                    self?.videoPlayerView.layoutIfNeeded()
                    self?.closePlayerButton.isHidden = false
                }
            }
        }
        //2. Add Swipe Gesture om PlayerView
        self.playerView.addGestureRecognizer(gestureRecognizer)
    }
    
    //MARK:- close player button action
    @objc fileprivate func closePlayer() {
        self.videoPlayerView.stopPlayerWhenReqiured()
        self.videoPlayerView.removeFromSuperview()
        self.videoPlayerView = nil
        self.playerView.removeFromSuperview()
    }
}


