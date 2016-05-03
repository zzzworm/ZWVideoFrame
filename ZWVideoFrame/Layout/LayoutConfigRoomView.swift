//
//  LayoutConfigRoomView.swift
//  ZWVideoFrame
//
//  Created by zzzworm on 16/5/3.
//  Copyright © 2016年 zzzworm. All rights reserved.
//

import UIKit

class LayoutConfigRoomView: UIView {
    let roomView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(roomView)
        self.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        roomView.autoPinEdgesToSuperviewMargins()
    }
    
    
}
