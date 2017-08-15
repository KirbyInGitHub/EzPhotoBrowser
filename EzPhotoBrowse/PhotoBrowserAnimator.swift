//
//  PhotoBrowserAnimator.swift
//  PhotoBrowse
//
//  Created by 张鹏 on 2017/8/9.
//  Copyright © 2017年 大白菜. All rights reserved.
//

import UIKit

public protocol PhotoBrowserPresentDelegate: NSObjectProtocol {
    
    /// 开始转场动画的图像
    func imageViewForPresent(index: Int) -> UIImageView

    /// 动画转场的起始位置
    func photoBrowserPresentFromRect(index: Int) -> CGRect
    
    /// 动画转场的目标位置
    func photoBrowserPresentToRect(index: Int) -> CGRect
}

public protocol PhotoBrowserDismissDelegate: NSObjectProtocol {
    
    /// 解除转场的图像视图（包含起始位置）
    func imageViewForDismiss() -> UIImageView
    /// 解除转场的图像索引
    func indexForDismiss() -> Int
}

public class PhotoBrowserAnimator: NSObject {

    private(set) public weak var presentDelegate: PhotoBrowserPresentDelegate?

    private(set) public weak var dismissDelegate: PhotoBrowserDismissDelegate?

    public var index: Int = 0

    fileprivate var isPresented = false

    public func setDelegateParams(presentDelegate: PhotoBrowserPresentDelegate,
                           index: Int,
                           dismissDelegate: PhotoBrowserDismissDelegate) {
        
        self.presentDelegate = presentDelegate
        self.dismissDelegate = dismissDelegate
        self.index = index
    }
}

extension PhotoBrowserAnimator: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = true
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = false
        return self
    }
}

extension PhotoBrowserAnimator: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        isPresented ? presentAnimation(transitionContext: transitionContext) : dismissAnimation(transitionContext: transitionContext)
    }
    
    fileprivate func presentAnimation(transitionContext: UIViewControllerContextTransitioning) {

        guard let presentDelegate = self.presentDelegate else {
            return
        }

        let toView = transitionContext.view(forKey: .to)!
        toView.alpha = 0
        transitionContext.containerView.addSubview(toView)

        let toVC = transitionContext.viewController(forKey: .to) as! PhotoBrowserViewController
        toVC.collectionView.isHidden = true

        let iv = presentDelegate.imageViewForPresent(index: self.index)

        iv.frame = presentDelegate.photoBrowserPresentFromRect(index: index)

        transitionContext.containerView.addSubview(iv)

        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                                   animations: { () -> Void in
                                    
                                    iv.frame = presentDelegate.photoBrowserPresentToRect(index: self.index)
                                    toView.alpha = 1
                                    
        }) { (_) -> Void in

            iv.removeFromSuperview()
            toVC.collectionView.isHidden = false
            transitionContext.completeTransition(true)
        }
    }
    
    private func dismissAnimation(transitionContext: UIViewControllerContextTransitioning) {

        guard let presentDelegate = presentDelegate, let dismissDelegate = dismissDelegate else {
                return
        }

        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        fromView.removeFromSuperview()

        let iv = dismissDelegate.imageViewForDismiss()

        transitionContext.containerView.addSubview(iv)

        let index = dismissDelegate.indexForDismiss()
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                                   animations: { () -> Void in

                                    iv.frame = presentDelegate.photoBrowserPresentFromRect(index: index)
                                    
        }) { (_) -> Void in

            iv.removeFromSuperview()

            transitionContext.completeTransition(true)
        }
    }
}
