//
//  SettingController.swift
//  YouTubeCopy
//
//  Created by Gagan  Vishal on 8/14/20.
//
//https://gist.github.com/vikaskore/780ccf2e5187937d6ae9d7bbdf9b1509
import UIKit

class MoreActionBottomSheet: NSObject {
    fileprivate var dataSource: UICollectionViewDiffableDataSource<Section, Settings>! = nil
    fileprivate var snapshot: NSDiffableDataSourceSnapshot<Section, Settings>! = nil
    //CollectionView Height
    fileprivate let collectionViewHeight: CGFloat = CGFloat(Settings.settings.count*50)
    //CollectionView on tranparent black view
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createCollectionListStyle())
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        return collectionView
    }()
    //action root controller
    weak var actionRootController: UIViewController?
    var viewSettingObject: UIView! = nil

    //MARK:- init
    override init() {
        super.init()
    }
    
    //MARK:- Add setting View
     func showSettingView() {
        if let winowObject = UIApplication.shared.windows.first {
            //BlackView
            self.viewSettingObject = UIView()
            self.viewSettingObject.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            self.viewSettingObject.frame = winowObject.frame
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideViewOnTapped(sender:)))
            tapGesture.delegate = self
            self.viewSettingObject.addGestureRecognizer(tapGesture)
            winowObject.addSubview(self.viewSettingObject)
            //add collectionview on black transparent view
            self.viewSettingObject.addSubview(collectionView)
            //
            collectionView.frame = CGRect(x: 0.0, y: self.viewSettingObject.frame.height, width: self.viewSettingObject.frame.width, height: collectionViewHeight)
            self.createDataSoucrceAndApplySnapshot()
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: .curveEaseOut) { [weak self] in
                self?.collectionView.frame = CGRect(x: 0.0, y: self!.viewSettingObject.frame.height - self!.collectionViewHeight, width: (self?.viewSettingObject.frame.width)!, height: self!.collectionViewHeight)
            } completion: { (_) in}
        }
    }
    
    //MARK:- Tap Gesture
     @objc fileprivate func hideViewOnTapped(sender: UITapGestureRecognizer) {
        if let viewSetting = sender.view {
            self.hideActionSheet(senderView: viewSetting)
        }
    }
    
    //MARK:- Hide Sheet Action
    fileprivate func hideActionSheet(senderView: UIView, pushController: UIViewController? = nil) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.collectionView.frame = CGRect(x: 0.0, y: senderView.frame.height , width: senderView.frame.width, height: self!.collectionViewHeight)
        } completion: { (_) in
            senderView.alpha = 0.0
            senderView.isHidden = true
            if let controller = pushController {
                self.actionRootController?.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    //MARK:- DataSource Setupa and snapshot
    fileprivate func createDataSoucrceAndApplySnapshot() {
        //1. CellRegistration
        let cell = UICollectionView.CellRegistration<SettingCollectionViewCell, Settings> { (cell, indexPath, item) in
            cell.didSetupView(for: item)
        }
        //2. Create DataSource
        self.dataSource = UICollectionViewDiffableDataSource<Section, Settings>(collectionView: self.collectionView, cellProvider: { (clView, indexPath, item) -> UICollectionViewCell? in
            return clView.dequeueConfiguredReusableCell(using: cell, for: indexPath, item: item)
        })
        //3.Create and apply snapshot
        self.snapshot = NSDiffableDataSourceSnapshot<Section, Settings>()
        self.snapshot.appendSections([.main])
        self.snapshot.appendItems(Settings.settings)
        self.dataSource.apply(self.snapshot)
    }
    
    //MARK:- Creating layout
    fileprivate func createCollectionListStyle() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = false
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}

extension MoreActionBottomSheet {
    fileprivate enum Section {
        case main
    }
}

//MARK:- UIGestureRecogniser Delegate
extension MoreActionBottomSheet: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchOnCollection = touch.view?.isDescendant(of: self.collectionView), touchOnCollection == true  {
            return false
        }
        return true
    }
}

//MARK:- UICollectionView Delegate
extension MoreActionBottomSheet: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let setting = self.dataSource.itemIdentifier(for: indexPath) {
            if let pushedController =  setting.router {
                let controller = pushedController.init()
                controller.title = setting.settingName
                self.hideActionSheet(senderView: self.viewSettingObject, pushController: controller )
            }
            else {
                self.hideActionSheet(senderView: self.viewSettingObject)
            }
        }
    }
}
