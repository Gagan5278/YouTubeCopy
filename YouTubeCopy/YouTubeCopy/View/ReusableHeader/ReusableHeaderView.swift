//
//  ReusableHeaderView.swift
//  YouTubeCopy
//
//  Created by Gagan  Vishal on 8/13/20.
//

import UIKit
import Combine
class ReusableHeaderView: UICollectionReusableView {
    fileprivate let cell_identifier = "cell_identifier"
    fileprivate var diffableDataSource: UICollectionViewDiffableDataSource<Sectoin, Int>! = nil
    fileprivate var snapshot: NSDiffableDataSourceSnapshot<Sectoin, Int>! = nil
    //
    let selectedIndexPathSubject = PassthroughSubject<Int, Never>()
    //collectionview object
    lazy var menuCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.youtubeRedColor
        return collectionView
    }()
    //bottom slider view
    let bottomSlideBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private let bottomSlideBarHeightConstant: CGFloat = 2.0
    //Leading layout constraint for slider
    static var sliderLeadingLayoutConstraint: NSLayoutConstraint! = nil
    //MARK:- View Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionViewSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK:- Collection View Setup
    fileprivate func collectionViewSetup() {
        //1.
        self.addSubview(self.menuCollectionView)
        self.menuCollectionView.fillSuperview()
        //2.
        self.setupDataSource()
        //3.
        createAndApplySnapshot()
        //4.
        self.selectCell(at: IndexPath(item: 0, section: 0))
        //5.
        self.addSubview(self.bottomSlideBar)
        bottomSlideBar.anchor(top: nil, leading: nil, bottom: self.bottomAnchor, trailing: nil, size: CGSize(width: self.frame.width/4, height: self.bottomSlideBarHeightConstant*2))
        ReusableHeaderView.sliderLeadingLayoutConstraint = bottomSlideBar.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ReusableHeaderView.sliderLeadingLayoutConstraint.isActive = true
    }
    
    //MARK:- Data Source setup
    fileprivate func setupDataSource() {
        //1. Cell Registration
        let cell =  UICollectionView.CellRegistration<MenuCollectionViewCell, Int> { (cell, indexPath, item) in
            cell.setImage(at: indexPath.row)
        }
        
        //2. DataSource
        self.diffableDataSource = UICollectionViewDiffableDataSource<Sectoin, Int>(collectionView: self.menuCollectionView, cellProvider: { (clView, indexPath, item) -> UICollectionViewCell? in
            return clView.dequeueConfiguredReusableCell(using: cell, for: indexPath, item: item)
        })
    }
    
    //MARK:- Layout
    fileprivate func createLayout() -> UICollectionViewLayout {
        let commonize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        //1.
        let item = NSCollectionLayoutItem(layoutSize: commonize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        //2.
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: commonize, subitem:item, count: 4)
        //3. Section
        let section = NSCollectionLayoutSection(group: group)
        //4. Group
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    //MARK:- Create and apply snapshot
    fileprivate func createAndApplySnapshot() {
        //1.Create Snapshot
        self.snapshot = NSDiffableDataSourceSnapshot<Sectoin, Int>()
        //2. Append Section
        self.snapshot.appendSections([.main])
        //3. Append items
        self.snapshot.appendItems(Array(1...4))
        //4.
        self.diffableDataSource.apply(self.snapshot)
    }
    
    func sliderAnimation(_ indexPath: IndexPath) {
        //1.get x position
        let sliderXPosition = (CGFloat(indexPath.item) * self.frame.width)/4.0
        ReusableHeaderView.sliderLeadingLayoutConstraint.constant =  sliderXPosition
        //2. apply animation
        UIView.animate(withDuration: 0.60, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    //MARK:- select cell at index path
    func selectCell(at indexPath: IndexPath){
        self.menuCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
}

//MARK:- CollectionView Setup
extension ReusableHeaderView {
    fileprivate enum Sectoin {
        case main
    }
}

//MARK:- UICollectionView Delegate
extension ReusableHeaderView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //1.
        self.sliderAnimation(indexPath)
        //2.send to collection scroll at given index
        self.selectedIndexPathSubject.send(indexPath.row)
    }
}
