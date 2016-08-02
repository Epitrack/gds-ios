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
    
    @IBOutlet weak var lbLevel: UILabel!
    @IBOutlet weak var viewQuestions: UIView!
    @IBOutlet weak var viewQuestion: UIView!
    @IBOutlet weak var viewPt1: UIView!
    @IBOutlet weak var imgPt1: UIImageView!
    @IBOutlet weak var btnPt1: UIButton!
    @IBOutlet weak var viewPt2: UIView!
    @IBOutlet weak var imgPt2: UIImageView!
    @IBOutlet weak var btnPt2: UIButton!
    @IBOutlet weak var viewPt3: UIView!
    @IBOutlet weak var imgPt3: UIImageView!
    @IBOutlet weak var btnPt3: UIButton!
    @IBOutlet weak var viewPt4: UIView!
    @IBOutlet weak var imgPt4: UIImageView!
    @IBOutlet weak var btnPt4: UIButton!
    @IBOutlet weak var viewPt5: UIView!
    @IBOutlet weak var imgPt5: UIImageView!
    @IBOutlet weak var btnPt5: UIButton!
    @IBOutlet weak var viewPt6: UIView!
    @IBOutlet weak var imgPt6: UIImageView!
    @IBOutlet weak var btnPt6: UIButton!
    @IBOutlet weak var viewPt7: UIView!
    @IBOutlet weak var imgPt7: UIImageView!
    @IBOutlet weak var btnPt7: UIButton!
    @IBOutlet weak var viewPt8: UIView!
    @IBOutlet weak var imgPt8: UIImageView!
    @IBOutlet weak var btnPt8: UIButton!
    @IBOutlet weak var viewPt9: UIView!
    @IBOutlet weak var imgPt9: UIImageView!
    @IBOutlet weak var btnPt9: UIButton!
    @IBOutlet weak var imgLevel: UIImageView!
    @IBOutlet weak var viewLowEnergy: UIView!
    @IBOutlet weak var dialogLowEnergy: UIView!
    
    let user = User.getInstance()
    var questionViewCtrl = QuestionViewController()
    let questionRequest = QuestionRequester()
    var startViewRef: StartViewController!
    var questions: [Question] = []
    var questionIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addChildViewController(self.questionViewCtrl)
        self.questionViewCtrl.view.frame = self.viewQuestion.frame
        self.questionViewCtrl.didMoveToParentViewController(self)
        self.questionViewCtrl.puzzeViewCtrlRef = self
        self.viewQuestion.addSubview(questionViewCtrl.view)
        self.imgLevel.hidden = true
        
        self.loadQuestions(nil, onError: nil)
    }
    
    func loadQuestions(onSuccess: (() -> Void)?, onError: (() -> Void)?) {
        var currentLanguage = NSLocale.preferredLanguages()[0]
        if currentLanguage == "zh-Hans-CN" {
            currentLanguage = "ch"
        }else if currentLanguage == "pt-BR"{
            currentLanguage = "pt_BR"
        }
        
        questionRequest.getQuestion(currentLanguage,
            onStart: {
                HUD.show(.Progress)
            }, onSuccess: {questions in
                HUD.hide()
                self.questions = questions
                if let onSuccess = onSuccess{
                    onSuccess()
                }
            }, onError: {error in
                HUD.hide()
                let alert = ViewUtil.showAlertWithMessage(NSLocalizedString(kMsgConnectionError, comment: ""))
                self.presentViewController(alert, animated: true, completion: nil)
                if let onError = onError{
                    onError()
                }
        })
    }
    
    func loadPuzzle() {
        self.lbLevel.text = String(format: NSLocalizedString("game.level", comment: ""), self.user.level)
        
        var index = 1
        for part in self.user.puzzleMatriz{
            if (part as! Int) == 1{
                switch index {
                case 1:
                    imgPt1.image = UIImage(named: "img_lvl\(user.level)_pt1")
                    btnPt1.enabled = false
                case 2:
                    imgPt2.image = UIImage(named: "img_lvl\(user.level)_pt2")
                    btnPt2.enabled = false
                case 3:
                    imgPt3.image = UIImage(named: "img_lvl\(user.level)_pt3")
                    btnPt3.enabled = false
                case 4:
                    imgPt4.image = UIImage(named: "img_lvl\(user.level)_pt4")
                    btnPt4.enabled = false
                case 5:
                    imgPt5.image = UIImage(named: "img_lvl\(user.level)_pt5")
                    btnPt5.enabled = false
                case 6:
                    imgPt6.image = UIImage(named: "img_lvl\(user.level)_pt6")
                    btnPt6.enabled = false
                case 7:
                    imgPt7.image = UIImage(named: "img_lvl\(user.level)_pt7")
                    btnPt7.enabled = false
                case 8:
                    imgPt8.image = UIImage(named: "img_lvl\(user.level)_pt8")
                    btnPt8.enabled = false
                case 9:
                    imgPt9.image = UIImage(named: "img_lvl\(user.level)_pt9")
                    btnPt9.enabled = false
                default:
                    break
                }
            }
            
            index += 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnPuzzePart(sender: UIButton) {
        self.showQuestion(sender.tag)
    }
    
    func showNextQuestion() {
        var index = 0
        for part in self.user.puzzleMatriz {
            index += 1
            if (part as! Int) == 0 {
                showQuestion(index)
                break
            }
        }
    }
    
    func showQuestion(part: Int) {
        if self.user.points <= 0 {
            self.showLowEnergyDialog()
            return
        }
        
        if self.questions.count == 0 {
            self.loadQuestions({
                    self.showDialogQuestion(part)
                }, onError: nil)
        }else{
            self.showDialogQuestion(part)
        }
    }
    
    func removeQuestion() {
        self.questions.removeAtIndex(self.questionIndex)
    }
    
    func showDialogQuestion(part: Int) {
        self.questionViewCtrl.view.transform = CGAffineTransformMakeScale(0.1, 0.1)
        self.viewQuestion.hidden = false;
        
        let diceRoll = Int(arc4random_uniform(UInt32(questions.count)))
        self.questionViewCtrl.populateQuestion(questions[diceRoll])
        self.questionIndex = diceRoll
        self.questionViewCtrl.part = part
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
    
    func transitionQuestion(level: Int, part: Int, callNextQuestion: Bool = false, isLevelDone: Bool) {
        
        if isLevelDone {
            self.showImageLevel()
            self.startViewRef.setLevelMap(true)
            return
        }
        
        let img = UIImage(named: "img_lvl\(level)_pt\(part)")
        
        if let img = img {
            let imgSize = imageWithImage(img, scaledToSize: viewPt3.bounds.size)
            let imgNew = UIImageView(image: imgSize)
            
            switch part {
            case 1:
                UIView.transitionFromView(self.imgPt1, toView: imgNew, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            case 2:
                UIView.transitionFromView(self.imgPt2, toView: imgNew, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            case 3:
                UIView.transitionFromView(self.imgPt3, toView: imgNew, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            case 4:
                UIView.transitionFromView(self.imgPt4, toView: imgNew, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            case 5:
                UIView.transitionFromView(self.imgPt5, toView: imgNew, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            case 6:
                UIView.transitionFromView(self.imgPt6, toView: imgNew, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            case 7:
                UIView.transitionFromView(self.imgPt7, toView: imgNew, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            case 8:
                UIView.transitionFromView(self.imgPt8, toView: imgNew, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            case 9:
                UIView.transitionFromView(self.imgPt9, toView: imgNew, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            default:
                break
            }
        }
        
        if callNextQuestion {
            showNextQuestion()
        }
    }
    
    func showImageLevel() {
        self.viewPt1.hidden = true
        self.viewPt2.hidden = true
        self.viewPt3.hidden = true
        self.viewPt4.hidden = true
        self.viewPt5.hidden = true
        self.viewPt6.hidden = true
        self.viewPt7.hidden = true
        self.viewPt8.hidden = true
        self.viewPt9.hidden = true
        
        self.imgLevel.image = UIImage(named: "img_lvl\(user.level-1)")
        self.imgLevel.hidden = false
    }
    
    func hideImageLevel() {
        self.viewPt1.hidden = false
        self.imgPt1.image = UIImage(named: "icon_answer-1")
        self.btnPt1.enabled = true
        self.viewPt2.hidden = false
        self.imgPt2.image = UIImage(named: "icon_answer-1")
        self.btnPt2.enabled = true
        self.viewPt3.hidden = false
        self.imgPt3.image = UIImage(named: "icon_answer-1")
        self.btnPt3.enabled = true
        self.viewPt4.hidden = false
        self.imgPt4.image = UIImage(named: "icon_answer-1")
        self.btnPt4.enabled = true
        self.viewPt5.hidden = false
        self.imgPt5.image = UIImage(named: "icon_answer-1")
        self.btnPt5.enabled = true
        self.viewPt6.hidden = false
        self.imgPt6.image = UIImage(named: "icon_answer-1")
        self.btnPt6.enabled = true
        self.viewPt7.hidden = false
        self.imgPt7.image = UIImage(named: "icon_answer-1")
        self.btnPt7.enabled = true
        self.viewPt8.hidden = false
        self.imgPt8.image = UIImage(named: "icon_answer-1")
        self.btnPt8.enabled = true
        self.viewPt9.hidden = false
        self.imgPt9.image = UIImage(named: "icon_answer-1")
        self.btnPt9.enabled = true
        self.imgLevel.hidden = true
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    @IBAction func btnLowEnergy(sender: AnyObject) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.dialogLowEnergy.transform = CGAffineTransformMakeScale(0.1, 0.1)
        }) { (finished: Bool) -> Void in
            self.viewLowEnergy.hidden = true
        }
    }
    
    func showLowEnergyDialog(){
        self.viewLowEnergy.hidden = false
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.dialogLowEnergy.transform = CGAffineTransformIdentity
        }) { (finished: Bool) -> Void in
            
        }
    }
    
    @IBAction func joinNow(sender: AnyObject) {
        let selectParticipant = SelectParticipantViewController()
        self.navigationController?.pushViewController(selectParticipant, animated: true)
    }
}
