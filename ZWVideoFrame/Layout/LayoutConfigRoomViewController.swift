//
//  LayoutConfigRoomViewController.swift
//  ZWVideoFrame
//
//  Created by zzzworm on 16/4/29.
//  Copyright © 2016年 zzzworm. All rights reserved.
//

import UIKit
import FDTake
import Player
import ReactiveCocoa

class LayoutConfigRoomViewController: CardViewController {
    let layoutConfig:LayoutConfig
    let roomView = LayoutConfigRoomView()
    var fdTakeController : FDTakeController?

    required init(layoutConfig:LayoutConfig)
    {
        self.layoutConfig = layoutConfig
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

            }
            
            fdTakeVc.presentingView = self.view
            fdTakeVc.present()
        }
        
        let pauseHandle = {
            [unowned self] (sender:AnyObject?) -> Void in
            if let player = sender as? Player  {
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

extension LayoutConfigRoomViewController: PlayerDelegate
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
