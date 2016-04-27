//
//  Frame.swift
//  ZWVideoFrame
//
//  Created by zzzworm on 16/4/27.
//  Copyright © 2016年 zzzworm. All rights reserved.
//

import UIKit

class FrameConfig: VideoFrameShapeViewDrawable {
    let boderWith : CGFloat = 5.0
    let width : CGFloat = 100.0
    let height : CGFloat = 100.0
    let innerCornerRadius : CGFloat = 5.0
    let outerCornerRadius : CGFloat = 5.0
    func drawShapView(frameShapeView: UIView) -> UIView
    {
        let frameShapeLayer: CAShapeLayer = CAShapeLayer()
        frameShapeLayer.frame.size = frameShapeView.bounds.size
        let shapeSize = frameShapeLayer.frame.size
        
        let outerRectSize =  CGSize.init(width: shapeSize.width*width/100.0 , height: shapeSize.height*height/100.0)
        let innerRectSize = CGSize.init(width: shapeSize.width*width/100.0-boderWith*2 , height: shapeSize.height*height/100.0 - boderWith*2)
        let shapePath = CGPathCreateMutable()
        CGPathAddRoundedRect(shapePath, nil, CGRect.init(origin: CGPoint.zero, size: outerRectSize), outerCornerRadius, outerCornerRadius)
        
        CGPathAddRoundedRect(shapePath, nil, CGRect.init(origin: CGPoint.init(x: boderWith, y: boderWith), size: innerRectSize), innerCornerRadius, innerCornerRadius)
        
        frameShapeLayer.path = shapePath
        frameShapeLayer.fillColor = UIColor.blueColor().CGColor
        frameShapeLayer.fillRule = kCAFillRuleEvenOdd
        let actionView = UIView()
        actionView.frame.size = innerRectSize;
        frameShapeView.addSubview(actionView)
        frameShapeView.layer.addSublayer(frameShapeLayer)
        return actionView
    }
}
