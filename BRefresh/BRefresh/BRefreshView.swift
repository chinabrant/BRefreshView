//
//  BRefreshView.swift
//  BRefresh
//
//  Created by 猫狩 on 15/10/21.
//  Copyright © 2015年 brant. All rights reserved.
//

import UIKit
import CoreGraphics

public class BRefreshView: BBaseRefreshView {
    var label: UILabel!
    var arrowView: ArrowView!
    var pieceView: PieceView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        pieceView = PieceView(frame: CGRect(x: 100, y: 10, width: 30, height: 30))
        addSubview(pieceView)
        
        label = UILabel(frame: CGRect(x: 160, y: 10, width: 200, height: 30))
        label.text = IdleText
        label.textColor = UIColor.orange
        self.addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func contentOffsetChanged(newPoint: CGPoint) {
        super.contentOffsetChanged(newPoint: newPoint)
        
        switch self.state {
        case .Refreshing:
            self.label.text = RefreshingText
            break
        case .Idle:
            label?.text = IdleText
            pieceView.endAnimation()
            break
        case .Pulling:
            label?.text = PullingText
            pieceView.startAnimation()
            break
        }
        
    }
    
    
    override func endRefreshing() {
        super.endRefreshing()
        
        pieceView.startAnimation()
    }
    
}

class ArrowView: UIView {
    let ArrowHeight: CGFloat = 20.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // 向下的箭头
        let context = UIGraphicsGetCurrentContext()!
        context.setLineWidth(2)
        context.move(to: CGPoint(x: self.bounds.size.width / 2.0, y: self.bounds.size.height - 2))
        context.move(to: CGPoint(x: 0, y: self.bounds.size.height - ArrowHeight))
        context.move(to: CGPoint(x: self.bounds.size.width / 3.0, y: self.bounds.size.height - ArrowHeight))
        
        context.move(to: CGPoint(x: self.bounds.size.width / 3.0, y:2))
        context.move(to: CGPoint(x: self.bounds.size.width / 3.0 * 2.0, y:2))
        context.move(to: CGPoint(x: self.bounds.size.width / 3.0 * 2.0, y: self.bounds.size.height - ArrowHeight))
        context.move(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height - ArrowHeight))
        context.move(to: CGPoint(x: self.bounds.size.width / 2.0, y: self.bounds.size.height))
        context.strokePath()
    }
    
    func rotate(angle: Double) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        
        self.transform = CGAffineTransform.init(rotationAngle:CGFloat(angle * (M_PI / 180.0)))
        UIView.commitAnimations()
    }
    
}

class PieceView: UIView {
    let CenterWidth: CGFloat = 5   // 中间部分的宽度
    let GapWidth: CGFloat = 3   // 间隔
    var view1: UIView = UIView()
    var view2: UIView = UIView()
    var view3: UIView = UIView()
    var view4: UIView = UIView()
    
    let ColorGreen = UIColor.green
    let ColorOrange = UIColor.orange
    let ColorRed = UIColor.red
    let ColorBlue = UIColor.blue
    
    var timer: Timer?
    var order = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        let width = (frame.size.width - GapWidth * 2 - CenterWidth) / 2.0
        let height = frame.size.width - GapWidth - width
        
        view1.frame = CGRect(x: 0, y: 0, width: width, height: height)
        view2.frame = CGRect(x: width + GapWidth, y: 0, width: height, height: width)
        view3.frame = CGRect(x: frame.size.width - width, y: width + GapWidth, width: width, height: height)
        view4.frame = CGRect(x: 0, y: height + GapWidth, width: height, height: width)
        
        view1.backgroundColor = ColorGreen
        view2.backgroundColor = ColorOrange
        view3.backgroundColor = ColorRed
        view4.backgroundColor = ColorBlue
        
        addSubview(view1)
        addSubview(view2)
        addSubview(view3)
        addSubview(view4)
    }
    
    func startAnimation() {
        if timer != nil {
            timer?.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(excuteAnimation), userInfo: nil, repeats: true)
    }
    
    func endAnimation() {
        timer?.invalidate()
    }
    
    func excuteAnimation() {
        if order == 1 {
            view1.backgroundColor = ColorGreen
            view2.backgroundColor = ColorOrange
            view3.backgroundColor = ColorRed
            view4.backgroundColor = ColorBlue
            order = 2
        } else if order == 2 {
            view2.backgroundColor = ColorGreen
            view3.backgroundColor = ColorOrange
            view4.backgroundColor = ColorRed
            view1.backgroundColor = ColorBlue
            order = 3
        } else if order == 3 {
            view3.backgroundColor = ColorGreen
            view4.backgroundColor = ColorOrange
            view1.backgroundColor = ColorRed
            view2.backgroundColor = ColorBlue
            order = 4
        } else if order == 4 {
            view4.backgroundColor = ColorGreen
            view1.backgroundColor = ColorOrange
            view2.backgroundColor = ColorRed
            view3.backgroundColor = ColorBlue
            order = 1
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        
    }
}
