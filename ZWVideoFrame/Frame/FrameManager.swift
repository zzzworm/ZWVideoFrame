//
//  FrameManager.swift
//  ZWVideoFrame
//
//  Created by zzzworm on 16/4/27.
//  Copyright © 2016年 zzzworm. All rights reserved.
//

import UIKit

class FrameManager: FrameToolSet {
    var frames : [FrameConfig] = []
    
    required override init() {
        super.init()
        let simpleFrame = FrameConfig()
        frames.append(simpleFrame)
        frames.append(simpleFrame)
        frames.append(simpleFrame)
        frames.append(simpleFrame)
        frames.append(simpleFrame)
        frames.append(simpleFrame)
        frames.append(simpleFrame)
        frames.append(simpleFrame)
        frames.append(simpleFrame)
    }
    
    class var sharedInstance: FrameManager {
        struct Static {
            static let instance: FrameManager = FrameManager()
        }
        return Static.instance
    }

}
