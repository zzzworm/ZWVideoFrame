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
    let frameShapeLayer: CAShapeLayer = CAShapeLayer()
    
    required override init(frame: CGRect) {
        super.init(frame:frame)
        frameView.layer.addSublayer(frameShapeLayer)
        self.contentView.addSubview(frameView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        frameView.autoPinEdgesToSuperviewEdges()
    }
}
