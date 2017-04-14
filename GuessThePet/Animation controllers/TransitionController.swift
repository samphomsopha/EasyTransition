//
//  AnimationController.swift
//  GuessThePet
//
//  Created by Sam Phomsopha on 4/13/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

enum WTransitionType {
    case FlipPresent, FlipDismiss
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
                return dismissingInteractiveController?.interactionInProgress ? dismissingInteractiveController? : nil
            }
}
