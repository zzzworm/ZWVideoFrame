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
    func returnSelectedFrame(frame: [FrameConfig])
}

class FrameSelectionViewController: CardViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    let frameCellID = "frameCell"
    var collectionView : UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(NSLocalizedString("Pick frame", comment: ""))"
        
        let layout = UICollectionViewFlowLayout()
        
        let width: CGFloat = Ruler<CGFloat>.iPhoneVertical(77.5, 77.5, 92.5, 102).value
        let height = width
        layout.itemSize = CGSize(width: width, height: height)
        
        let gap: CGFloat = Ruler<CGFloat>.iPhoneHorizontal(1, 1, 1).value
        layout.minimumInteritemSpacing = gap
        layout.minimumLineSpacing = gap
        layout.sectionInset = UIEdgeInsets(top: gap, left: gap, bottom: gap, right: gap)

        
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.alwaysBounceVertical = true
        collectionView.registerNib(UINib.init(nibName: "FrameCollectionCell", bundle: nil), forCellWithReuseIdentifier:frameCellID)
        collectionView.dataSource = self
        collectionView.delegate = self
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
        cell.frameConfig = FrameManager.sharedInstance.frames[indexPath.row]
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
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

extension FrameSelectionViewController:UICollectionViewDelegateFlowLayout
{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize.init(width: 80, height: 80);
    }
}
