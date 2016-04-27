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
        let shapePath = CGPathCreateMutable()
        CGPathAddRect(shapePath, nil, CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: frameConfig.width, height: frameConfig.height)))
        let frameShapeLayer: CAShapeLayer = CAShapeLayer()
        frameShapeLayer.path = shapePath
        frameShapeLayer.borderWidth = frameConfig.boderWith
        frameShapeLayer.strokeColor = UIColor.greenColor().CGColor
        frameShapeLayer.borderColor = UIColor.blackColor().CGColor
        frameShapeLayer.fillColor = UIColor.blueColor().CGColor
        frameView.layer.addSublayer(frameShapeLayer)
        self.frameConfig = frameConfig
    }
}
