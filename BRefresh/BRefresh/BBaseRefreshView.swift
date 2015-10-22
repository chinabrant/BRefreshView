//
//  BRefreshView.swift
//  BRefresh
//
//  Created by 猫狩 on 15/10/21.
//  Copyright © 2015年 brant. All rights reserved.
//

import Foundation
import UIKit

enum BRefreshState {
    case Idle
    case Pulling
    case Refreshing
}

class BBaseRefreshView: UIView {
    var scrollView: UIScrollView?
    var pan: UIPanGestureRecognizer?
    var refreshViewHeight: CGFloat = 50
    
    let IdleText = "下拉刷新"
    let PullingText = "松开立即刷新"
    let RefreshingText = "刷新中..."
    var state: BRefreshState = .Idle
    var refreshBlock: (() -> Void)!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        addObservers()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addObservers() {
        self.scrollView?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)
        self.scrollView?.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New, context: nil)
        self.pan = self.scrollView?.panGestureRecognizer
        self.pan?.addObserver(self, forKeyPath: "state", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    func removeObservers() {
        self.scrollView?.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "contentSize" {
//            print("\n\(change)")
        } else if (keyPath == "contentOffset") {
            contentOffsetChanged(self.scrollView!.contentOffset)
        } else if (keyPath == "state") {

        }
    }
    
    func contentOffsetChanged(newPoint: CGPoint) {
//        print("x: \(newPoint.x)  y: \(newPoint.y)")
        if self.state == .Refreshing {
            // 正在刷新，不处理
            return;
        }
        
        // 如果正在拖拽
        if self.scrollView!.dragging {
            // 可进入刷新
            if newPoint.y <= -refreshViewHeight {
                self.state = .Pulling
            } else {
                self.state = .Idle
            }
        } else if self.state == .Pulling {
            self.state = .Refreshing
            beginRefreshing()
        }
    }
    
    func beginRefreshing() {
        UIView.animateWithDuration(0.5) { () -> Void in
            self.scrollView?.contentInset = UIEdgeInsetsMake(refreshViewHeight, 0, 0, 0)
        }
        
        refreshBlock()
        
    }
    
    func endRefreshing() {
        self.state = .Idle
        UIView.animateWithDuration(0.5) { () -> Void in
            self.scrollView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
        
        
    }
}

extension UIScrollView {
    
    func addPullToRefresh(refreshView: BBaseRefreshView, refreshBlock:() -> Void) {
        self.addSubview(refreshView)
        refreshView.refreshBlock = refreshBlock
        refreshView.scrollView = self
        
        refreshView.addObservers()
    }
    
    func endRefreshing() {
        let views = self.subviews
        for view in views {
            if view is BBaseRefreshView {
                (view as! BBaseRefreshView).endRefreshing()
                break
            }
        }
    }
}


