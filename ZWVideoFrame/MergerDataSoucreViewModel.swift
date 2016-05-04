//
//  MergerDataSoucreViewModel.swift
//  ZWVideoFrame
//
//  Created by zzzworm on 16/4/30.
//  Copyright © 2016年 zzzworm. All rights reserved.
//

import UIKit
import AVFoundation
import Player

class VideoOrPhotoDataSouce : NSObject {
    var photo:UIImage?
    var video:AVAsset?
    
    required init(video:AVAsset) {
        self.video = video
    }
    required init(photo:UIImage) {
        self.photo = photo
    }
}

class MergerDataSoucreViewModel: NSObject {
    var dataSourceList:[VideoOrPhotoDataSouce] = []
    var cachedPlayers:[Player] = []
    required override init() {
        super.init()
       
    }
    
    class var sharedInstance: MergerDataSoucreViewModel {
        struct Static {
            static let instance: MergerDataSoucreViewModel = MergerDataSoucreViewModel()
        }
        return Static.instance
    }
    
    func getPlayerAtIndex(index:Int) -> Player {
        if (cachedPlayers.count < index + 1 ) {
            assert(index == cachedPlayers.count)
            let player = Player()
            cachedPlayers.append(player)
            return player
        }
        else{
            return cachedPlayers[index]
        }
    }
    
}
