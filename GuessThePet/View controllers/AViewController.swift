//
//  AViewController.swift
//  GuessThePet
//
//  Created by Sam Phomsopha on 4/16/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

protocol SlideAnimationTransition:class {
    var transitionController: TransitionController! { get set }
    var presentTransition: WAnimatedTransitioning? { get set }
    var dismissTransition: WAnimatedTransitioning? { get set }
    var dismissInteractionController: WInteractionController? { get set }
    var presentInteractionController: WInteractionController? { get set }
    func initializeTransitionController() -> Void
}

protocol SlideNavigationAnimationTransition: SlideAnimationTransition {
    
}

extension SlideNavigationAnimationTransition where Self:UIViewController {
    func initializeTransitionController() {
        transitionController = TransitionController()
        presentTransition = transitionController.transitionAnimator(type: .slideLeft)
        dismissTransition = transitionController.transitionAnimator(type: .slideRight)
        presentInteractionController = transitionController.interactionController(interactionType: .swipeLeft, action: .push)
        dismissInteractionController = transitionController.interactionController(interactionType: .swipeRight)
        transitionController.presentingAnimator = presentTransition
        transitionController.dismissingAnimator = dismissTransition
        transitionController.presentingInteractiveController = presentInteractionController
        transitionController.dismissingInteractiveController = dismissInteractionController
        navigationController?.delegate = transitionController
    }
}

class AViewController: UIViewController, SlideNavigationAnimationTransition {

    var transitionController: TransitionController!
    var presentTransition: WAnimatedTransitioning?
    var dismissTransition: WAnimatedTransitioning?
    var dismissInteractionController: WInteractionController?
    var presentInteractionController: WInteractionController?
    
    let petCards = PetCardStore.defaultPets()
    var destinationViewController: UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeTransitionController()
        title = "HELLO WORLD"
        // Do any additional setup after loading the view.
        
        if let destinationViewController = getDesignationVC() {
            self.destinationViewController = destinationViewController
            presentInteractionController?.attachToViewController(viewController: self, toVC: self.destinationViewController)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        navigationController?.pushViewController(getDesignationVC()!, animated: true)
    }
    
    func getDesignationVC() -> UIViewController? {
        if let destinationViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RevealViewController") as? RevealViewController {
            destinationViewController.petCard = petCards[0]
            return destinationViewController
        }
        return nil
    }

}
