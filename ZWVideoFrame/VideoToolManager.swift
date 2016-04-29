//
//  VideoToolManager.swift
//  ZWVideoFrame
//
//  Created by zzzworm on 16/4/29.
//  Copyright © 2016年 zzzworm. All rights reserved.
//

import UIKit


class VideoToolManager: NSObject {
    var tools : [FrameToolSet] = []
    
    required override init() {
        super.init()
        let simpleFrame = FrameManager()
        tools.append(simpleFrame)
        tools.append(simpleFrame)
    }
    
    class var sharedInstance: VideoToolManager {
        struct Static {
            static let instance: VideoToolManager = VideoToolManager()
        }
        return Static.instance
    }

}
