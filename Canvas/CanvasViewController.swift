//
//  CanvasViewController.swift
//  Canvas
//
//  Created by Abhijeet Chakrabarti on 3/23/17.
//  Copyright © 2017 Abhijeet Chakrabarti. All rights reserved.
//


import UIKit

class CanvasViewController: UIViewController {
    
    @IBOutlet weak var trayView: UIView!
    
    var trayOriginalCenter: CGPoint?
    var trayIsOpen = true
    
    var trayCenterWhenClosed: CGPoint!
    var trayCenterWhenOpen: CGPoint!
    
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint?
    
    var landedFaceOriginalCenter: CGPoint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.trayCenterWhenOpen = self.trayView.center
        self.trayCenterWhenClosed = CGPoint(x: self.view.center.x, y: self.view.frame.size.height + (self.trayView.frame.size.height / 2) - 30)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func toggleTrayView() {
        var toPoint: CGPoint
        if self.trayIsOpen {
            toPoint = self.trayCenterWhenClosed
        } else {
            toPoint = self.trayCenterWhenOpen
        }
        self.animateTrayCenterToPoint(toPoint)
        self.trayIsOpen = !self.trayIsOpen
    }
    
    fileprivate func animateTrayCenterToPoint(_ point: CGPoint) {
        UIView.animate(
            withDuration: 0.35,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0.35,
            options: UIViewAnimationOptions(),
            animations: { () -> Void in
                self.trayView.center = point
        },
            completion: nil
        )
    }
    
    @IBAction func onTapGesture(_ tapGestureRecognizer: UITapGestureRecognizer) {
        self.toggleTrayView()
    }
    
    @IBAction func onTrayPanGesture(_ panGestureRecognizer: UIPanGestureRecognizer) {
        // Relative change in (x,y) coordinates from where gesture began.
        let translation = panGestureRecognizer.translation(in: view)
        let velocity = panGestureRecognizer.velocity(in: view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.began {
            trayOriginalCenter = trayView.center
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.changed {
            let newTrayCenterY = translation.y + trayOriginalCenter!.y
            trayView.center.y = newTrayCenterY < self.trayCenterWhenOpen.y ? self.trayCenterWhenOpen.y : newTrayCenterY
        } else if panGestureRecognizer.state == UIGestureRecognizerState.ended {
            if velocity.y < 0 {
                self.animateTrayCenterToPoint(self.trayCenterWhenOpen)
                self.trayIsOpen = true
            } else {
                self.animateTrayCenterToPoint(self.trayCenterWhenClosed)
                self.trayIsOpen = false
            }
        }
    }
    
    func onNewSmileyPan(_ panGestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translation(in: view)
        
        let mySmileyView = panGestureRecognizer.view
        
        if panGestureRecognizer.state == UIGestureRecognizerState.began {
            
            self.landedFaceOriginalCenter = mySmileyView!.center
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.changed {
            
            mySmileyView!.center = CGPoint(
                x: self.landedFaceOriginalCenter!.x + translation.x,
                y: self.landedFaceOriginalCenter!.y + translation.y
            )
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.ended {
            
        }
    }
    
    func onPinchSmiley(_ pinchGestureRecognizer: UIPinchGestureRecognizer) {
        let mySmileyView = pinchGestureRecognizer.view
        
        if pinchGestureRecognizer.state == UIGestureRecognizerState.began {
            
            
        } else if pinchGestureRecognizer.state == UIGestureRecognizerState.changed {
            let scale = pinchGestureRecognizer.scale / log(pinchGestureRecognizer.scale)
            mySmileyView!.transform = mySmileyView!.transform.scaledBy(x: scale, y: scale)
            
        } else if pinchGestureRecognizer.state == UIGestureRecognizerState.ended {
            
        }
    }
    
    func onRotateSmiley(_ rotateGestureRecognizer: UIRotationGestureRecognizer) {
        let mySmileyView = rotateGestureRecognizer.view
        
        if rotateGestureRecognizer.state == UIGestureRecognizerState.began {
            
            
        } else if rotateGestureRecognizer.state == UIGestureRecognizerState.changed {
            print("rotate changed")
            
            mySmileyView!.transform = mySmileyView!.transform.rotated(by: CGFloat(rotateGestureRecognizer.rotation * CGFloat(M_PI) / CGFloat(180)))
            
        } else if rotateGestureRecognizer.state == UIGestureRecognizerState.ended {
            
        }
    }
    
    @IBAction func onSmileyPanGesture(_ panGestureRecognizer: UIPanGestureRecognizer) {
        // Relative change in (x,y) coordinates from where gesture began.
        let translation = panGestureRecognizer.translation(in: view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.began {
            
            let imageView = panGestureRecognizer.view as! UIImageView
            self.newlyCreatedFace = UIImageView(image: imageView.image)
            self.view.addSubview(self.newlyCreatedFace)
            self.newlyCreatedFace.center = imageView.center
            self.newlyCreatedFace.center.y += self.trayView.frame.origin.y
            self.newlyCreatedFaceOriginalCenter = self.newlyCreatedFace.center
            
            let newGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(CanvasViewController.onNewSmileyPan(_:)))
            self.newlyCreatedFace.addGestureRecognizer(newGestureRecognizer)
            self.newlyCreatedFace.isUserInteractionEnabled = true
            
            newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            
            let newPinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(CanvasViewController.onPinchSmiley(_:)))
            self.newlyCreatedFace.addGestureRecognizer(newPinchRecognizer)
            
            let newRotateRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(CanvasViewController.onRotateSmiley(_:)))
            self.newlyCreatedFace.addGestureRecognizer(newRotateRecognizer)
            
            newPinchRecognizer.delegate = self
            
            
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.changed {
            self.newlyCreatedFace.center = CGPoint(
                x: self.newlyCreatedFaceOriginalCenter!.x + translation.x,
                y: self.newlyCreatedFaceOriginalCenter!.y + translation.y
            )
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.ended {
            self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
}

extension CanvasViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
