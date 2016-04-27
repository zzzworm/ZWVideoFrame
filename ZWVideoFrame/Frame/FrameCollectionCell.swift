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
    
    @IBOutlet weak var testLabel: UILabel!
    
    var frameConfig : FrameConfig?
    
    required override init(frame: CGRect) {
        super.init(frame:frame)
        
        testLabel.text = "hello"
        self.contentView.addSubview(frameView)
        self.contentView.addSubview(testLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.contentView.addSubview(frameView)

    }
    
//    override func updateConstraints() {
//        super.updateConstraints()
//        frameView.autoPinEdgesToSuperviewEdges()
//        testLabel.autoSetDimensionsToSize(CGSize.init(width: 32, height: 100))
//        testLabel.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: 4)
//        testLabel.autoPinEdgeToSuperviewEdge(ALEdge.Top, withInset: 4)
//        
//    }
    
    func configFrameConfig(frameConfig:FrameConfig) -> Void {
        let shapePath = CGPathCreateMutable()
        CGPathAddRect(shapePath, nil, CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: frameConfig.width, height: frameConfig.height)))
        let frameShapeLayer: CAShapeLayer = CAShapeLayer()
        frameShapeLayer.path = shapePath
        frameShapeLayer.borderWidth = frameConfig.boderWith
        frameShapeLayer.strokeColor = UIColor.greenColor().CGColor
        frameShapeLayer.borderColor = UIColor.blackColor().CGColor
        frameShapeLayer.fillColor = UIColor.blueColor().CGColor
        frameView.layer.mask = frameShapeLayer
        self.frameConfig = frameConfig
    }
}
