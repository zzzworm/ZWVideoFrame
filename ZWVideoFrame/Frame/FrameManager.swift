//
//  FrameManager.swift
//  ZWVideoFrame
//
//  Created by zzzworm on 16/4/27.
//  Copyright © 2016年 zzzworm. All rights reserved.
//

import UIKit

class FrameManager: NSObject {
    var frames : [Frame]?
    
    required override init() {
        super.init()
        let simpleFrame = Frame()
        frames?.append(simpleFrame)
        
    }
}
