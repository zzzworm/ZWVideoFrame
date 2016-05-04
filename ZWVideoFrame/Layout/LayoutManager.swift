//
//  FrameManager.swift
//  ZWVideoFrame
//
//  Created by zzzworm on 16/4/27.
//  Copyright © 2016年 zzzworm. All rights reserved.
//

import UIKit

class LayoutManager: FrameToolSet {
    var layouts : [LayoutConfig] = []
    
    required override init() {
        super.init()
        let simpleLayout = LayoutConfig()
        layouts.append(simpleLayout)
        layouts.append(simpleLayout)
        layouts.append(simpleLayout)
        layouts.append(simpleLayout)
        layouts.append(simpleLayout)
        layouts.append(simpleLayout)
        layouts.append(simpleLayout)
        layouts.append(simpleLayout)
        layouts.append(simpleLayout)
    }
    
    class var sharedInstance: LayoutManager {
        struct Static {
            static let instance: LayoutManager = LayoutManager()
        }
        return Static.instance
    }

}
