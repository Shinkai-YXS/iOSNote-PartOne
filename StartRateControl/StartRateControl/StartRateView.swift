//
//  StartRateView.swift
//  StartRateControl
//
//  Created by Shinkai on 2017/12/7.
//  Copyright © 2017年 Shinkai. All rights reserved.
//

import UIKit

class StartRateView: UIView {
    
    var startRateBlook: ((_ score: Float) -> ())? = nil
    //滑动评分是否使用动画，默认为false
    var usePanAnimation:Bool = false
    //是否允许非整星评分，默认为false
    var allowUnderCompleteStar:Bool = false {
        willSet{
            self.allowUnderCompleteStar = newValue
            showStarRate()
        }
    }
    //defualt is false,true为滑动评分
    var allowUserPan: Bool {
        set{
            if newValue {
                let pan = UIPanGestureRecognizer(target: self,action: #selector(starPan(_:)))
                self.addGestureRecognizer(pan)
            }
            _allowUserPan = newValue
        }get{
            return _allowUserPan
        }
    }
    //defualt is false,true为点击评分
    var allowTap: Bool = false
    
    fileprivate var starBackgroundView: UIView!
    fileprivate var starForegroundView: UIView!
    fileprivate var _allowUserPan: Bool = false//默认不支持滑动评分
    // 星星的个数
    fileprivate var count: Int!
    // 评分
    var score: Float! {
        didSet {
            showStarRate()
        }
    }
    //是否是创建view
    fileprivate var firstInit: Bool = true
    // 高亮星星的名字
    fileprivate var foreImageName: String = ""
    // 星星的间隔 默认为 3
    fileprivate var interval: CGFloat = 3
    /**
     * 一颗星代表一分
     * starCount:代表创建多少颗星
     * score:创建时显示分数
     * 默认的是5颗星，0.0分
     */
    override convenience init(frame: CGRect) {
        self.init(frame: frame, starCount:5, score:0.0, foreImageName: "", interval: 3)
    }
    
    init(frame: CGRect, starCount:Int, score:Float, foreImageName: String, interval: CGFloat) {
        super.init(frame: frame)
        self.count = starCount
        self.score = score
        self.clipsToBounds = true
        self.foreImageName = foreImageName
        self.interval = interval
        createStarView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - custom func
extension StartRateView {
    fileprivate func createStarView()->(){
        starBackgroundView = starViewWithImageName("star_empty")
        starForegroundView = starViewWithImageName(self.foreImageName)
        self.addSubview(starBackgroundView)
        self.addSubview(starForegroundView)
        showStarRate()
        self.firstInit = false
        //添加手势
        let tap = UITapGestureRecognizer(target: self,action: #selector(starTap(_:)))
        self.addGestureRecognizer(tap)
    }
    
    fileprivate func starViewWithImageName(_ imageName:String) -> UIView {
        let starView = UIView.init(frame: self.bounds)
        starView.backgroundColor = self.backgroundColor
        starView.clipsToBounds = true
        //添加星星
        for index in 0 ..< count {
            let imageView = UIImageView()
            imageView.frame = CGRect(x:CGFloat(index) * (self.frame.size.height + self.interval), y: 0, width: self.frame.size.height, height: self.frame.size.height)
            let image = UIImage(named: imageName)
            imageView.image = image
            starView.addSubview(imageView)
        }
        return starView
    }
    
    //交互后反向返回分数
    fileprivate func backSorce(){
        if (self.startRateBlook != nil) {
            var newScore:Float =  allowUnderCompleteStar ? score : ceilf(score)
            if  newScore > Float(count){
                newScore = Float(count)
            }else if newScore < 0{
                newScore = 1
            }
            //协议代理
            self.startRateBlook!(newScore)
        }
    }
    
    //显示评分
    fileprivate func showStarRate(){
        let  duration = (usePanAnimation && !firstInit) ? 0.1 : 0.0
        UIView.animate(withDuration: duration, animations: {
            if self.allowUnderCompleteStar{//支持非整星评分
                self.starForegroundView.frame = CGRect(x: 0,y: 0,width: self.bounds.width / CGFloat(self.count) * CGFloat(self.score),height: self.bounds.height)
            }else{//只支持整星评分
                self.starForegroundView.frame = CGRect(x: 0,y: 0,width: self.bounds.width / CGFloat(self.count) * CGFloat(ceilf(self.score)),height: self.bounds.height)
            }
        })
    }
}

// MARK: - gesture func
extension StartRateView {
    //滑动评分
    @objc func starPan(_ recognizer:UIPanGestureRecognizer) -> () {
        var OffX:CGFloat = 0
        if recognizer.state == .began{
            OffX = recognizer.location(in: self).x
        }else if recognizer.state == .changed{
            OffX += recognizer.location(in: self).x
        }else{
            return
        }
        // 最低一颗星星
        if OffX < 0 {
            OffX = 1
        }
        self.score = Float(OffX) / Float(self.bounds.width) * Float(self.count)
        showStarRate()
        backSorce()
    }
    //点击评分
    @objc func starTap(_ recognizer:UIPanGestureRecognizer) -> () {
        if !self.allowTap {
            return
        }
        let OffX = recognizer.location(in: self).x
        self.score = Float(OffX) / Float(self.bounds.width) * Float(self.count)
        showStarRate()
        backSorce()
    }
}

