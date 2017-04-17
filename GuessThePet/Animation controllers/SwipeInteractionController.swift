//
//  SwipeInteractionController.swift
//  GuessThePet
//
//  Created by Sam Phomsopha on 4/13/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

class SwipeInteractionController: UIPercentDrivenInteractiveTransition, WInteractionController {

    var interactionInProgress = false
    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController!
    
    func wireToViewController(viewController: UIViewController) {
        self.viewController = viewController
        prepareGestureRecognizerInView(view: viewController.view)
    }
    
    func handleGesture(_ gestureRecognizer: UIGestureRecognizer) {
        // 1
        guard let gestureRecognizer = gestureRecognizer as? UIScreenEdgePanGestureRecognizer else {
            return
        }
        
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress = (translation.x / 200)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
            
        case .began:
            // 2
            interactionInProgress = true
            viewController.dismiss(animated: true, completion: nil)
            
        case .changed:
            // 3
            shouldCompleteTransition = progress > 0.5
            update(progress)
            
        case .cancelled:
            // 4
            interactionInProgress = false
            cancel()
            
        case .ended:
            // 5
            interactionInProgress = false
            
            if !shouldCompleteTransition {
                cancel()
            } else {
                finish()
            }
            
        default:
            print("Unsupported")
        }
    }
    
    private func prepareGestureRecognizerInView(view: UIView) {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        gesture.edges = UIRectEdge.left
        view.addGestureRecognizer(gesture)
    }
    
}
