//
//  FrameSelectionViewController.swift
//  ZWVideoFrame
//
//  Created by zzzworm on 16/4/27.
//  Copyright © 2016年 zzzworm. All rights reserved.
//


import UIKit
import Ruler

protocol ReturnPickedFrameDelegate: class {
    func returnSelectedFrame(frame: [Frame])
}

class FrameSelectionViewController: UICollectionViewController {

    let photoCellID = "PhotoCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(NSLocalizedString("Pick frame", comment: ""))"
        
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.alwaysBounceVertical = true
        collectionView?.registerNib(UINib(nibName: photoCellID, bundle: nil), forCellWithReuseIdentifier: photoCellID)
        
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            
            let width: CGFloat = Ruler<CGFloat>.iPhoneVertical(77.5, 77.5, 92.5, 102).value
            let height = width
            layout.itemSize = CGSize(width: width, height: height)
            
            let gap: CGFloat = Ruler<CGFloat>.iPhoneHorizontal(1, 1, 1).value
            layout.minimumInteritemSpacing = gap
            layout.minimumLineSpacing = gap
            layout.sectionInset = UIEdgeInsets(top: gap, left: gap, bottom: gap, right: gap)
        }
        
        let backBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_back"), style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = backBarButtonItem
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(photoCellID, forIndexPath: indexPath) as! FrameCollectionCell
        return cell
    }
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
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
