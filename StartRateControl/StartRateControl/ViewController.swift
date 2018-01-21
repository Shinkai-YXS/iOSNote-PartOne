//
//  ViewController.swift
//  StartRateControl
//
//  Created by Shinkai on 2017/12/20.
//  Copyright © 2017年 Shinkai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // 评分星星
    fileprivate lazy var startStateView: StartRateView = {
        let frame = CGRect(x: UIScreen.main.bounds.size.width / 2 - 160 / 2, y: UIScreen.main.bounds.size.height / 2 - 27 / 2, width: 160, height:27)
        let startView = StartRateView.init(frame: frame, starCount: 5, score: 5, foreImageName: "bigbig", interval: 5)
        startView.score = 5
        startView.allowTap = true
        startView.allowUserPan = true
        startView.isUserInteractionEnabled = true
        return startView
    }()
    
    fileprivate lazy var startScoreLabel: UILabel = {
        let startScoreLabel = UILabel()
        startScoreLabel.textAlignment = .center
        startScoreLabel.textColor = UIColor.brown
        startScoreLabel.text = "5.0"
        startScoreLabel.font = UIFont.systemFont(ofSize: 16)
        startScoreLabel.sizeToFit()
        return startScoreLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(startStateView)
        self.view.addSubview(startScoreLabel)
        
        startStateView.startRateBlook = { [weak self] (score) in
            guard let weakSelf = self else {
                return
            }
            weakSelf.startScoreLabel.text = "\(score)"
            weakSelf.startScoreLabel.sizeToFit()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        startScoreLabel.center = CGPoint(x: startStateView.center.x, y: startStateView.center.y + 40)
    }
}

