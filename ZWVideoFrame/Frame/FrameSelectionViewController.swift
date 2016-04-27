//
//  FrameSelectionViewController.swift
//  ZWVideoFrame
//
//  Created by zzzworm on 16/4/27.
//  Copyright © 2016年 zzzworm. All rights reserved.
//


import UIKit
import Ruler
import FDTake

protocol ReturnPickedFrameDelegate: class {
    func returnSelectedFrame(frame: [FrameConfig])
}

class FrameSelectionViewController: CardViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    let frameCellID = "frameCell"
    var collectionView : UICollectionView!
    var fdTakeController : FDTakeController?
    
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
        collectionView.registerClass(FrameCollectionCell.self, forCellWithReuseIdentifier: frameCellID)
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
        cell.configFrameConfig(FrameManager.sharedInstance.frames[indexPath.row])
        cell.actionHanler = {
            (sender:AnyObject?) -> Void in
            if nil == self.fdTakeController {
                self.fdTakeController = FDTakeController()
            }
            let fdTakeVc = self.fdTakeController!
            
            fdTakeVc.allowsPhoto = true
            fdTakeVc.allowsVideo = true
            fdTakeVc.allowsTake = true
            fdTakeVc.allowsSelectFromLibrary = true
            fdTakeVc.allowsEditing = false
            fdTakeVc.defaultsToFrontCamera = true
            fdTakeVc.iPadUsesFullScreenCamera = true
            fdTakeVc.didDeny = {
                let alert = UIAlertController(title: "Denied", message: "User did not select a photo/video", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.fdTakeController!.didCancel = {
                let alert = UIAlertController(title: "Cancelled", message: "User did cancel while selecting", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.fdTakeController!.didFail = {
                let alert = UIAlertController(title: "Failed", message: "User selected but API failed", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.fdTakeController!.didGetPhoto = {
                (photo: UIImage, info: [NSObject : AnyObject]) -> Void in
                let alert = UIAlertController(title: "Got photo", message: "User selected photo", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                
                // http://stackoverflow.com/a/34487871/300224
                let alertWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
                alertWindow.rootViewController = UIViewController()
                alertWindow.windowLevel = UIWindowLevelAlert + 1;
                alertWindow.makeKeyAndVisible()
                alertWindow.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            }
            self.fdTakeController!.didGetVideo = {
                (video: NSURL, info: [NSObject : AnyObject]) -> Void in
                let alert = UIAlertController(title: "Got photo", message: "User selected photo", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                
                // http://stackoverflow.com/a/34487871/300224
                let alertWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
                alertWindow.rootViewController = UIViewController()
                alertWindow.windowLevel = UIWindowLevelAlert + 1;
                alertWindow.makeKeyAndVisible()
                alertWindow.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            }

            fdTakeVc.presentingView = self.view
            fdTakeVc.present()
        }
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
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        return CGSize.init(width: 80, height: 180);
//    }
}
