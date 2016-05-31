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
    
    let user = User.getInstance()
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
    
    func loadPuzzle() {
        self.lbLevel.text = "Nível \(self.user.level)"
        self.hideImageLevel()
        
        for c in 0...2{
            for l in 0...2{
                let isResponded = (self.user.puzzleMatriz[c] as! NSMutableArray)[l]
                if (isResponded as! Int) == 1 {
                    let btnIndice = (c*3)+l+1;

                    switch btnIndice {
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
            }
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
        var partNumber = 0
        for line in 0...2 {
            for column in 0...2 {
                let isAnswer = (self.user.puzzleMatriz[line] as! NSArray)[column] as! Int
                if isAnswer == 1 {
                    partNumber = (line * 3) + column
                    break
                }
            }
        }
        
        if partNumber != 0 {
            showQuestion(partNumber)
        }
    }
    
    func showQuestion(part: Int) {
        self.questionViewCtrl.view.transform = CGAffineTransformMakeScale(0.1, 0.1)
        self.viewQuestion.hidden = false;
        
        let diceRoll = Int(arc4random_uniform(UInt32(questions.count)))
        self.questionViewCtrl.populateQuestion(questions[diceRoll])
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
    
    func transitionQuestion(level: Int, part: Int, callNextQuestion: Bool = false) {
        self.user.partsCompleted = self.user.partsCompleted + 1
        
        if user.partsCompleted == 8 {
            self.showImageLevel()
            user.level = user.level + 1
            user.resetPuzzleMatriz()
            self.startViewRef.setLevelMap(true)
            return
        }
        
        let img = UIImage(named: "img_lvl\(level)_pt\(part)")
        let imgSize = imageWithImage(img!, scaledToSize: viewPt3.bounds.size)
        let imgNew = UIImageView(image: imgSize)
        
        switch part {
        case 1:
            UIView.transitionFromView(imgPt1, toView: imgNew, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            (self.user.puzzleMatriz[0] as! NSMutableArray)[0] = 1
        case 2:
            UIView.transitionFromView(imgPt2, toView: imgNew, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            (self.user.puzzleMatriz[0] as! NSMutableArray)[1] = 1
        case 3:
            UIView.transitionFromView(imgPt3, toView: imgNew, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            (self.user.puzzleMatriz[0] as! NSMutableArray)[2] = 1
        case 4:
            UIView.transitionFromView(imgPt4, toView: imgNew, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            (self.user.puzzleMatriz[1] as! NSMutableArray)[0] = 1
        case 5:
            UIView.transitionFromView(imgPt5, toView: imgNew, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            (self.user.puzzleMatriz[1] as! NSMutableArray)[1] = 1
        case 6:
            UIView.transitionFromView(imgPt6, toView: imgNew, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            (self.user.puzzleMatriz[1] as! NSMutableArray)[2] = 1
        case 7:
            UIView.transitionFromView(imgPt7, toView: imgNew, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            (self.user.puzzleMatriz[2] as! NSMutableArray)[0] = 1
        case 8:
            UIView.transitionFromView(imgPt8, toView: imgNew, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            (self.user.puzzleMatriz[2] as! NSMutableArray)[1] = 1
        case 9:
            UIView.transitionFromView(imgPt9, toView: imgNew, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
            (self.user.puzzleMatriz[2] as! NSMutableArray)[2] = 1
        default:
            break
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
        
        self.imgLevel.image = UIImage(named: "img_lvl\(user.level)")
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
}
