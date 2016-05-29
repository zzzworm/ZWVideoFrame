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

    var frameConfig : FrameConfig?
    var actionView : SourceActionView?
    var frameLayer : CAShapeLayer?
    
    required override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.contentView.addSubview(frameView)
        self.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        frameView.autoPinEdgesToSuperviewEdges()
    }
    
    func configFrameConfig(frameConfig:FrameConfig) -> Void {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        (actionView,frameLayer) = frameConfig.drawShapView(frameView)

        self.frameConfig = frameConfig
    }
   
}

//
//extension FrameCollectionCell: UIGestureRecognizerDelegate {
//    
//    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        
//        return true
//    }
//}