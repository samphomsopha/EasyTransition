//
//  FlipDismissAnimationController.swift
//  GuessThePet
//
//  Created by sam phomsopha on 4/11/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

class FlipDismissAnimationController: NSObject {
    var destinationFrame = CGRect.zero
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                return
        }
        
        let containerView = transitionContext.containerView
        
        let initialFrame = transitionContext.initialFrame(for: fromVC)
        let finalFrame = destinationFrame
        
        let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false)
        snapshot?.layer.cornerRadius = 25
        snapshot?.layer.masksToBounds = true
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot!)
        fromVC.view.isHidden = true
        
        AnimationHelper.perspectiveTransformForContainerView(containerView)

        toVC.view.layer.transform = AnimationHelper.yRotation(-M_PI_2)

        let duration = transitionDuration(transitionContext: transitionContext)
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                // 1
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3, animations: {
                    snapshot?.frame = finalFrame
                })
                
                UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: {
                    snapshot?.layer.transform = AnimationHelper.yRotation(M_PI_2)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: {
                    toVC.view.layer.transform = AnimationHelper.yRotation(0.0)
                })
        },
            completion: { _ in
                // 2
                fromVC.view.isHidden = false
                snapshot?.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
