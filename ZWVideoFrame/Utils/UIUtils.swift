//
//  UIUtils.swift
//  ZWVideoFrame
//
//  Created by zzzworm on 16/4/30.
//  Copyright © 2016年 zzzworm. All rights reserved.
//

import UIKit

extension UIView {
    func removeSubViews()
    {
        for view in self.subviews{
            view.removeFromSuperview()
        }
    }
}

extension UIViewController{
    func hideAndDisableRightNavigationItem (){
        self.navigationItem.rightBarButtonItem?.enabled = false
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clearColor()
    }
    
    func showAndEnableRightNavigationItem(){
        self.navigationItem.rightBarButtonItem?.enabled = true
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.blackColor()
    }

}
