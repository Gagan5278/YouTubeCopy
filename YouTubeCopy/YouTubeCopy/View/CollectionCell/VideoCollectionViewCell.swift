//
//  VideoCollectionViewCell.swift
//  YouTubeCopy
//
//  Created by Gagan  Vishal on 8/13/20.
//

import UIKit

class VideoCollectionViewCell: BaseCollectionViewCell {
    private let thumbnailImageSize: CGFloat = 40.0
    fileprivate let remvedSpaceAround: CGFloat = 10.0
    //UIActivityIndicatorView for image download progress
    fileprivate let actvityIndicator: UIActivityIndicatorView = {
        let actView = UIActivityIndicatorView()
        actView.startAnimating()
        actView.hidesWhenStopped = true
        actView.style = .large
        actView.color = UIColor.youtubeRedColor
        return actView
    }()
    //imageview for video
    fileprivate let videoImageView: ProfileImageView = {
        let imageView = ProfileImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    //Video Duration Label
    let durationLabel: IntrinsicLabel = {
        let label = IntrinsicLabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    //thumbnail imageeview
    fileprivate let channlThumbnailImageView: ProfileImageView = {
        let imageView = ProfileImageView()
        imageView.layer.cornerRadius = 15 //half of thumbnailImageSize
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "taylor_swift_profile")
        imageView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        return imageView
    }()
    //title label for video
    fileprivate let videoTitaleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    //Description label for video
    fileprivate let videoDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var videoContent: VideoViewModelProtocol!  {
        didSet{
            self.updateVideoContent()
        }
    }
    
    //Conatiner stackview for titleLabel and description label
    fileprivate let vertivalStackViewForTitleAndDescription: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 999), for: .horizontal)
        stackView.axis = .vertical
        return stackView
    }()
    
    //MARK:- Populate data
    private func updateVideoContent() {
        self.videoTitaleLabel.text = self.videoContent.videoTitle
        self.videoDescriptionLabel.text =  self.videoContent.formmattedDescription
        self.videoImageView.downloadImage(from: self.videoContent.videoThumbnailURLString) { [weak self]() in
            self?.actvityIndicator.stopAnimating()
            self?.durationLabel.isHidden = false
            self?.durationLabel.text = self?.videoContent.humanReadbleDuuration
        }
        
        self.channlThumbnailImageView.downloadImage(from: self.videoContent.channelThumbnailURLString) { () in}
    }
    
    //MARK:- view setup
    override func setupCollectionView() {
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowColor = UIColor.lightGray.cgColor
        //1. add items in vertical stackview
        self.vertivalStackViewForTitleAndDescription.addArrangedSubview(self.videoTitaleLabel)
        self.vertivalStackViewForTitleAndDescription.addArrangedSubview(self.videoDescriptionLabel)
        //2.
        self.addSubview(self.vertivalStackViewForTitleAndDescription)
        self.addSubview(self.channlThumbnailImageView)
        NSLayoutConstraint.activate([
            self.channlThumbnailImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.remvedSpaceAround/2),
            self.channlThumbnailImageView.centerYAnchor.constraint(equalTo: self.vertivalStackViewForTitleAndDescription.centerYAnchor),
            self.vertivalStackViewForTitleAndDescription.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.remvedSpaceAround/2),
            self.vertivalStackViewForTitleAndDescription.leadingAnchor.constraint(equalTo: self.channlThumbnailImageView.trailingAnchor, constant: self.remvedSpaceAround/2),
            self.vertivalStackViewForTitleAndDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.remvedSpaceAround/2),
            self.channlThumbnailImageView.heightAnchor.constraint(lessThanOrEqualToConstant: self.thumbnailImageSize - self.remvedSpaceAround),
            self.channlThumbnailImageView.widthAnchor.constraint(lessThanOrEqualToConstant: self.thumbnailImageSize - self.remvedSpaceAround)

        ])
        //3.
        self.addSubview(self.videoImageView)
        videoImageView.addConstraint(NSLayoutConstraint(item: videoImageView,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: videoImageView,
                                                  attribute: .width,
                                                  multiplier: 9.0 / 16.0,
                                                  constant: 0))
        //4.
        self.videoImageView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.vertivalStackViewForTitleAndDescription.topAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top:  0.0, left: 0.0, bottom: self.remvedSpaceAround/2, right: 0.0))
        //5.
        self.videoImageView.addSubview(self.actvityIndicator)
        self.actvityIndicator.centerInSuperview()
        //6.
        self.videoImageView.addSubview(self.durationLabel)
        self.durationLabel.anchor(top: nil, leading: nil, bottom: self.videoImageView.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: self.remvedSpaceAround, right: self.remvedSpaceAround))
    }
}
