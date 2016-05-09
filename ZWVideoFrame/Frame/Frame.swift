//
//  Frame.swift
//  ZWVideoFrame
//
//  Created by zzzworm on 16/4/27.
//  Copyright © 2016年 zzzworm. All rights reserved.
//

import UIKit

class FrameConfig: VideoFrameShapeViewDrawable {
    let boderWith : CGFloat = 20.0
    let width : CGFloat = 100.0
    let height : CGFloat = 100.0
    let innerCornerRadius : CGFloat = 5.0
    let outerCornerRadius : CGFloat = 5.0
    func drawShapView(frameShapeView: UIView) -> SourceActionView
    {
        let frameShapeLayer: CAShapeLayer = CAShapeLayer()
        frameShapeLayer.frame.size = frameShapeView.bounds.size
        let shapeSize = frameShapeLayer.frame.size
        
        let outerRectSize =  CGSize.init(width: shapeSize.width*width/100.0 , height: shapeSize.height*height/100.0)
        let innerRectOrigion = CGPoint.init(x: boderWith, y: boderWith)
        let innerRectSize = CGSize.init(width: shapeSize.width*width/100.0-boderWith*2 ,
                                        height: shapeSize.height*height/100.0 - boderWith*2)
        let shapePath = CGPathCreateMutable()
        CGPathAddRoundedRect(shapePath, nil, CGRect.init(origin: CGPoint.zero, size: outerRectSize),
                             outerCornerRadius, outerCornerRadius)
        
        CGPathAddRoundedRect(shapePath, nil, CGRect.init(origin: innerRectOrigion, size: innerRectSize),
                             innerCornerRadius, innerCornerRadius)
        
        frameShapeLayer.path = shapePath
        frameShapeLayer.fillColor = UIColor.blueColor().CGColor
        frameShapeLayer.fillRule = kCAFillRuleEvenOdd
        let actionView = SourceActionView()
        actionView.frame.size = innerRectSize;
        actionView.frame.origin = innerRectOrigion //CGPoint.init(x: boderWith/2, y: boderWith/2)
        actionView.backgroundColor = UIColor.grayColor()
        frameShapeView.addSubview(actionView)
        frameShapeView.layer.addSublayer(frameShapeLayer)
        return actionView
    }
}
