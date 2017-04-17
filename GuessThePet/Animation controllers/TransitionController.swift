//
//  AnimationController.swift
//  GuessThePet
//
//  Created by Sam Phomsopha on 4/13/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

public enum WTransitionType {
    case FlipPresent, FlipDismiss, SlideRight, SlideLeft, SlideTop, SlideBottom
}

public enum WInteractionControllerType {
    case SwipeLeft, SwipeRight
}

public protocol WAnimatedTransitioning: UIViewControllerAnimatedTransitioning, UINavigationControllerDelegate {
    func animationSettings(_ settings: [String: Any]) -> Void
}

public protocol WInteractionController {
    var interactionInProgress: Bool { get set }
    func handleGesture(_ gestureRecognizer: UIGestureRecognizer) -> Void
    func wireToViewController(viewController: UIViewController) -> Void
}

class TransitionController: NSObject {
    var presentingAnimator: WAnimatedTransitioning?
    var dismissingAnimator: WAnimatedTransitioning?
    var presentingInteractionController: WInteractionController?
    var dismissingInteractiveController: WInteractionController?
    
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
    
    func interactionController(type: WInteractionControllerType) -> WInteractionController {
        switch type {
        case .SwipeLeft:
            return SwipeInteractionController()
        case .SwipeRight:
            return SwipeInteractionController()
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
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if dismissingInteractiveController?.interactionInProgress ?? false {
            return dismissingInteractiveController as? UIViewControllerInteractiveTransitioning
        } else {
            return nil
        }
        //return (dismissingInteractiveController?.interactionInProgress)! ? dismissingInteractiveController as? UIViewControllerInteractiveTransitioning? : nil
    }
}

extension TransitionController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return presentingAnimator
        } else {
            return dismissingAnimator
        }
    }
    
//    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        return dismissingInteractiveController as? UIViewControllerInteractiveTransitioning
//    }

    
}
