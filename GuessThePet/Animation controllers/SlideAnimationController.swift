//
//  SlideAnimationController.swift
//  GuessThePet
//
//  Created by Sam Phomsopha on 4/13/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

enum SlideAnimationDirection {
    case left, right, top, bottom
}

class SlideAnimationController: NSObject, WAnimatedTransitioning {
    
    var direction: SlideAnimationDirection = .left
    var duration: Double = 1.0
    func animationSettings(_ settings: [String : Any]) {
        if let direction = settings["direction"] as? SlideAnimationDirection {
            self.direction = direction
        }
        
        if let duration = settings["duration"] as? Double {
            self.duration = duration
        }
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // get reference to our fromView, toView and the container view that we should perform the transition in
        let container = transitionContext.containerView
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        // set up from 2D transforms that we'll use in the animation
        var offScreenFinalPosition = CGAffineTransform(translationX: container.frame.width, y: 0)
        var offScreenStartPosition = CGAffineTransform(translationX: -container.frame.width, y: 0)
        switch direction {
        case .left:
            offScreenFinalPosition = CGAffineTransform(translationX: container.frame.width, y: 0)
            offScreenStartPosition = CGAffineTransform(translationX: -container.frame.width, y: 0)
        case .right:
            offScreenFinalPosition = CGAffineTransform(translationX: -container.frame.width, y: 0)
            offScreenStartPosition = CGAffineTransform(translationX: container.frame.width, y: 0)
        case .top:
            offScreenFinalPosition = CGAffineTransform(translationX: 0, y: container.frame.height)
            offScreenStartPosition = CGAffineTransform(translationX: 0, y: -container.frame.height)
        case .bottom:
            offScreenFinalPosition = CGAffineTransform(translationX: 0, y: -container.frame.height)
            offScreenStartPosition = CGAffineTransform(translationX: 0, y: container.frame.height)
        }
        
        
        // start the toView to the right of the screen
        toView.transform = offScreenFinalPosition
        
        // add the both views to our view controller
        container.addSubview(toView)
        container.addSubview(fromView)
        
        // get the duration of the animation
        // DON'T just type '0.5s' -- the reason why won't make sense until the next post
        // but for now it's important to just follow this approach
        let duration = self.transitionDuration(using: transitionContext)
        
        // perform the animation!
        // for this example, just slid both fromView and toView to the left at the same time
        // meaning fromView is pushed off the screen and toView slides into view
        // we also use the block animation usingSpringWithDamping for a little bounce
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseOut, animations: {
            
            fromView.transform = offScreenStartPosition
            toView.transform = CGAffineTransform.identity
            
        }, completion: { finished in
            
            // tell our transitionContext object that we've finished animating
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
        })
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
}
