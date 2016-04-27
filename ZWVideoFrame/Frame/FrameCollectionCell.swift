//
//  FrameCollectionCell.swift
//  ZWVideoFrame
//
//  Created by zzzworm on 16/4/27.
//  Copyright © 2016年 zzzworm. All rights reserved.
//

import UIKit
import PureLayout

class FrameCollectionCell: UICollectionViewCell {
    let frameView: UIView = UIView()
    let label = UILabel()
    var frameConfig : FrameConfig?
    var actionView : UIView?
    var actionHanler : ((sender:AnyObject?) -> Void)?
    
    required override init(frame: CGRect) {
        super.init(frame:frame)
        
        label.text = "hello"
        self.contentView.addSubview(frameView)
        self.contentView.addSubview(label)
        self.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        frameView.autoPinEdgesToSuperviewEdges()
        label.autoSetDimensionsToSize(CGSize.init(width: 132, height: 32))
        label.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: 4)
        label.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: 4)
        
    }
    
    func configFrameConfig(frameConfig:FrameConfig) -> Void {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        actionView = frameConfig.drawShapView(frameView)
        let gestureReconizer = UITapGestureRecognizer.init(target: self, action: #selector(actionViewTapped))
        
        actionView?.addGestureRecognizer(gestureReconizer);
        self.frameConfig = frameConfig
    }
    
    func actionViewTapped(sender:AnyObject?) {
        if let hander = actionHanler {
            hander(sender: sender)
        }
    }
}
