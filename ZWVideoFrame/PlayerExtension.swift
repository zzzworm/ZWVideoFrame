//
//  PlayerExtension.swift
//  ZWVideoFrame
//
//  Created by zzzworm on 16/4/30.
//  Copyright © 2016年 zzzworm. All rights reserved.
//

import Foundation
import Player
import AVFoundation

extension Player{
//    public func func setupAsset(asset: AVAsset);
    func setAsset(asset:AVAsset){
        if self.asset != asset {
            self.setupAsset(asset)
        }
        
    }
}