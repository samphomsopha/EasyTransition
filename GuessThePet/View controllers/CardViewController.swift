/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

private let revealSequeId = "revealSegue"
private let transitioncontroller = TransitionController()
private let flipPresentAnimationController = transitioncontroller.transitionAnimator(type: .slideLeft)
private let flipDismissAnimationController = transitioncontroller.transitionAnimator(type: .slideRight)
private let swipeInteractionController = transitioncontroller.interactionController(interactionType: .swipeRight)
private let swipePresentIC = transitioncontroller.interactionController(interactionType: .swipeLeft, action: WInteractionControllerAction.present)

class CardViewController: UIViewController {
    
    @IBOutlet fileprivate weak var cardView: UIView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    
    var pageIndex: Int?
    var petCard: PetCard?
    var toVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = petCard?.description
        cardView.layer.cornerRadius = 25
        cardView.layer.masksToBounds = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        cardView.addGestureRecognizer(tapRecognizer)
        
        transitioncontroller.presentingAnimator = flipPresentAnimationController
        transitioncontroller.dismissingAnimator = flipDismissAnimationController
        transitioncontroller.dismissingInteractiveController = swipeInteractionController
        transitioncontroller.presentingInteractiveController = swipePresentIC
        if let dcVC = getDesignationVC() {
            toVC = dcVC
            swipePresentIC.attachToViewController(viewController: self, toVC: dcVC)
        }
        transitioningDelegate = transitioncontroller
    }
    
    func handleTap() {
        present(getDesignationVC()!, animated: true, completion: nil)
    }
    
    func getDesignationVC() -> UIViewController? {
        if let destinationViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RevealViewController") as? RevealViewController {
            destinationViewController.petCard = petCard
            destinationViewController.transitioningDelegate = transitioncontroller
            return destinationViewController
        }
        return nil
    }
}
