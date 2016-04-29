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

class FrameConfigRoomViewController: CardViewController {
    let frameConfig:FrameConfig
    let roomView = FrameConfigRoomView()
    var fdTakeController : FDTakeController?
    var player:Player?
    dynamic var videoUrl: NSURL?
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
         self.view.addSubview(self.roomView)
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        self.roomView.configView(frameConfig)
        
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
                self.videoUrl = video
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
       
        
        let videoUrlProperty = DynamicProperty(object: self, keyPath:  "videoUrl")
        videoUrlProperty.producer.startWithNext { [unowned self, pauseHandle, chooseHanlde] videoUrlAny in
            if let videoUrl:NSURL = videoUrlAny as? NSURL {
            
            self.player = nil == self.player ? Player() : self.player
            //self.player!.delegate = self
            self.player!.view.frame.size = self.roomView.actionView!.frame.size
                self.player!.view.frame.origin = CGPoint.zero
            
            self.addChildViewController(self.player!)
            self.roomView.actionView!.addSubview(self.player!.view)
            self.player!.didMoveToParentViewController(self)
            self.player!.delegate = self;
            self.player!.setUrl(videoUrl)
                 self.roomView.actionHanler = pauseHandle
            }
            else{
                self.roomView.actionHanler = chooseHanlde
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.roomView.autoPinEdgesToSuperviewMargins()
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
