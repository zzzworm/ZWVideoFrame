//
//  FrameConfigRoomViewController.swift
//  ZWVideoFrame
//
//  Created by zzzworm on 16/4/29.
//  Copyright © 2016年 zzzworm. All rights reserved.
//

import UIKit
import FDTake
import Player
import ReactiveCocoa
import PureLayout
import AVFoundation

class FrameConfigRoomViewController: CardViewController {
    let frameConfig:FrameConfig
    let roomView = FrameConfigRoomView()
    var fdTakeController : FDTakeController?

    
    var player:Player?
    required init(frameConfig:FrameConfig)
    {
        self.frameConfig = frameConfig
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.contentView.addSubview(self.roomView)
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        let actionView = self.roomView.configView(frameConfig)
        self.roomView.actionView!.userInteractionEnabled = false;
        let chooseHanlde = {
            [unowned self] (sender:AnyObject?) -> Void in
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
                
            }
            self.fdTakeController!.didFail = {
                let alert = UIAlertController(title: "Failed", message: "User selected but API failed", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            self.fdTakeController!.didGetPhoto = {
                [unowned self](photo: UIImage, info: [NSObject : AnyObject]) -> Void in
                
                let source:VideoOrPhotoDataSouce = VideoOrPhotoDataSouce.init(photo: photo)
                MergerDataSoucreViewModel.sharedInstance.removeAllSource()
                self.mergerSoucreList.removeAll()
                
                MergerDataSoucreViewModel.sharedInstance.addSouce(source)
                self.mergerSoucreList.append(source)
            }
            self.fdTakeController!.didGetVideo = {
                (video: NSURL, info: [NSObject : AnyObject]) -> Void in
                let asset = AVAsset.init(URL: video)
                let source:VideoOrPhotoDataSouce = VideoOrPhotoDataSouce.init(video: asset)
                 MergerDataSoucreViewModel.sharedInstance.removeAllSource()
                self.mergerSoucreList.removeAll()
                
                self.mergerSoucreList.append(source)
                MergerDataSoucreViewModel.sharedInstance.addSouce(source)
            }
            
            fdTakeVc.presentingView = self.view
            fdTakeVc.present()
        }
        
        let pauseHandle = {
            [unowned self] (sender:AnyObject?) -> Void in
            if let player = self.player  {
                if(player.playbackState == PlaybackState.Playing){
                     player.pause()
                }else if(player.playbackState == PlaybackState.Stopped){
                    player.playFromBeginning()
                }
                else{
                    player.playFromCurrentTime()
                }
            }
        }
        
        let mergerSoucreListProperty = DynamicProperty(object: self, keyPath:  "mergerSoucreList")
        mergerSoucreListProperty.producer.startWithNext { [unowned self, pauseHandle, chooseHanlde, actionView] soucreListAny in
            if let soucreList = soucreListAny as? NSArray{
                let actulSourceList = soucreList as! [VideoOrPhotoDataSouce]
                self.showAndEnableRightNavigationItem()
            if let mergerSource:VideoOrPhotoDataSouce = actulSourceList.first{
                
                self.roomView.actionView?.removeSubViews()
                if let videoAsset = mergerSource.video {
                    
                    guard let track = videoAsset.tracksWithMediaType(AVMediaTypeVideo).first else { return }
                    let calcedSize = CGSizeApplyAffineTransform(track.naturalSize, track.preferredTransform)
                    let videoSize = CGSize(width: fabs(calcedSize.width), height: fabs(calcedSize.height))
                    //if videoSize.width/videoSize.height
                    self.player = MergerDataSoucreViewModel.sharedInstance.getPlayerAtIndex(0)
                    self.player!.setAsset(videoAsset)
                     self.player!.delegate = self;
                       
                    //self.player!.delegate = self
                    self.player!.view.frame.size = self.roomView.actionView!.frame.size
                        self.player!.view.frame.origin = CGPoint.zero
                    
                    self.addChildViewController(self.player!)
                    self.roomView.actionView!.addSubview(self.player!.view)
                    self.player!.didMoveToParentViewController(self)
                    actionView.actionHandler = pauseHandle
                }
                else if let photo = mergerSource.photo{
                    if let actionView = self.roomView.actionView {
                        actionView.removeSubViews()
                        let imageView =  UIImageView()
                        imageView.frame.size = actionView.frame.size
                        imageView.contentMode = UIViewContentMode.ScaleAspectFit
                        imageView.image = photo
                        actionView.addSubview(imageView)
                    }
                }
            } else{
                self.hideAndDisableRightNavigationItem()
                self.player?.removeFromParentViewController()
                self.roomView.actionView?.removeSubViews()
                actionView.actionHandler = chooseHanlde
                }
            }
            else{
                self.hideAndDisableRightNavigationItem()
                self.player?.removeFromParentViewController()
                self.roomView.actionView?.removeSubViews()
                actionView.actionHandler = chooseHanlde
            }
           
        }
    }
    
    override func exportTapped(sender:UIResponder)
    {
        if MergerDataSoucreViewModel.sharedInstance.isContainVideo() {
            
        }
        else{
            UIGraphicsBeginImageContext(self.view.frame.size)
            
            self.roomView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
           
            let image = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let documentsDirectory = paths[0] as String
            let data:NSData = UIImagePNGRepresentation(image)! as NSData
            data.writeToFile(documentsDirectory, atomically: true)
            
           
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.roomView.autoPinEdgeToSuperviewEdge(ALEdge.Bottom, withInset: 44)
        self.roomView.autoPinEdgesToSuperviewMarginsExcludingEdge(ALEdge.Bottom)
    }
    
    override func didEnterFullScreen() {
        super.didEnterFullScreen()
        self.roomView.actionView!.userInteractionEnabled = true;
    }
    
    override func didLeaveFullScreen() {
        super.didLeaveFullScreen()
        self.roomView.actionView!.userInteractionEnabled = false
    }

}

extension FrameConfigRoomViewController: PlayerDelegate
{
    func playerReady(player: Player)
    {
        player.playFromBeginning()
    }
    func playerPlaybackStateDidChange(player: Player)
    {
        
    }
    func playerBufferingStateDidChange(player: Player)
    {
        
    }
    func playerPlaybackWillStartFromBeginning(player: Player)
    {
        
    }
    func playerPlaybackDidEnd(player: Player)
    {
        
    }

}
