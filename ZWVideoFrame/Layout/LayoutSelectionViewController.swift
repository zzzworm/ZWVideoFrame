//
//  FrameSelectionViewController.swift
//  ZWVideoFrame
//
//  Created by zzzworm on 16/4/27.
//  Copyright © 2016年 zzzworm. All rights reserved.
//


import UIKit
import Ruler
import PageMenu

protocol LayoutPickedFrameDelegate: class {
    func returnSelectedFrame(frame: [LayoutConfig])
}

class LayoutSelectionViewController: PageViewController,UICollectionViewDataSource, UICollectionViewDelegate {

    let layoutCellID = "layoutCell"
    var collectionView : UICollectionView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(NSLocalizedString("Pick frame", comment: ""))"
        
        let layout = UICollectionViewFlowLayout()
        
        let width: CGFloat = Ruler<CGFloat>.iPhoneVertical(77.5, 77.5, 92.5, 102).value
        let height = width
        layout.itemSize = CGSize(width: width, height: height)
        
        let gap: CGFloat = Ruler<CGFloat>.iPhoneHorizontal(5, 5, 5).value
        layout.minimumInteritemSpacing = gap
        layout.minimumLineSpacing = gap
        layout.sectionInset = UIEdgeInsets(top: gap, left: gap, bottom: gap, right: gap)

        
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.alwaysBounceVertical = false
        collectionView.registerClass(FrameCollectionCell.self, forCellWithReuseIdentifier: layoutCellID)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsSelection = true
        collectionView.userInteractionEnabled = true
        self.view.addSubview(collectionView)
        
        let backBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_back"), style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = backBarButtonItem
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemCount = LayoutManager.sharedInstance.layouts.count
        return itemCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(layoutCellID, forIndexPath: indexPath) as! LayoutCollectionCell
        cell.configLayoutConfig(LayoutManager.sharedInstance.layouts[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let layoutConfig = LayoutManager.sharedInstance.layouts[indexPath.row]
        let configRoomVC = LayoutConfigRoomViewController(layoutConfig:layoutConfig)
        let configRoomVC2 = LayoutConfigRoomViewController(layoutConfig:layoutConfig)
        let frameworkspaceVC = BrowserViewController(viewControllers: [ configRoomVC,configRoomVC2])
//        let navRoot = UINavigationController.init()
//        navRoot.navigationBar.backgroundColor = UIColor.clearColor()
//        navRoot.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
//        //        navRoot.navigationBar.translucent = true
//        navRoot.navigationBar.shadowImage = UIImage()
//        navRoot.navigationBar.tintColor = UIColor.blueColor()
//        navRoot.viewControllers = [frameworkspaceVC]
        if let parantNaviController = self.parentNavigationController {
            parantNaviController.navigationBarHidden = false;
            parantNaviController.pushViewController(frameworkspaceVC, animated: true)
        }
    }


    override func updateViewConstraints() {
        super.updateViewConstraints()
        collectionView.autoPinEdgesToSuperviewEdges()
    }

}


extension LayoutSelectionViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == navigationController?.interactivePopGestureRecognizer {
            return true
        }
        return false
    }
}

