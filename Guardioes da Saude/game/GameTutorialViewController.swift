//
//  GameTutorialViewController.swift
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 4/20/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

import UIKit

class GameTutorialViewController: UIViewController {

    @IBOutlet weak var btnAnimate: UIButton!
    var cardView: UIView!
    var back: UIImageView!
    var front: UIImageView!
    var showingBack = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        front = UIImageView(image: UIImage(named: "bgWhite.png"))
        back = UIImageView(image: UIImage(named: "BG_blur_menu.png"))
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        singleTap.numberOfTapsRequired = 1
        
        let rect = CGRectMake(20, 20, back.image!.size.width, back.image!.size.height)
        cardView = UIView(frame: rect)
        cardView.addGestureRecognizer(singleTap)
        cardView.userInteractionEnabled = true
        cardView.addSubview(back)
        
        view.addSubview(cardView)
        
        
        // Do any additional setup after loading the view.
    }
    
    func tapped() {
        if (showingBack) {
            UIView.transitionFromView(back, toView: front, duration: 1, options: UIViewAnimationOptions.TransitionCurlDown, completion: nil)
            showingBack = false
        } else {
            UIView.transitionFromView(front, toView: back, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: nil)
            showingBack = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(animated: Bool) {
      
    }

    @IBAction func animate(sender: AnyObject) {
        
    }
}
