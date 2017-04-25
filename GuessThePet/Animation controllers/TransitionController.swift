//
//  AnimationController.swift
//  GuessThePet
//
//  Created by Sam Phomsopha on 4/13/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

public enum WTransitionType {
    case flipPresent, flipDismiss, slideRight, slideLeft, slideTop, slideBottom
}

public enum WInteractionControllerType {
    case swipeLeft, swipeRight, swipeDown, swipeUp
}

public enum WInteractionControllerAction {
    case present, push, dismiss
}

public protocol WAnimatedTransitioning: UIViewControllerAnimatedTransitioning, UINavigationControllerDelegate {
    func animationSettings(_ settings: [String: Any]) -> Void
}

public protocol WInteractionController:class {
    var interactionInProgress: Bool { get set }
    var presentationStyle: SwipePresentInteractionPresentationStyle { get set}
    func handleGesture(_ gestureRecognizer: UIGestureRecognizer) -> Void
    func settings(_ settings: [String: Any])
    func attachToViewController(viewController: UIViewController, toVC: UIViewController?) -> Void
}

class TransitionController: NSObject {
    var presentingAnimator: WAnimatedTransitioning?
    var dismissingAnimator: WAnimatedTransitioning?
    var presentingInteractiveController: WInteractionController?
    var dismissingInteractiveController: WInteractionController?
    
    weak var designationViewController: UIViewController!
    
    func transitionAnimator(type: WTransitionType) -> WAnimatedTransitioning {
        switch type {
        case .flipDismiss:
            return FlipDismissAnimationController()
        case .flipPresent:
            return FlipPresentAnimationController()
        case .slideRight:
            let controller = SlideAnimationController()
            controller.animationSettings(["direction": SlideAnimationDirection.right])
            return controller
        case .slideLeft:
            let controller = SlideAnimationController()
            controller.animationSettings(["direction": SlideAnimationDirection.left])
            return controller
        case .slideTop:
            let controller = SlideAnimationController()
            controller.animationSettings(["direction": SlideAnimationDirection.top])
            return controller
        case .slideBottom:
            let controller = SlideAnimationController()
            controller.animationSettings(["direction": SlideAnimationDirection.bottom])
            return controller
        }
    }
    
    func interactionController(interactionType: WInteractionControllerType, action: WInteractionControllerAction? = .dismiss) -> WInteractionController {
        var controller:WInteractionController?
        
        switch action! {
        case .present:
            controller = SwipePresentInteractionController()
            controller?.presentationStyle = .present
        case .push:
            controller = SwipePresentInteractionController()
            controller?.presentationStyle = .push
        case .dismiss:
            controller =  SwipeDismissInteractionController()
        }
 
        switch interactionType {
        case .swipeLeft:
            controller?.settings(["direction": SwipeInteractionDirection.left])
            return controller!
        case .swipeRight:
            controller?.settings(["direction": SwipeInteractionDirection.right])
            return controller!
        case .swipeUp:
            controller?.settings(["direction": SwipeInteractionDirection.up])
            return controller!
        case .swipeDown:
            controller?.settings(["direction": SwipeInteractionDirection.down])
            return controller!
        }
    }
}

extension TransitionController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        dismissingInteractiveController?.attachToViewController(viewController: presented, toVC: presenting)
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
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if presentingInteractiveController?.interactionInProgress ?? false {
            return presentingInteractiveController as? UIViewControllerInteractiveTransitioning
        } else {
            return nil
        }
    }
}

extension TransitionController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
            dismissingInteractiveController?.attachToViewController(viewController: toVC, toVC: fromVC)
            return presentingAnimator
        } else {
            //presentingInteractionController?.attachToViewController(viewController: fromVC, toVC: toVC)
            return dismissingAnimator
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if dismissingInteractiveController?.interactionInProgress ?? false {
            return dismissingInteractiveController as? UIViewControllerInteractiveTransitioning
        } else if presentingInteractiveController?.interactionInProgress ?? false {
            return presentingInteractiveController as? UIViewControllerInteractiveTransitioning
        } else {
            return nil
        }
    }
}
