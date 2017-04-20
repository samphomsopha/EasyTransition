//
//  SwipePresentInteractionController.swift
//  GuessThePet
//
//  Created by Sam Phomsopha on 4/17/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

class SwipePresentInteractionController: UIPercentDrivenInteractiveTransition, WInteractionController {

    var swipeDirection: SwipeInteractionDirection = .left
    var interactionInProgress = false
    
    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController!
    private weak var viewControllerToPresent: UIViewController!
    
    public func settings(_ settings: [String : Any]) {
        if let direction = settings["direction"] as? SwipeInteractionDirection {
            swipeDirection = direction
        }
    }
    
    func attachToViewController(viewController: UIViewController) {
        self.viewController = viewController
        prepareGestureRecognizerInView(view: viewController.view)
    }
    
    func viewToPresent(viewController: UIViewController) {
        
    }
    
    func handleGesture(_ gestureRecognizer: UIGestureRecognizer) {
        return
    }
    
    private func prepareGestureRecognizerInView(view: UIView) {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        //gesture.edges = UIRectEdge.left
        view.addGestureRecognizer(gesture)
    }
}
