//
//  QuestionViewController.swift
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 5/13/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {

    var puzzeViewCtrlRef: PuzzeViewController!
    var circleLayer = CAShapeLayer()
    var breakTime = false
    var question: Question!
    let user = User.getInstance()

    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var btnAlternativeOne: UIButton!
    @IBOutlet weak var btnAlternativeTwo: UIButton!
    @IBOutlet weak var btnAlternativeThree: UIButton!
    
    @IBOutlet weak var lbTimer: UILabel!
    @IBOutlet weak var viewTimer: UIView!
    @IBOutlet weak var imgBgDialog: UIImageView!
    @IBOutlet weak var viemCorrectAnswer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.viewTimer.frame.size.width / 2.0, y: self.viewTimer.frame.size.height / 2.0), radius: (self.viewTimer.frame.size.width - 10)/2, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        
        circleLayer.path = circlePath.CGPath
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = UIColor(red: 239.0/255.0, green: 98.0/255.0, blue: 26.0/255.0, alpha: 1).CGColor
        circleLayer.lineWidth = 7.0;
        circleLayer.strokeEnd = 0.0
        
        self.viewTimer.layer.addSublayer(circleLayer)
        self.viewTimer.layer.cornerRadius = self.viewTimer.frame.width/2;
    }
   
    func populateQuestion(question: Question) {
        self.question = question
        
        self.lbDescription.text = question.question
        
        let answer1 = question.alternatives[0]
        self.btnAlternativeOne.setTitle(answer1.answer, forState: UIControlState.Normal)
        
        let answer2 = question.alternatives[1]
        self.btnAlternativeTwo.setTitle(answer2.answer, forState: UIControlState.Normal)
        
        let answer3 = question.alternatives[2]
        self.btnAlternativeThree.setTitle(answer3.answer, forState: UIControlState.Normal)
    }
    
    @IBAction func btnClose(sender: AnyObject) {
        puzzeViewCtrlRef.closeQuestionDialog()
    }

    @IBAction func btnAlternative(sender: AnyObject) {
        self.puzzeViewCtrlRef.startViewRef.reducePoint()
        
        let answer = self.question.alternatives[sender.tag]
        if answer.isCorrect {
            self.circleLayer.removeAllAnimations();
            self.breakTime = true
            sender.setBackgroundImage(UIImage(named: "btn_correct_answer"), forState: UIControlState.Normal)
            self.imgBgDialog.image = UIImage(named: "bg_correct_dialog")
            self.viemCorrectAnswer.hidden = false
            self.lbDescription.hidden = true
            
            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            dispatch_async(queue, {
                sleep(3)
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.puzzeViewCtrlRef.closeQuestionDialog()
                    
                    let congratulationScreen = CongratulationsViewController()
                    congratulationScreen.puzzeViewReference = self.puzzeViewCtrlRef
                    self.navigationController?.pushViewController(congratulationScreen, animated: true)
                })
            })
        }else{
            sender.setBackgroundImage(UIImage(named: "btn_wrong_answer"), forState: UIControlState.Normal)
        }
    }
    
    func animateCircle(duration: NSTimeInterval) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        circleLayer.strokeEnd = 1.0
        circleLayer.addAnimation(animation, forKey: "animateCircle")
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue, {
            for i in 1...15 {
                if self.breakTime {
                    break
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.lbTimer.text = "\(i)"
                }
                sleep(1)
            }
        })
    }
}
