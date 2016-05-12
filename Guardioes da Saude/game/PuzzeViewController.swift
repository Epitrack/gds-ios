//
//  PuzzeViewController.swift
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 5/12/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

import UIKit

class PuzzeViewController: UIViewController {
    
    @IBOutlet weak var viewQuestions: UIView!
    
    var startViewRef: StartViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.startViewRef.closeDialogPuzze()
        var basketTopFrame = viewQuestions.frame
        basketTopFrame.origin.x = 0
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {self.viewQuestions.frame = basketTopFrame}, completion: {finished in })
    }
    
    @IBAction func btnQuestion3Action(sender: AnyObject) {
        var basketTopFrame = viewQuestions.frame
        basketTopFrame.origin.x = -viewQuestions.frame.width
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {self.viewQuestions.frame = basketTopFrame}, completion: {finished in })
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
