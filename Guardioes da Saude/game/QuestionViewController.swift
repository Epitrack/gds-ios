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
    var part: Int!
    let user = User.getInstance()
    let questionRequester = QuestionRequester()
    var answerWrong = 0
    

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
        
        let bgCircleLayer = CAShapeLayer()
        bgCircleLayer.path = circlePath.CGPath
        bgCircleLayer.fillColor = UIColor.clearColor().CGColor
        bgCircleLayer.strokeColor = UIColor(red: 1, green: 201.0/255.0, blue: 3.0/255.0, alpha: 1).CGColor
        bgCircleLayer.lineWidth = 7.0
        bgCircleLayer.strokeEnd = 1
        
        self.viewTimer.layer.addSublayer(bgCircleLayer)
        self.viewTimer.layer.addSublayer(circleLayer)
        self.viewTimer.layer.cornerRadius = self.viewTimer.frame.width/2;
    }
   
    func populateQuestion(question: Question) {
        self.answerWrong = 0
        
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
        self.breakTime = true
        puzzeViewCtrlRef.closeQuestionDialog()
    }

    @IBAction func btnAlternative(sender: AnyObject) {
        self.puzzeViewCtrlRef.startViewRef.reducePoint()
        
        let answer = self.question.alternatives[sender.tag]
        if answer.isCorrect {
            self.enableButtons(false)
            
            self.circleLayer.removeAllAnimations();
            self.breakTime = true
            sender.setBackgroundImage(UIImage(named: "btn_correct_answer"), forState: UIControlState.Normal)
            self.imgBgDialog.image = UIImage(named: "bg_correct_dialog")
            self.viemCorrectAnswer.hidden = false
            self.lbDescription.hidden = true
            
            self.user.partsCompleted += 1
            self.user.puzzleMatriz[part-1] = 1
            var isLevelDone = false
            
            if self.user.partsCompleted == 9  {
                self.user.level += 1
                self.user.resetPuzzleMatriz()
                isLevelDone = true
            }
            
            self.puzzeViewCtrlRef.removeQuestion()
            
            questionRequester.updateGame(question, user: self.user, onStart: {
                }, onSuccess: {
                    self.callCongratulationScreen(isLevelDone)
                }, onError: { error in
                    ViewUtil.showAlertWithMessage(NSLocalizedString(kMsgConnectionError, comment: ""))
            })
        }else{
            sender.setBackgroundImage(UIImage(named: "btn_wrong_answer"), forState: UIControlState.Normal)
            self.answerWrong += 1
            
            if user.points <= 0 {
                self.puzzeViewCtrlRef.closeQuestionDialog()
                self.puzzeViewCtrlRef.showLowEnergyDialog()
            }
        }
    }
    
    func callCongratulationScreen(isLevelDone: Bool) {
        let congratulationScreen = CongratulationsViewController()
        congratulationScreen.puzzeViewReference = self.puzzeViewCtrlRef
        congratulationScreen.questionViewRef = self
        congratulationScreen.stars = 3 - self.answerWrong
        congratulationScreen.part = self.part
        congratulationScreen.level = isLevelDone ? Int(self.user.level-1) : Int(self.user.level)
        congratulationScreen.isLevelDone = isLevelDone
        
        self.navigationController?.pushViewController(congratulationScreen, animated: true)
    }
    
    func animateCircle(duration: NSTimeInterval) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        self.circleLayer.speed = 1
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        circleLayer.strokeEnd = 1.0
        circleLayer.addAnimation(animation, forKey: "animateCircle")
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue, {
            for i in 0...15 {
                if self.breakTime {
                    self.circleLayer.speed = 0.0
                    self.breakTime = false
                    break
                }else{
                    dispatch_async(dispatch_get_main_queue()) {
                        self.lbTimer.text = "\(15-i)"
                    }
                    sleep(1)
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.puzzeViewCtrlRef.closeQuestionDialog()
            }
        })
    }
    
    func resetView() {
        self.enableButtons(true)
        self.viemCorrectAnswer.hidden = true;
        self.imgBgDialog.image = UIImage(named: "bg_answer")
        self.lbDescription.hidden = false
        self.btnAlternativeOne.setBackgroundImage(UIImage(named: "btn_question"), forState: UIControlState.Normal)
        self.btnAlternativeTwo.setBackgroundImage(UIImage(named: "btn_question"), forState: UIControlState.Normal)
        self.btnAlternativeThree.setBackgroundImage(UIImage(named: "btn_question"), forState: UIControlState.Normal)
    }
    
    func enableButtons(enable: Bool) {
        self.btnAlternativeOne.enabled = enable
        self.btnAlternativeTwo.enabled = enable
        self.btnAlternativeThree.enabled = enable
    }
}
