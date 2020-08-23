//
//  HorizontalCollectionViewCell.swift
//  YouTubeCopy
//
//  Created by Gagan  Vishal on 8/15/20.
//

import UIKit
import Combine

class HorizontalCollectionViewCell: BaseCollectionViewCell {
    //datasource
    fileprivate var diffableDataSource: UICollectionViewDiffableDataSource<Section, VideoModel>! = nil
    //snapshot
    fileprivate var snapshot: NSDiffableDataSourceSnapshot<Section, VideoModel>! = nil
    //CollectionView
    var collectionView: UICollectionView!  = nil
    //VideoViewModel Objcet
    var videoModel = VideoViewModel()
    //Cancellable for memory handling
    var cancellable: AnyCancellable?
    //var home root controller
    weak var homeRootController: UIViewController! = nil
    //selected index path on HomeController
     lazy var selectedIndexPath: IndexPath = IndexPath(row: 0, section: 0) {
        didSet {
            bindViewModel()
            self.diffableDataSource.apply(self.diffableDataSource.snapshot())
        }
    }
    //MARK:-
    override func setupCollectionView() {
        super.setupCollectionView()
        //1.
        self.addCollectionViewOnView()
        //2.
        self.createDataSource()
        //3.
        self.createAndApplySnapshotToDataSource()
    }
    
    //MARK:- Bind View Model
    fileprivate func bindViewModel() {
        //1. Fetch Request
        self.videoModel.fetchVideoListFromServer(cellLoaded: CollectionCell(rawValue: self.selectedIndexPath.row) ?? CollectionCell.feed)
        //2.
        self.cancellable = self.videoModel.collectionReloadSignalPassthroughSubject.sink { [weak self](isSuccess) in
            if isSuccess {
                self?.createAndApplySnapshotToDataSource()
            }
        }
    }
    
    // MARK:- Create Layout
    fileprivate func addCollectionViewOnView() {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        self.collectionView.delegate = self
        self.addSubview(self.collectionView)
        //1. Add constraint
        self.collectionView.fillSuperview(padding: UIEdgeInsets(top: 0, left: 0, bottom: header_height(), right: 0))
        //2.
        self.collectionView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
    }
    
    //MARK:- Header hieight. 60 + Height of statusbar
    fileprivate func header_height() -> CGFloat {
        return 60.0 + UIApplication.statusBarHeight
    }
    
    //MARK:- Create Layout
    fileprivate func createCollectionViewLayout() -> UICollectionViewLayout {
        let groupPadding: CGFloat = 10.0
        let esitmatedSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(400))
        //1.
        let item = NSCollectionLayoutItem(layoutSize: esitmatedSize)
        //2. Group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: esitmatedSize, subitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: groupPadding, bottom: 0.0, trailing: groupPadding)
        //3. Section
        let section =  NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        //4.
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    //MARK:- Create DataSource
    fileprivate func createDataSource() {
        //1.Cell Registration
        let collectionCellFeed = UICollectionView.CellRegistration<VideoCollectionViewCell, VideoModel> { (cell, indexPath, item) in
            cell.videoContent = item
            cell.backgroundColor = .white
        }
        
        //2.
        let collectionCellTrending = UICollectionView.CellRegistration<TrendingCollectionViewCell, VideoModel> { (cell, indexPath, item) in
            cell.videoContent = item
            cell.backgroundColor = .white
        }
        
        //3. Subscription
        let collectionCellSubscription = UICollectionView.CellRegistration<SubscriptionCollectionViewCell, VideoModel> { (cell, indexPath, item) in
            cell.videoContent = item
            cell.backgroundColor = .white
        }
        
        //2.  Create Data Source
        self.diffableDataSource = UICollectionViewDiffableDataSource<Section, VideoModel>(collectionView: self.collectionView, cellProvider: { (clView, indexPath, item) -> UICollectionViewCell? in
               if let cellItem = CollectionCell(rawValue: self.selectedIndexPath.row) {
                switch cellItem {
                case .feed:
                    return clView.dequeueConfiguredReusableCell(using: collectionCellFeed, for: indexPath, item: item)
                case .trending:
                    return clView.dequeueConfiguredReusableCell(using: collectionCellTrending, for: indexPath, item: item)
                case .subscriptions:
                    return clView.dequeueConfiguredReusableCell(using: collectionCellSubscription, for: indexPath, item: item)
                }
            }
            return clView.dequeueConfiguredReusableCell(using: collectionCellFeed, for: indexPath, item: item)
        })
        
    }
    
    //MARK:- Create and Apply DataSoucre
    fileprivate func createAndApplySnapshotToDataSource() {
        //1. Create snapshot
        self.snapshot = NSDiffableDataSourceSnapshot<Section, VideoModel>()
        //2. Add sections
        self.snapshot.appendSections([.main])
        //3. Add items in section
        self.snapshot.appendItems(videoModel.allVideos)
        //4. Apply snashot to DataSource
        self.diffableDataSource.apply(self.snapshot)
    }
}

extension HorizontalCollectionViewCell {
    fileprivate enum Section {
        case main
    }
}

//MARK:- UICollectionViewDelegate
extension HorizontalCollectionViewCell: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pan = scrollView.panGestureRecognizer
        let velocity = pan.velocity(in: scrollView).y
        if let superViewController = self.homeRootController {
            if velocity < -5 {
                superViewController.navigationController?.setNavigationBarHidden(true, animated: true)
            } else if velocity > 5 {
                superViewController.navigationController?.setNavigationBarHidden(false, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoPlayerObject = VideoPlayerView()
        videoPlayerObject.addPayerOnWindow()
    }
}

