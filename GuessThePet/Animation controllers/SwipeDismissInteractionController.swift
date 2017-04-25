//
//  SwipeInteractionController.swift
//  GuessThePet
//
//  Created by Sam Phomsopha on 4/13/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

enum SwipeInteractionDirection {
    case up, down, left, right
}

class SwipeDismissInteractionController: UIPercentDrivenInteractiveTransition, WInteractionController {
    
    var swipeDirection: SwipeInteractionDirection = .right
    var interactionInProgress = false
    var presentationStyle: SwipePresentInteractionPresentationStyle = .present
    
    private var isPushed: Bool {
        return (viewController.presentingViewController == nil && viewController?.navigationController != nil)
    }
    
    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController!
    
    public func settings(_ settings: [String : Any]) {
        if let direction = settings["direction"] as? SwipeInteractionDirection {
            swipeDirection = direction
        }
    }
    
    func attachToViewController(viewController: UIViewController, toVC: UIViewController?) {
        self.viewController = viewController
        prepareGestureRecognizerInView(view: viewController.view)
    }
    
    func handleGesture(_ gestureRecognizer: UIGestureRecognizer) {
        guard let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else {
            return
        }
        //check swipe direction
        let velocity = gestureRecognizer.velocity(in: viewController.view.superview)
        
        if !interactionInProgress {
            if swipeDirection == .right && velocity.x <= 0 {
                return
            }
            
            if swipeDirection == .left && velocity.x >= 0 {
                return
            }
            
            if swipeDirection == .down && velocity.y <= 0 {
                return
            }
            
            if swipeDirection == .up && velocity.y >= 0 {
                return
            }
        }
        
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress = (translation.x / 200)//CGFloat(0)
        
        switch swipeDirection {
        case .right:
            progress = (translation.x / 200)
        case .left:
            progress = (abs(translation.x / 200))
        case .up:
            progress = (abs(translation.y / 200))
        case .down:
            progress = (translation.y / 200)
        }
        
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        switch gestureRecognizer.state {
            
        case .began:
            interactionInProgress = true
            if isPushed {
                let _ = viewController.navigationController?.popViewController(animated: true)
            }
            else {
                viewController.dismiss(animated: true, completion: nil)
            }
        case .changed:
            shouldCompleteTransition = progress > 0.5
            update(progress)
        case .cancelled, .ended:
            interactionInProgress = false
            if !shouldCompleteTransition || gestureRecognizer.state == .cancelled {
                cancel()
            } else {
                finish()
            }
        default:
            print("Unsupported")
        }
    }
    
    private func prepareGestureRecognizerInView(view: UIView) {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        //gesture.edges = UIRectEdge.left
        view.addGestureRecognizer(gesture)
    }
    
}
