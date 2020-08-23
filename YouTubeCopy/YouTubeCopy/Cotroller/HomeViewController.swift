//
//  ViewController.swift
//  YouTubeCopy
//
//  Created by Gagan  Vishal on 8/13/20.
//
//https://developer.apple.com/forums/thread/127825
import UIKit
import Combine
class HomeViewController: UIViewController {
    //supplementry identifier
    fileprivate let headerIdentifier = "header_identifer"
    //    //header header height
    fileprivate let header_height: CGFloat = 60.0
    var switchToContinousFlow: Bool = false
    
    //datasource
    var diffableDataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    //snapshot
    var snapshot: NSDiffableDataSourceSnapshot<Section, Int>! = nil
    //CollectionView
    var collectionView: UICollectionView!  = nil
    //Cancellable for memory handling
    var cancellable: AnyCancellable?
    //More Bottom Action Sheet controller
    lazy var moreBottonActionSheetController: MoreActionBottomSheet = {
        let setting = MoreActionBottomSheet()
        setting.actionRootController = self
        return setting
    }()
    //
    
    //MARK:- View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor  = .white
        //1.
        self.addCutomLeftTitleOnNavigationBar()
        //2.
        self.addCollectionViewOnView()
        //3.
        self.createDataSource()
        //4. Create and apply snapshot
        self.createAndApplySnapshotToDataSource()
        //5. Add Right Bar button items
        self.addRightBarButtonItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK:- Add Right bar button items
    fileprivate func addRightBarButtonItems() {
        //1. Create Button
        let barSearchBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "search_icon"), style: .done, target: self, action: #selector(searchBarButtonAction))
        barSearchBarButton.tintColor = .white
        let moreBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "nav_more_icon"), style: .plain, target: self, action: #selector(moreBarButtonAction))
        moreBarButton.tintColor = .white
        //2. Add buttons
        self.navigationItem.rightBarButtonItems = [moreBarButton, barSearchBarButton]
    }
        
    //MARK:- Search action
    @objc fileprivate func searchBarButtonAction() {
        
    }
    
    //MARK:- Scroll at selected index
    fileprivate func scrollCollection(at index: Int) {
        self.switchToContinousFlow = true
        self.diffableDataSource.apply(self.diffableDataSource.snapshot())
        self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
        self.switchToContinousFlow = false
        self.diffableDataSource.apply(self.diffableDataSource.snapshot())
    }
    
    //MARK:- More button action
    @objc fileprivate func moreBarButtonAction() {
        self.moreBottonActionSheetController.showSettingView()
    }
    
    //MARK:- Add Custom title on NavigationBar
    fileprivate func addCutomLeftTitleOnNavigationBar() {
        self.navigationController?.hidesBarsOnSwipe = true
        let titleLabel = UILabel()
        titleLabel.text = "  Home"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.frame = CGRect(x: 32, y: 0.0, width: self.view.frame.width - 32, height: self.view.frame.height)
        self.navigationItem.titleView = titleLabel
    }
    
    //MARK:- Add CollectionView
    fileprivate func addCollectionViewOnView() {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        self.view.addSubview(self.collectionView)
        self.collectionView.delegate = self
        //1. Add constraint
        self.collectionView.fillSuperview()
        //2.
        self.collectionView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        //3.
        self.collectionView.scrollIndicatorInsets = UIEdgeInsets(top: self.header_height, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    //MARK:- Create Layout
    fileprivate func createCollectionViewLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout.init { (index, envoirnment) -> NSCollectionLayoutSection? in
            let commonSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            
            //1.
            let item = NSCollectionLayoutItem(layoutSize: commonSize)
            //2. Group
            let ccSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: ccSize, subitems: [item])
            //3. Section
            let section =  NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = self.switchToContinousFlow ? .continuousGroupLeadingBoundary : .paging
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(self.header_height))
            let collectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: self.headerIdentifier, alignment: .topLeading)
            collectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 0.0, bottom: 10.0, trailing: 0.0)
            collectionHeader.pinToVisibleBounds = false
            section.boundarySupplementaryItems = [collectionHeader]
            section.visibleItemsInvalidationHandler = ({ (visibleItems, point, env) in
                if  let _ = ReusableHeaderView.sliderLeadingLayoutConstraint {
                    let indexPath = IndexPath(item: Int(point.x/env.container.effectiveContentSize.width), section: 0)
                    ReusableHeaderView.sliderLeadingLayoutConstraint.constant = point.x/4
                    if let header =  self.collectionView.supplementaryView(forElementKind: self.headerIdentifier, at: IndexPath(item: 0, section: 0)) as? ReusableHeaderView {
                        header.selectCell(at: indexPath)
                    }
                }
            })
            return section
        }
    }
        
    //MARK:- Create DataSource
    fileprivate func createDataSource() {
        //1.Cell Registration
        let collectionCell = UICollectionView.CellRegistration<HorizontalCollectionViewCell, Int> { (cell, indexPath, item) in
            cell.homeRootController = self
            cell.selectedIndexPath = indexPath
        }
        
        //2. Supplementry header view
        let heeaderView = UICollectionView.SupplementaryRegistration<ReusableHeaderView>(elementKind: self.headerIdentifier) { (header, kind, indexPath) in
            header.backgroundColor = .blue
            self.cancellable = header.selectedIndexPathSubject.sink { [weak self](index) in
                self?.scrollCollection(at: index)
            }
        }
        
        //3.  Create Data Source
        self.diffableDataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: self.collectionView, cellProvider: { (clView, indexPath, item) -> UICollectionViewCell? in
            return clView.dequeueConfiguredReusableCell(using: collectionCell, for: indexPath, item: item)
        })
        
        //4. Supplementry view
        self.diffableDataSource.supplementaryViewProvider = { (header, kind, indexPath) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: heeaderView, for: indexPath)
        }
    }
    
    //MARK:- Create and Apply DataSoucre
    func createAndApplySnapshotToDataSource() {
        //1. Create snapshot
        self.snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        //2. Add sections
        self.snapshot.appendSections([.main])
        //3. Add items in section
        self.snapshot.appendItems(Array(1...4))
        //4. Apply snashot to DataSource
        self.diffableDataSource.apply(self.snapshot)
    }
    
}

//MARK:- HomeViewController Extension for section
extension HomeViewController {
    enum Section {
        case main
    }
}

//MARK:- ScrollView Delegate
extension HomeViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll")

    }
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        print("scrollViewDidScrollToTop")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
