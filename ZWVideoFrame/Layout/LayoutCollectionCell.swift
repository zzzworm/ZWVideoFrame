//
//  FrameCollectionCell.swift
//  ZWVideoFrame
//
//  Created by zzzworm on 16/4/27.
//  Copyright © 2016年 zzzworm. All rights reserved.
//

import UIKit
import PureLayout

class LayoutCollectionCell: UICollectionViewCell {
    let layoutView: UIView = UIView()

    var layoutConfig : LayoutConfig?
    var actionView : UIView?

    required override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.contentView.addSubview(layoutView)
        self.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        layoutView.autoPinEdgesToSuperviewEdges()
    }
    
    func configLayoutConfig(layoutConfig:LayoutConfig) -> Void {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        actionView = layoutConfig.drawShapView(layoutView)

        self.layoutConfig = layoutConfig
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