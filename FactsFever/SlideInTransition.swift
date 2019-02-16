//
//  SlideInTransition.swift
//  FactsFever
//
//  Created by Shree Bhagwat on 16/02/19.
//  Copyright © 2019 Development. All rights reserved.
//

import UIKit

class SlideInTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var isPresenting = false
    let dimmingView = UIView()
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
        let fromViewController = transitionContext.viewController(forKey: .from) else {return}
        
        let containView = transitionContext.containerView
        
        let finalWidth = toViewController.view.bounds.width * 0.8
        let finalHeight = toViewController.view.bounds.height
        
        if isPresenting {
            // Adding Diming View Behind The Menu
            containView.addSubview(dimmingView)
            dimmingView.backgroundColor = #colorLiteral(red: 0.01342590339, green: 0.06923117489, blue: 0.1467640102, alpha: 1)
            dimmingView.alpha = 0.0
            dimmingView.frame = containView.bounds
            // Add Our Menu View Controller to Container
            containView.addSubview(toViewController.view)
            // Init Frame off the screen
            toViewController.view.frame = CGRect(x: -finalWidth, y: 0, width: finalWidth, height: finalHeight)
            
        }
        // Animate on the screen
        let transform = {
            self.dimmingView.alpha = 0.6
            toViewController.view.transform = CGAffineTransform(translationX: finalWidth, y: 0)
        }
        // Animate Back offScreen
        let identity = {
            self.dimmingView.alpha = 0.0
            fromViewController.view.transform = .identity
        }
        // Animation of the transition
        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        
        UIView.animate(withDuration: duration, animations: {
            self.isPresenting ? transform() : identity()
        }) { (_) in
            transitionContext.completeTransition(!isCancelled)
        }
    }
    
    

}
