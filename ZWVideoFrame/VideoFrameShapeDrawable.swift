//
//  VideoShapeDrawable.swift
//  ZWVideoFrame
//
//  Created by zzzworm on 16/4/27.
//  Copyright © 2016年 zzzworm. All rights reserved.
//

import Foundation
import UIKit

protocol VideoFrameShapeViewDrawable : class {
    func drawShapView(frameShapeView: UIView)  -> SourceActionView
}