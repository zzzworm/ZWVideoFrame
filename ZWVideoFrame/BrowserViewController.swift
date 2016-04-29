/*

Copyright (c) 2016, Storehouse Media Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

import UIKit
import Advance
import MediaPlayer

import ReactiveCocoa

private final class DemoItem: BrowserItem {
    let viewController: CardViewController
    init(viewController: CardViewController) {
        self.viewController = viewController
        super.init()
    }
}

final class BrowserViewController: UIViewController {
    
    let viewControllers: [CardViewController]
    
    let backgroundImageView = UIImageView(frame: CGRect.zero)
    let blurredBackgroundImageView = UIImageView(frame: CGRect.zero)
    let backgroundDimmingView = UIView(frame: CGRect.zero)
    
    let blurSpring = Spring(value: CGFloat.zero)
    
    let browserView = BrowserView(frame: CGRect.zero)
    let importMusicalView = ImportMusicalView(frame: CGRect.zero)
    var waveformVC : DVGWaveformController!
    var mediaPicker: MPMediaPickerController?
    dynamic var toPrecessVideoAssets : [AVAsset]?
    
    required init(viewControllers: [CardViewController]) {
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
        
        var cfg = SpringConfiguration()
        cfg.threshold = 0.001
        cfg.tension = 60.0
        cfg.damping = 26.0
        blurSpring.configuration = cfg
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Undo, target: self, action: #selector(back))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "export", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(exportTapped))

        
        backgroundImageView.contentMode = .ScaleAspectFill
        backgroundImageView.image = UIImage(named: "background")
        view.addSubview(backgroundImageView)
        
        blurredBackgroundImageView.contentMode = .ScaleAspectFill
        blurredBackgroundImageView.image = UIImage(named: "background-blurred")
        blurredBackgroundImageView.alpha = 0.0
        view.addSubview(blurredBackgroundImageView)
        
        backgroundDimmingView.backgroundColor = UIColor.blackColor()
        backgroundDimmingView.alpha = 0.3
        view.addSubview(backgroundDimmingView)
        
        
        view.addSubview(browserView)
        
        view.addSubview(importMusicalView)
        
        browserView.delegate = self
        
        browserView.items = viewControllers.map({ (vc) -> DemoItem in
            return DemoItem(viewController: vc)
        })
        
        blurSpring.changed.observe { [unowned self] (b) in
            self.blurredBackgroundImageView.alpha = b
        }
        
        self.waveformVC = DVGWaveformController(containerView: self.importMusicalView.waveformView)
        self.importMusicalView.importButton.addTarget(self, action: #selector(onTapChooseSong), forControlEvents: UIControlEvents.TouchUpInside)
        
        let property = DynamicProperty(object: self, keyPath: "toPrecessVideoAssets")
         property.producer.startWithNext { [weak self] assets in
            if (nil == assets){
                return
            }
            let videoAssets = assets as! [AVAsset]
            if 0 != videoAssets.count{
            NSLog("hi %f", CMTimeGetSeconds((videoAssets.first?.duration)!))
            }
        }
        property.producer.skip(0).startWithNext {asset in
            if let VideoAssets = asset as? [AVAsset]{
            let maxSecond =  VideoAssets.reduce(0,combine: { (maxSecond, videoA) -> Float64 in
                
                return CMTimeGetSeconds(videoA.duration) > maxSecond ? CMTimeGetSeconds(videoA.duration) : maxSecond

            })
                 NSLog("hello, \(maxSecond)")
            }
        }
        let asset = AVAsset.init(URL: NSURL.init(string: "h")!)
        self.toPrecessVideoAssets = [asset]

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated:animated)
    }

//    override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundImageView.frame = view.bounds
        blurredBackgroundImageView.frame = view.bounds
        backgroundDimmingView.frame = view.bounds
        browserView.frame = view.bounds
        importMusicalView.frame.size = CGSize.init(width: view.bounds.width, height: 44)
        importMusicalView.frame.origin = CGPoint(x: 0, y: view.bounds.maxY - 44)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func exportTapped(sender:UIResponder){
        
    }
    
    func back(sender:UIResponder){
        if let nav = self.navigationController {
            nav.popViewControllerAnimated(true)
        }
        else{
            self.dismissViewControllerAnimated(true, completion: nil)
        }

    }
    

    func onTapChooseSong(sender: AnyObject?) {
        mediaPicker = MPMediaPickerController(mediaTypes: .AnyAudio)
        
        if let picker = mediaPicker{
            
            
            print("Successfully instantiated a media picker")
            picker.delegate = self
            picker.allowsPickingMultipleItems = true
            picker.showsCloudItems = true
            picker.prompt = "Pick a song please..."
            view.addSubview(picker.view)
            
            presentViewController(picker, animated: true, completion: nil)
            
        } else {
            print("Could not instantiate a media picker")
        }
    }
    
    func configureWaveform() {
        self.waveformVC.movementDelegate = self
        self.waveformVC.numberOfPointsOnThePlot = 2000
    }
}

extension BrowserViewController: BrowserViewDelegate {
    func browserView(browserView: BrowserView, didShowItem item: BrowserItem) {
        guard let item = item as? DemoItem else { fatalError() }
        assert(item.viewController.parentViewController != self)
        addChildViewController(item.viewController)
        item.viewController.view.frame = item.view.bounds
        item.view.addSubview(item.viewController.view)
        item.viewController.didMoveToParentViewController(self)
    }
    
    func browserView(browserView: BrowserView, didHideItem item: BrowserItem) {
        guard let item = item as? DemoItem else { fatalError() }
        assert(item.viewController.parentViewController == self)
        item.viewController.willMoveToParentViewController(nil)
        item.viewController.view.removeFromSuperview()
        item.viewController.removeFromParentViewController()
    }
    
    func browserView(browserView: BrowserView, didEnterFullScreenForItem item: BrowserItem) {
        guard let item = item as? DemoItem else { fatalError() }
        item.viewController.fullScreen = true

    }
    
    func browserView(browserView: BrowserView, didLeaveFullScreenForItem item: BrowserItem) {
        guard let item = item as? DemoItem else { fatalError() }
        item.viewController.fullScreen = false
    }
    
    func browserViewDidScroll(browserView: BrowserView) {
        var blurAmount = browserView.currentIndex
        blurAmount = min(blurAmount, 1.0)
        blurAmount = max(blurAmount, 0.0)
        blurSpring.target = blurAmount
        

        
        var coverVisibility = 1.0 - (browserView.currentIndex - floor(browserView.currentIndex))
        coverVisibility = min(coverVisibility, 1.0)
        coverVisibility = max(coverVisibility, 0.0)

        importMusicalView.alpha = 0.5 + CGFloat(coverVisibility*0.5)
    }
}

extension BrowserViewController: DVGDiagramMovementsDelegate
{
    func diagramDidSelect(dataRange: DataRange) {
        print("\(#function), dataRange: \(dataRange)")
    }
    
    func diagramMoved(scale scale: Double, start: Double) {
        print("\(#function), scale: \(scale), start: \(start)")
    }
}

extension BrowserViewController:MPMediaPickerControllerDelegate{
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        
        let item = mediaItemCollection.items.first
        let urlAny = item?.valueForKey(MPMediaItemPropertyAssetURL);
        let url = urlAny as! NSURL
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        self.waveformVC.asset = AVAsset.init(URL: url)
        let itemArtworkAny = item?.valueForProperty(MPMediaItemPropertyArtwork);
        if let itemArtwork = itemArtworkAny as? MPMediaItemArtwork
        {
            let albumArtworkImage = itemArtwork.imageWithSize(CGSize(width: 36.0, height: 36.0));
            self.importMusicalView.importButton.setBackgroundImage(albumArtworkImage, forState: UIControlState.Normal)
             self.importMusicalView.importButton.setBackgroundImage(albumArtworkImage, forState: UIControlState.Selected)
        }
        else{
            self.importMusicalView.importButton.setBackgroundImage(UIImage.init(named: "songchart"), forState: UIControlState.Normal)
             self.importMusicalView.importButton.setBackgroundImage(UIImage.init(imageLiteral: "songchart"), forState: UIControlState.Selected)
        }
        
        self.configureWaveform()
        
        self.waveformVC.readAndDrawSynchronously({[weak self] in
            if $0 != nil {
                print("error:", $0!)
            } else {
                print("waveform finished drawing")
            }
        })
    }
}
