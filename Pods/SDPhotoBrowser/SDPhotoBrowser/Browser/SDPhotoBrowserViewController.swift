//
//  SDPhotoBrowserViewController.swift
//  lolbox
//
//  Created by Sunny on 2017/3/1.
//  Copyright © 2017年 duowan. All rights reserved.
//

import UIKit


enum SDButtonPosition: Int {
    case leftOne  = 1
    case leftTwo  = 2
    case rightOne = 3
    case rightTwo = 4
}


@objc protocol SDPhotoBrowserViewControllerDelegate: class {
    
    @objc optional func toolBarOfSize(in photoBrowser: SDPhotoBrowserViewController) -> CGSize
    
    @objc optional func toolBarOfCustom(in photoBrowser: SDPhotoBrowserViewController, _ size: CGSize) -> UIView
    
    @objc optional func photoBrowser(_ photoBrowser: SDPhotoBrowserViewController, didChangedToPageAtIndex index: Int)
}

class SDPhotoBrowserViewController: UIViewController {

    fileprivate lazy var collectionView: UICollectionView = {[unowned self] in
        
        let customFlowLayout = UICollectionViewFlowLayout()
//        customFlowLayout.itemSize = CGSize(width: kSDScreenWidth + kSDPhotoBrowserMargin, height: kSDScreenHeight)
        customFlowLayout.scrollDirection = .horizontal
        customFlowLayout.minimumLineSpacing = 0
        customFlowLayout.minimumInteritemSpacing = 0
        
        // 分页每次滚动 UICollectionView.bounds.size.width
        let collectionView = UICollectionView(frame: CGRect(x: 0.0, y: 0.0, width: kSDScreenWidth + kSDPhotoBrowserMargin, height: kSDScreenHeight), collectionViewLayout: customFlowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.black
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(SDPhotoBrowserCollectionViewCell.self, forCellWithReuseIdentifier: SDPhotoBrowserCollectionViewCell.sd_reuseIdentifier)
        return collectionView
    }()
    
    fileprivate lazy var navBar: SDNavBar = { [unowned self] in
    
        let navBar = SDNavBar()
        navBar.isHidden = self.isHiddenNavBar
        navBar.leftOneButton.isHidden = self.isHiddenBackButton
        navBar.leftTwoButton.isHidden = self.isHiddenLeftTwoButton
        navBar.rightOneButton.isHidden = self.isHiddenRightOneButton
        navBar.rightTwoButton.isHidden = self.isHiddenRightTwoButton
        navBar.letfOneButtonClosure = {
            
            if self.navigationController != nil {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        return navBar
    }()
    
    fileprivate let SDPhotoBrowserAnimationDuration: TimeInterval = 0.35
    
    fileprivate var isShownavBar: Bool = false
    
    fileprivate var navBarTopMarginConstraint: NSLayoutConstraint!
    
    fileprivate var toolBarBottomMarginConstraint: NSLayoutConstraint?
    
    fileprivate var toolBarHeight: CGFloat = 0

    fileprivate var toolView: UIView?
    
    fileprivate var toolViewSize: CGSize?
    
    fileprivate var startIndex: Int = 0
    
    fileprivate var isOritenting = false
    
    var delegate: SDPhotoBrowserViewControllerDelegate?
    
    var photoUrlArray: [URL]?
    
    // Default false
    var isHiddenNavBar: Bool = false
    
    // Default false
    var isHiddenBackButton: Bool = false
    
    // Default true
    var isHiddenLeftTwoButton: Bool = true
    
    // Default true
    var isHiddenRightOneButton: Bool = true
    
    // Default true
    var isHiddenRightTwoButton: Bool = true
    
    // System Methods
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all
    }

    
    public init(WithPhotoUrlArray photoUrlArray: [URL]?, startIndex: Int, delegate: SDPhotoBrowserViewControllerDelegate?) {
        
        self.photoUrlArray = photoUrlArray
        self.startIndex = startIndex
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        self.view.addSubview(collectionView)
        self.view.addSubview(navBar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK:- Lifecycle
extension SDPhotoBrowserViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor.black
        automaticallyAdjustsScrollViewInsets = false
        
        if let delegate = self.delegate,
            let toolViewSize = delegate.toolBarOfSize?(in: self),
            let toolView = delegate.toolBarOfCustom?(in: self, toolViewSize) {
            
            self.toolView = toolView
            self.toolViewSize = toolViewSize
            view.addSubview(toolView)
            
            delegate.photoBrowser?(self, didChangedToPageAtIndex: getCurrentIndex())
        }
        
        collectionView.scrollToItem(at: IndexPath(item: self.startIndex, section: 0), at: .left, animated: false)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.alpha = 0.0
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isOritenting {
            currentIndex(getCurrentIndex(), animated: false)
            isOritenting = false
            
            if let navigationBar = self.navigationController?.navigationBar {
                navigationBar.alpha = 0.0
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        isOritenting = true
        
        collectionView.collectionViewLayout.invalidateLayout()
    }

}

// MARK:- Public Methods
extension SDPhotoBrowserViewController {
    
    func config(named name: String, of position: SDButtonPosition, callBack: (() -> Void)?) {
        
        switch position {
        case .leftOne:
            navBar.leftOneButton.setImage(UIImage(named: name), for: .normal)
            navBar.letfOneButtonClosure = callBack
        case .leftTwo:
            navBar.leftTwoButton.setImage(UIImage(named: name), for: .normal)
            navBar.letfTwoButtonClosure = callBack
        case .rightOne:
            navBar.rightOneButton.setImage(UIImage(named: name), for: .normal)
            navBar.rightOneButtonClosure = callBack
        case .rightTwo:
            navBar.rightTwoButton.setImage(UIImage(named: name), for: .normal)
            navBar.rightTwoButtonClosure = callBack
        }
    }
    
}

// MARK:- Private Methods
fileprivate extension SDPhotoBrowserViewController {

    func setupUI() {
    
        collectionView.collectionViewLayout.invalidateLayout()
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1.0, constant: kSDPhotoBrowserMargin))
        view.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1.0, constant: 0))
        
        
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBarTopMarginConstraint = NSLayoutConstraint(item: navBar, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: -kSDNavigationBarHeight)
        view.addConstraint(navBarTopMarginConstraint)
        view.addConstraint(NSLayoutConstraint(item: navBar, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: navBar, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: kSDScreenWidth))
        view.addConstraint(NSLayoutConstraint(item: navBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: kSDNavigationBarHeight))
        
        
        if let toolView = self.toolView,
            let toolViewSize = self.toolViewSize {
            
            view.bringSubview(toFront: toolView)
            toolView.translatesAutoresizingMaskIntoConstraints = false
            
            let bottomConstraint = NSLayoutConstraint(item: toolView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: toolViewSize.height)
            toolBarBottomMarginConstraint = bottomConstraint
            toolBarHeight = toolViewSize.height
            view.addConstraint(bottomConstraint)
            view.addConstraint(NSLayoutConstraint(item: toolView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: toolView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: toolViewSize.width))
            view.addConstraint(NSLayoutConstraint(item: toolView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: toolViewSize.height))
        }
    }
    
    func getCurrentIndex() -> Int {
        
        return Int(collectionView.contentOffset.x / (collectionView.bounds.size.width))
    }
    
    func currentIndex(_ currentIndex: Int, animated: Bool) {
        
        guard let photoUrlArray = self.photoUrlArray else { return }
        
        if currentIndex < 0 || currentIndex >= photoUrlArray.count { return }
        
        collectionView.setContentOffset(CGPoint(x: CGFloat(currentIndex) * collectionView.bounds.size.width, y: 0.0), animated: animated)
    }
}

// MARK:- UICollectionViewDataSource
extension SDPhotoBrowserViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoUrlArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SDPhotoBrowserCollectionViewCell.sd_reuseIdentifier, for: indexPath) as! SDPhotoBrowserCollectionViewCell
        cell.sd_config(of: photoUrlArray?[indexPath.item], withIndexPath: indexPath)
        cell.singleTapImageClosure = { [unowned self] (index) in
            
            self.isShownavBar = !self.isShownavBar
            if self.isShownavBar {
                UIView.animate(withDuration: kSDAnimationDuration, animations: { 
                    self.navBarTopMarginConstraint.constant = 0
                    self.toolBarBottomMarginConstraint?.constant = 0
                    self.view.layoutIfNeeded()
    
                })
            } else {
                UIView.animate(withDuration: kSDAnimationDuration, animations: {
                    self.navBarTopMarginConstraint.constant = -kSDNavigationBarHeight
                    self.toolBarBottomMarginConstraint?.constant = self.toolBarHeight
                    self.view.layoutIfNeeded()
                })
            }
        }
        return cell
    }
}


// MARK:- UICollectionViewDelegate
extension SDPhotoBrowserViewController: UICollectionViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if let delegate = self.delegate {
            delegate.photoBrowser?(self, didChangedToPageAtIndex: getCurrentIndex())
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    
        if let currentCell = cell as? SDPhotoBrowserCollectionViewCell {
            currentCell.resetZoomSacle()
        }
    }

}

// MARK:- UICollectionViewDelegateFlowLayout
extension SDPhotoBrowserViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.bounds.size
    }
}

