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

protocol ReturnPickedFrameDelegate: class {
    func returnSelectedFrame(frame: [FrameConfig])
}

class FrameSelectionViewController: PageViewController,UICollectionViewDataSource, UICollectionViewDelegate {

    let frameCellID = "frameCell"
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
        collectionView.registerClass(FrameCollectionCell.self, forCellWithReuseIdentifier: frameCellID)
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
        let itemCount = FrameManager.sharedInstance.frames.count
        return itemCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(frameCellID, forIndexPath: indexPath) as! FrameCollectionCell
        cell.configFrameConfig(FrameManager.sharedInstance.frames[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let frameConfig = FrameManager.sharedInstance.frames[indexPath.row]
        let configRoomVC = FrameConfigRoomViewController(frameConfig:frameConfig)
        let configRoomVC2 = FrameConfigRoomViewController(frameConfig:frameConfig)
        let frameworkspaceVC = BrowserViewController(viewControllers: [ configRoomVC,configRoomVC2])
        self.presentViewController(frameworkspaceVC, animated: true, completion: nil)
        if let parantNaviController = self.parentNavigationController {
            parantNaviController.pushViewController(configRoomVC, animated: true)
        }
    }


    override func updateViewConstraints() {
        super.updateViewConstraints()
        collectionView.autoPinEdgesToSuperviewEdges()
    }

}


extension FrameSelectionViewController: UIGestureRecognizerDelegate {
    
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

