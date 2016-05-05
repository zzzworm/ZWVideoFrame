//
//  FrameConfigRoomView.swift
//  ZWVideoFrame
//
//  Created by zzzworm on 16/4/29.
//  Copyright © 2016年 zzzworm. All rights reserved.
//

import UIKit
import PureLayout

class FrameConfigRoomView: UIView {

    let frameRoomView = UIView()
    let switchModeSegCtrl = UISegmentedControl()
    var actionView : UIView?
    var actionHanler : ((sender:AnyObject?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(frameRoomView)
        switchModeSegCtrl.insertSegmentWithTitle("1", atIndex: 0, animated: false)
        switchModeSegCtrl.insertSegmentWithTitle("2", atIndex: 1, animated: false)
        switchModeSegCtrl.insertSegmentWithTitle("3", atIndex: 2, animated: false)
        self.addSubview(switchModeSegCtrl)
        self.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        frameRoomView.autoPinEdgesToSuperviewMargins()
        switchModeSegCtrl.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: 44)
        switchModeSegCtrl.autoPinEdgeToSuperviewEdge(ALEdge.Right)
    
    }
    
    func configView(frameConfig:FrameConfig)
    {
        setNeedsLayout()
        layoutIfNeeded()
        
        actionView = frameConfig.drawShapView(frameRoomView)
        
        let gestureReconizer = UITapGestureRecognizer.init(target: self, action: #selector(actionViewTapped))
        actionView?.addGestureRecognizer(gestureReconizer);
    }
    
    func actionViewTapped(sender:AnyObject?) {
        if let hander = actionHanler {
            hander(sender: sender)
        }
    }
}
