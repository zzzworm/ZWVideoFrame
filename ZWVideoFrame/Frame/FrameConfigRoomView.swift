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
//    let switchModeSegCtrl = UISegmentedControl()
    var actionView : SourceActionView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(frameRoomView)
//        switchModeSegCtrl.insertSegmentWithTitle("1", atIndex: 0, animated: false)
//        switchModeSegCtrl.insertSegmentWithTitle("2", atIndex: 1, animated: false)
//        switchModeSegCtrl.insertSegmentWithTitle("3", atIndex: 2, animated: false)
//        self.addSubview(switchModeSegCtrl)
        self.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        frameRoomView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets.init(top: 44, left: 0, bottom: 0, right: 0))
//        switchModeSegCtrl.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: 44)
//        switchModeSegCtrl.autoPinEdgeToSuperviewEdge(ALEdge.Right)
    
    }
    
    func configView(frameConfig:FrameConfig) -> SourceActionView
    {
        setNeedsLayout()
        layoutIfNeeded()
        
        actionView = frameConfig.drawShapView(frameRoomView)
        
        let gestureReconizer = UITapGestureRecognizer.init(target: self, action: #selector(actionViewTapped))
        actionView?.addGestureRecognizer(gestureReconizer);
        return actionView!
    }
    
    func actionViewTapped(sender:AnyObject?) {
        if let actionGestureRecog = sender as? UITapGestureRecognizer {
            if let actionView = actionGestureRecog.view as? SourceActionView{
                if let handler = actionView.actionHandler {
                    handler(sender: actionView)
                }
                
            }

        }
    }
}
