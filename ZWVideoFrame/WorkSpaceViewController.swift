//
//  ViewController.swift
//  ZWVideoFrame
//
//  Created by zzzworm on 16/4/25.
//  Copyright © 2016年 zzzworm. All rights reserved.
//

import UIKit
import MediaPlayer
import ReactiveCocoa
import PureLayout
import PageMenu

class WorkSpaceViewController: UIViewController {

    var pageMenu : CAPSPageMenu?
    let viewControllers: [PageViewController]
    
    init(viewControllers: [PageViewController]) {
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
        // Example:
        var parameters: [CAPSPageMenuOption] = [
            .MenuItemSeparatorWidth(4.3),
            .UseMenuLikeSegmentedControl(true),
            .MenuItemSeparatorPercentageHeight(0.1)
        ]
        
        // Initialize page menu with controller array, frame, and optional parameters
        var pageVCs:[PageViewController] = []
        for pageItem:PageViewController in viewControllers {
            pageItem.parentNavigationController = self.navigationController
            pageVCs.append(pageItem)
        }
        pageMenu = CAPSPageMenu(viewControllers: pageVCs, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.view.addSubview(pageMenu!.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated:animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}
