//
//  AYPhotoTransAnimation.swift
//  AYSwiftM
//
//  Created by zw on 2019/5/8.
//  Copyright © 2019 zw. All rights reserved.
//

import UIKit

class AYPhotoTransAnimation: NSObject,UIViewControllerAnimatedTransitioning{
    weak var vc:AYPhotoDetail?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let fromController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let fromView = (fromController?.view)!

        let toController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let toView = (toController?.view)!
        
        //入场动画
        if toController?.isBeingPresented == true {
            containerView.addSubview(toView)
            toView.x = SCREEMW
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
                toView.x = 0
            }) { (_) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
        
        //出场动画
        if fromController?.isBeingDismissed == true {
            print("出场动画")
            
            let tocell = self.vc?.picker?.colletView.cellForItem(at: IndexPath(row: self.vc!.nowIndex, section: 0))
            if tocell != nil {
                let toFrame = tocell?.convert(tocell!.bounds, to: UIApplication.shared.keyWindow)
                let fromcell = self.vc?.colletView.cellForItem(at: IndexPath(row: self.vc!.nowIndex, section: 0)) as? AYPhotoDetailCell
                if fromcell != nil {
                    let fromImageView = fromcell?.animationImageView.superview == nil ? fromcell?.imageView : fromcell?.animationImageView
                    let fromFrame = fromImageView?.convert(fromImageView!.bounds, to: UIApplication.shared.keyWindow)
                    
                    let animationImageView = UIImageView(image: fromImageView?.image)
                    animationImageView.clipsToBounds = true
                    animationImageView.contentMode = .scaleAspectFill
                    animationImageView.frame = fromFrame!
                    containerView.addSubview(animationImageView)
                    
                    fromImageView?.isHidden = true
                    if fromcell?.animationImageView.superview != nil{
                        fromcell?.animationImageView.removeFromSuperview()
                    }
                    UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
                        fromView.alpha = 0
                        animationImageView.frame = toFrame!
                    }) { (_) in
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    }
                    return
                }
            }
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
