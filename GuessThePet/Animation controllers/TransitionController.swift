//
//  AnimationController.swift
//  GuessThePet
//
//  Created by Sam Phomsopha on 4/13/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

enum WTransitionType {
    case FlipPresent, FlipDismiss, SlideRight, SlideLeft, SlideTop, SlideBottom
}

protocol WAnimatedTransitioning: UIViewControllerAnimatedTransitioning {
    func animationSettings(_ settings: [String: Any]) -> Void
}

class TransitionController: NSObject {
    var presentingAnimator: WAnimatedTransitioning?
    var dismissingAnimator: WAnimatedTransitioning?
    var dismissingInteractiveController: UIPercentDrivenInteractiveTransition?
    
    weak var designationViewController: UIViewController!
    
    func transitionAnimator(type: WTransitionType) -> WAnimatedTransitioning {
        switch type {
        case .FlipDismiss:
            return FlipDismissAnimationController()
        case .FlipPresent:
            return FlipPresentAnimationController()
        case .SlideRight:
            let controller = SlideAnimationController()
            controller.animationSettings(["direction": SlideAnimationDirection.right])
            return controller
        case .SlideLeft:
            let controller = SlideAnimationController()
            controller.animationSettings(["direction": SlideAnimationDirection.left])
            return controller
        case .SlideTop:
            let controller = SlideAnimationController()
            controller.animationSettings(["direction": SlideAnimationDirection.top])
            return controller
        case .SlideBottom:
            let controller = SlideAnimationController()
            controller.animationSettings(["direction": SlideAnimationDirection.bottom])
            return controller
        }
    }
}

extension TransitionController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentingAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissingAnimator
    }
    
//    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//                return dismissingInteractiveController?.interactionInProgress ? dismissingInteractiveController? : nil
//            }
}
