//
//  YouTubeVideoPlayer.swift
//  YouTubeCopy
//
//  Created by Gagan  Vishal on 8/22/20.
//

import UIKit
import AVFoundation
import WebKit
class YouTubeVideoPlayer: UIView {
    fileprivate let padding: CGFloat = 5.0
    //Obsever Key for Video Player
    fileprivate let playerObserverKey = "currentItem.loadedTimeRanges"
    //View to hold video controller e.g. slider timerer
    fileprivate lazy var playerControllerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    //Activity Indicator to display video load progress
    fileprivate let activityIndicator: UIActivityIndicatorView = {
        let act = UIActivityIndicatorView()
        act.style = .large
        act.color = .youtubeRedColor
        act.startAnimating()
        act.hidesWhenStopped = true
        act.translatesAutoresizingMaskIntoConstraints = false
        return act
    }()
    
    //AVPlayerLayer object for playing videos
    fileprivate lazy var playerView: AVPlayerLayer? = {
       
        if let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/flutterapp-d1066.appspot.com/o/sample%2Fvideoplayback%20(1).mp4?alt=media&token=70a234b6-7cf8-4438-8f12-58aef248e298") {
            let player = AVPlayer(url:  url)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = frame
            player.play()
            player.addObserver(self, forKeyPath: self.playerObserverKey, options: [.new, .old], context: nil)
            return playerLayer
        }
        return AVPlayerLayer()
    }()
    
    //Add a drop shadow on bottom of playerControllerView
    fileprivate var shadowLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.5).cgColor]
        gradientLayer.locations = [0.9, 1.1]
        return gradientLayer
    }()
    
    fileprivate lazy var playPauseButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "play.circle")!, for: .normal)
        button.setImage(UIImage(systemName: "pause.circle")!, for: .selected)
        button.isSelected = true
        button.tintColor = .gray
        button.isHidden = true
        button.addTarget(self, action: #selector(videoPlayPauseAction(_:)), for: .touchUpInside)
        return button
    }()
    // Remaining time label
    fileprivate let remainingDurationTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font  = .systemFont(ofSize: 12)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ":/:"
        return label
    }()
    
    // Total time label
    fileprivate let totalTimeDurationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .right
        label.text = ":/:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font  = .systemFont(ofSize: 12)
        return label
    }()
    
    //Video progress slider
    fileprivate lazy var videoPogressSlider: UISlider = {
        let slider = UISlider()
        slider.isUserInteractionEnabled = false
        slider.minimumTrackTintColor = .white
        slider.maximumTrackTintColor = .youtubeRedColor
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(videoSliderAction(slider:)), for: .valueChanged)
        return slider
    }()
    
    //StackView to handle contoller componenets
    fileprivate let horizonatalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 5.0
        stackView.addBackground()
        return stackView
    }()
    /*
    lazy var playerWebkit: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        let webkit = WKWebView(frame: .zero, configuration: configuration)
        webkit.isUserInteractionEnabled = true
        webkit.navigationDelegate = self
        webkit.backgroundColor = UIColor.youtubeRedColor.withAlphaComponent(0.1)
        return webkit
    }()
    */
    //MARK:- View life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        //1.
        addLayerAndPlayVideo()
        //2. Add Gradient
        addGradientOnView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateFrames()
        /*
        playerWebkit.frame = self.bounds
        */
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    override func setNeedsUpdateConstraints() {
        super.setNeedsUpdateConstraints()
    }
    //MARK:- Update frame
    func updateFrames(){
        playerView?.frame = self.frame
        self.shadowLayer.frame =  self.bounds
        playerControllerView.fillSuperview()
    }
    
    //MARK:- Add View components
    fileprivate func addLayerAndPlayVideo() {
        /*
        self.addSubview(playerWebkit)
        playerWebkit.fillSuperview()
        guard let url = URL(string: "https://www.youtube.com/embed/GOiIxqcbzyM?playsinline=1?autoplay=1") else {
            return
        }
        
        playerWebkit.load(URLRequest(url: url))
        playerWebkit.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
         */
        //1. Player Setup
        if let playerLayer = self.playerView {
            playerLayer.frame = self.bounds;
            self.layer.addSublayer(playerLayer);
            playerLayer.player?.play()
        }

        //2. Player Controller view
        self.addSubview(self.playerControllerView)
        self.playerControllerView.fillSuperview()
        //3. Activity Indicator
        self.playerControllerView.addSubview(self.activityIndicator)
        self.activityIndicator.centerInSuperview()
        //4. Add Controller
        self.horizonatalStackView.addArrangedSubview(self.remainingDurationTimeLabel)
        self.horizonatalStackView.addArrangedSubview(self.videoPogressSlider)
        self.horizonatalStackView.addArrangedSubview(self.totalTimeDurationLabel)
        self.playerControllerView.addSubview(self.horizonatalStackView)
        self.horizonatalStackView.anchor(top: nil, leading: self.leadingAnchor, bottom: self.playerControllerView.bottomAnchor, trailing: self.playerControllerView.trailingAnchor, padding: UIEdgeInsets(top: 0.0, left: self.padding, bottom: 0.0, right: self.padding), size: CGSize(width: 0.0, height: self.videoPogressSlider.frame.height + self.padding))
        //5.
        self.playerControllerView.addSubview(self.playPauseButton)
        self.playPauseButton.centerInSuperview(size: CGSize(width: 60.0, height: 60.0))
        //6.
        self.videoProgressTrack()
    }
    
    //MARK:- Stop player and remove instance
    func stopPlayerWhenReqiured(){
        if let player = self.playerView?.player {
            player.pause()
            self.playerView?.player = nil
            self.playerView = nil
        }
    }
    //MARK:- Video Slider Action
    @objc fileprivate func videoSliderAction(slider: UISlider) {
        if let player = self.playerView?.player, let totalDuration = player.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(totalDuration)
            let currectSeekState =  Int64(slider.value * Float(totalSeconds))
            player.seek(to: CMTime(value: currectSeekState, timescale: 1))
        }
    }
    
    //MARK:- Videe Play Pause Action
    @objc fileprivate func videoPlayPauseAction(_ sender: UIButton) {
        if let player = self.playerView?.player {
            if sender.isSelected {
                player.pause()
            }
            else {
                player.play()
            }
            sender.isSelected = !sender.isSelected
        }
    }
    
    //MARK:- Video Progress
    fileprivate func videoProgressTrack() {
        if let player = self.playerView?.player {
            let cmTime = CMTime(value: 1, timescale: 2)
            player.addPeriodicTimeObserver(forInterval: cmTime, queue: DispatchQueue.main) { (cmTime) in
                self.remainingDurationTimeLabel.text = Int(CMTimeGetSeconds(cmTime)).timeDurationDisplay()
                self.videoPogressSlider.value = Float(CMTimeGetSeconds(cmTime) /  CMTimeGetSeconds(player.currentItem?.duration ?? cmTime))
            }
        }
    }
    
    //MARK:- Observer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == self.playerObserverKey {
            updateViewsStateAndUIAfterVideoPlayStarted()
            if let player = self.playerView?.player, let totalDuration = player.currentItem?.duration {
                self.totalTimeDurationLabel.text = Int(CMTimeGetSeconds(totalDuration)).timeDurationDisplay()
            }
        }
    }
    
    //MARK:- Add Gradient
    fileprivate func addGradientOnView(){
        self.playerControllerView.layer.addSublayer(self.shadowLayer)
    }
    
    //MARK:- Update Video components once video starts playing
    fileprivate func updateViewsStateAndUIAfterVideoPlayStarted() {
//        playerView.frame = self.frame
        self.activityIndicator.stopAnimating()
        self.playPauseButton.isHidden = false
        self.videoPogressSlider.isUserInteractionEnabled = true
        self.playerControllerView.backgroundColor = .clear
    }
}

/*
extension YouTubeVideoPlayer: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
}
*/


