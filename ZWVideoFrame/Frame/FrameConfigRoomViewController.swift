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
import AssetsLibrary

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
                        let ratio = photo.size.height/photo.size.width
                        if(ratio * actionView.frame.size.width > CGRectGetHeight(actionView.frame)){
                            
                        }
                        else{
                            
                        }
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
             let videoAsset = self.mergerSoucreList.first?.video!
            let videoComposition = compositionForExport(videoAsset!, exportSize: self.roomView.frameRoomView.frame.size)
            let videoTrack = videoAsset?.tracksWithMediaType(AVMediaTypeVideo).first
            let mixComposition = AVMutableComposition.init();
            let  toDuetcompositionVideoTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeVideo, preferredTrackID: CMPersistentTrackID.init());
            do{
            try toDuetcompositionVideoTrack.insertTimeRange(videoTrack!.timeRange, ofTrack: videoTrack!, atTime: kCMTimeZero)
            }
            catch{
                
            }
            
            
            if let videoAssetExport = AVAssetExportSession.init(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality){
               videoAssetExport.videoComposition = videoComposition
            
            
            let exportUrl = self.exportVideoPath();
            videoAssetExport.outputFileType = AVFileTypeMPEG4;
            videoAssetExport.outputURL = exportUrl;
            videoAssetExport.shouldOptimizeForNetworkUse = false;
            videoAssetExport.exportAsynchronouslyWithCompletionHandler({ 
                if (videoAssetExport.status == AVAssetExportSessionStatus.Completed) {
                }
                else if (videoAssetExport.status == AVAssetExportSessionStatus.Exporting) {
             }
                                        else if (videoAssetExport.status == AVAssetExportSessionStatus.Failed) {
                                                }
                })
                
            }

        }
        else{
            UIGraphicsBeginImageContext(self.roomView.frameRoomView.frame.size)
            
            self.roomView.frameRoomView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
           
            let image = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
//            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
//            let documentsDirectory = paths[0] as String
//            let data:NSData = UIImagePNGRepresentation(image)! as NSData
//            data.writeToFile(documentsDirectory, atomically: true)
            
            if (ALAssetsLibrary.authorizationStatus() == ALAuthorizationStatus.Denied) {
                let alert = UIAlertView.init(title: NSLocalizedString("Save Failed", comment: ""), message: "You need to allow ZWVideoFrame to access your photos. Go to Settings -> Privacy -> Photos to change the settings.", delegate: nil, cancelButtonTitle: NSLocalizedString("OK",  comment: ""), otherButtonTitles: "")
                alert.show();
                return;
            }
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(onSavedToAlbum), nil)

        }
    }
    func exportVideoPath() -> NSURL {

        let documentsDirectory = NSURL.init(string: NSHomeDirectory())
        let exportPath = documentsDirectory!.URLByAppendingPathComponent("test.mp4")
        return exportPath

    }
    
    func compositionForExport(asset:AVAsset, exportSize:CGSize) -> AVVideoComposition {
        
    let videoSize = self.roomView.actionView!.frame.size
    let frameOuterSize = self.roomView.frameRoomView.frame.size
    let videoComposition = AVMutableVideoComposition.init(propertiesOfAsset: asset);
        let exportLayer = CALayer.init();
        let videoLayer = CALayer.init();
        videoLayer.contentsGravity = kCAGravityResizeAspect;
        exportLayer.frame = CGRectMake(0, 0, frameOuterSize.width, frameOuterSize.height);
        videoLayer.frame = CGRectMake(0,  0, videoSize.width, videoSize.height);
        
        exportLayer.addSublayer(videoLayer);
        
        let vFrameLayer = CAShapeLayer.init(layer: self.roomView);
        exportLayer.addSublayer(vFrameLayer);
    videoComposition.animationTool = AVVideoCompositionCoreAnimationTool.init(postProcessingAsVideoLayer: videoLayer, inLayer: exportLayer)
    let videoTrack = asset.tracksWithMediaType(AVMediaTypeVideo).first;
    
    // get the frame rate from videoSettings, if not set then try to get it from the video track,
    // if not set (mainly when asset is AVComposition) then use the default frame rate of 30
   
 //   let trackFrameRate = videoTrack?.nominalFrameRate;

    
    videoComposition.renderSize = exportSize;
    // Make a "pass through video track" video composition.
    let  passThroughInstruction = AVMutableVideoCompositionInstruction.init();
    passThroughInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
    
    let  passThroughLayerInstruction = AVMutableVideoCompositionLayerInstruction.init(assetTrack: videoTrack!);
        passThroughInstruction.layerInstructions = [passThroughLayerInstruction]
    videoComposition.instructions = [passThroughInstruction]
      
    return videoComposition;
    }

    func onSavedToAlbum(image:UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        
        if let err = error {
            UIAlertView(title: "错误", message: err.localizedDescription, delegate: nil, cancelButtonTitle: "确定").show()
        } else {
           
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
