//
//  FlipView.swift
//  FlipView
//
//  Created by 潘东 on 16/7/28.
//  Copyright © 2016年 潘东. All rights reserved.
//

import UIKit

class FlipView: UIView {

    var displayingPrimary = true
    var spinTimeInterval = 1.0
    // 此处可以将primaryView和secondaryView改写为需要的view子类，比如UILabel
    var primaryView = UIView()
    var secondaryView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setPrimaryView()
        setSecondaryView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPrimaryView() {
        self.addSubview(primaryView)
        primaryView.translatesAutoresizingMaskIntoConstraints = false
        
        // 使用autoLayout进行布局
        let constraint1 = NSLayoutConstraint(item: primaryView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0)
        let constraint2 = NSLayoutConstraint(item: primaryView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: 0)
        let constraint3 = NSLayoutConstraint(item: primaryView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: 0)
        let constraint4 = NSLayoutConstraint(item: primaryView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0)
        let array = [constraint1, constraint2, constraint3, constraint4]
        self.addConstraints(array)
        // 直接使用snapkit进行布局
//        primaryView.snp_makeConstraints { (make) in
//            make.edges.equalTo(self)
//        }
    }
    
    func setSecondaryView() {
        self.addSubview(secondaryView)
        secondaryView.translatesAutoresizingMaskIntoConstraints = false
        // 使用autoLayout进行布局
        let constraint1 = NSLayoutConstraint(item: secondaryView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0)
        let constraint2 = NSLayoutConstraint(item: secondaryView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: 0)
        let constraint3 = NSLayoutConstraint(item: secondaryView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: 0)
        let constraint4 = NSLayoutConstraint(item: secondaryView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0)
        let array = [constraint1, constraint2, constraint3, constraint4]
        self.addConstraints(array)
        
        // 直接使用snapkit进行布局
//        secondaryView.snp_makeConstraints { (make) in
//            make.edges.equalTo(self)
//        }
        self.sendSubviewToBack(secondaryView)
        secondaryView.isHidden = true
    }
    
    func flip() {
        if (displayingPrimary == true) {
            secondaryView.isHidden = false
        } else {
            secondaryView.isHidden = true
        }
        
        // 使用UIView的 transitionFromView(fromView: UIView, toView: UIView, duration: NSTimeInterval, options: UIViewAnimationOptions, completion: ((Bool) -> Void)?)
        // 来设置动画效果，这里需要注意的是options这里，需要设置为ShowHideTransitionViews，这主要是因为这个方法会操作视图层级，并添加新的目的地视图，如果使用AutoLayout，动画结束后，视图就没有约束了，所以会显示错误
        UIView.transition(from: displayingPrimary ? primaryView : secondaryView,
                          to: displayingPrimary ? secondaryView : primaryView,
                                  duration: spinTimeInterval,
                          options: [.transitionFlipFromLeft, .showHideTransitionViews]) { (finish) in
                                    if finish {
                                        self.displayingPrimary = !self.displayingPrimary
                                        if self.displayingPrimary {
                                            self.secondaryView.isHidden = true
                                        } else {
                                            self.secondaryView.isHidden = false
                                        }
                                    }
        }
    }

}
