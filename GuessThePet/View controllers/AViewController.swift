//
//  AViewController.swift
//  GuessThePet
//
//  Created by Sam Phomsopha on 4/16/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

class AViewController: UIViewController {

    let transitionController = TransitionController()
    var presentTransition: WAnimatedTransitioning!
    var dismissTransition: WAnimatedTransitioning!
    let petCards = PetCardStore.defaultPets()
    var swipeInteractionController: WInteractionController!
    var swipeLeftInteractionController: WInteractionController!
    var destinationViewController: UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HELLO WORLD"
        // Do any additional setup after loading the view.
        presentTransition = transitionController.transitionAnimator(type: .slideLeft)
        dismissTransition = transitionController.transitionAnimator(type: .slideRight)
        swipeInteractionController = transitionController.interactionController(interactionType: .swipeRight)
        swipeLeftInteractionController = transitionController.interactionController(interactionType: .swipeLeft, action: WInteractionControllerAction.push)
        transitionController.presentingAnimator = presentTransition
        transitionController.dismissingAnimator = dismissTransition
        transitionController.dismissingInteractiveController = swipeInteractionController
        
        transitionController.presentingInteractionController = swipeLeftInteractionController
        
        navigationController?.delegate = transitionController
        
        if let destinationViewController = getDesignationVC() {
            self.destinationViewController = destinationViewController
            swipeLeftInteractionController.attachToViewController(viewController: self, toVC: self.destinationViewController)
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
