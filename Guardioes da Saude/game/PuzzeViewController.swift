//
//  PuzzeViewController.swift
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 5/12/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

import UIKit
import PKHUD

class PuzzeViewController: UIViewController {
    
    @IBOutlet weak var viewQuestions: UIView!
    @IBOutlet weak var viewQuestion: UIView!
    @IBOutlet weak var viewPt1: UIView!
    @IBOutlet weak var imgPt1: UIImageView!
    @IBOutlet weak var viewPt2: UIView!
    @IBOutlet weak var imgPt2: UIImageView!
    @IBOutlet weak var viewPt3: UIView!
    @IBOutlet weak var imgPt3: UIImageView!
    @IBOutlet weak var viewPt4: UIView!
    @IBOutlet weak var imgPt4: UIImageView!
    @IBOutlet weak var viewPt5: UIView!
    @IBOutlet weak var imgPt5: UIImageView!
    @IBOutlet weak var viewPt6: UIView!
    @IBOutlet weak var imgPt6: UIImageView!
    @IBOutlet weak var viewPt7: UIView!
    @IBOutlet weak var imgPt7: UIImageView!
    @IBOutlet weak var viewPt8: UIView!
    @IBOutlet weak var imgPt8: UIImageView!
    @IBOutlet weak var viewPt9: UIView!
    @IBOutlet weak var imgPt9: UIImageView!
    
    let questionViewCtrl = QuestionViewController()
    let questionRequest = QuestionRequester()
    var startViewRef: StartViewController!
    var questions: [Question] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addChildViewController(self.questionViewCtrl)
        self.questionViewCtrl.view.frame = self.viewQuestion.frame
        self.questionViewCtrl.didMoveToParentViewController(self)
        self.questionViewCtrl.puzzeViewCtrlRef = self
        self.viewQuestion.addSubview(questionViewCtrl.view)
        
        self.loadQuestions()
    }
    
    func loadQuestions() {
        questionRequest.getQuestion({
            HUD.show(.Progress)
            }, onSuccess: {questions in
                HUD.hide()
                self.questions = questions
            }, onError: {error in
                HUD.hide()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnPuzzePart(sender: UIButton) {
        self.questionViewCtrl.view.transform = CGAffineTransformMakeScale(0.1, 0.1)
        self.viewQuestion.hidden = false;
        
        let diceRoll = Int(arc4random_uniform(UInt32(questions.count)))
        self.questionViewCtrl.populateQuestion(questions[diceRoll])
        self.questionViewCtrl.part = sender.tag
        self.questionViewCtrl.resetView();
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.questionViewCtrl.view.transform = CGAffineTransformIdentity
        }) { (finished: Bool) -> Void in
            self.questionViewCtrl.animateCircle(15)
        }
    }
    
    func closeQuestionDialog() {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.questionViewCtrl.view.transform = CGAffineTransformMakeScale(0.1, 0.1)
        }) { (finished: Bool) -> Void in
            self.viewQuestion.hidden = true
        }
    }
    
    func transitionQuestion(level: Int, part: Int) {
        let img = UIImage(named: "img_lvl1_pt\(part)")
        let imgSize = imageWithImage(img!, scaledToSize: viewPt3.bounds.size)
        let imgNew = UIImageView(image: imgSize)
        
        switch part {
        case 1:
            UIView.transitionFromView(imgPt1, toView: imgNew, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
        case 2:
            UIView.transitionFromView(imgPt2, toView: imgNew, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
        case 3:
            UIView.transitionFromView(imgPt3, toView: imgNew, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
        case 4:
            UIView.transitionFromView(imgPt4, toView: imgNew, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
        case 5:
            UIView.transitionFromView(imgPt5, toView: imgNew, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
        case 6:
            UIView.transitionFromView(imgPt6, toView: imgNew, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
        case 7:
            UIView.transitionFromView(imgPt7, toView: imgNew, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
        case 8:
            UIView.transitionFromView(imgPt8, toView: imgNew, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
        case 9:
            UIView.transitionFromView(imgPt9, toView: imgNew, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
        default:
            break
        }
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
