//
//  PhotoBrowserAnimator.swift
//  PhotoBrowse
//
//  Created by 张鹏 on 2017/8/9.
//  Copyright © 2017年 大白菜. All rights reserved.
//

import UIKit

public class PhotoBrowserAnimator: NSObject {

    fileprivate var isPresented = false
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

        guard let toVC = transitionContext.viewController(forKey: .to) as? PhotoBrowserViewController else {
            return
        }

        let toView = transitionContext.view(forKey: .to)!
        toView.alpha = 0
        transitionContext.containerView.addSubview(toView)

        toVC.collectionView.isHidden = true

        let iv = toVC.imageViewForPresent()

        iv.frame = toVC.photoBrowserSourceRect()

        transitionContext.containerView.addSubview(iv)

        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                                   animations: { () -> Void in
                                    
                                    iv.frame = toVC.photoBrowserPresentToRect()
                                    toView.alpha = 1
                                    
        }) { (_) -> Void in

            iv.removeFromSuperview()
            toVC.collectionView.isHidden = false
            transitionContext.completeTransition(true)
        }
    }
    
    private func dismissAnimation(transitionContext: UIViewControllerContextTransitioning) {

        guard let fromVC = transitionContext.viewController(forKey: .from) as? PhotoBrowserViewController else {
                return
        }

        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        fromView.removeFromSuperview()

        let iv = fromVC.imageViewForDismiss()

        transitionContext.containerView.addSubview(iv)

        let index = fromVC.indexForDismiss()
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                                   animations: { () -> Void in

                                    iv.frame = fromVC.photoBrowserSourceRect()
                                    
        }) { (_) -> Void in

            iv.removeFromSuperview()

            transitionContext.completeTransition(true)
        }
    }
}
