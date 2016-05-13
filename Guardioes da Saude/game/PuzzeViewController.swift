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
    
    let questionViewCtrl = QuestionViewController()
    let questionRequest = QuestionRequester()
    var startViewRef: StartViewController!
    var questions: [Question] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewQuestion.addSubview(questionViewCtrl.view)
        self.addChildViewController(self.questionViewCtrl)
        self.questionViewCtrl.view.frame = self.viewQuestion.frame
        self.questionViewCtrl.didMoveToParentViewController(self)
        self.questionViewCtrl.puzzeViewCtrlRef = self
        // Do any additional setup after loading the view.
        
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

    @IBAction func btnPuzzePart(sender: AnyObject) {
        self.questionViewCtrl.view.transform = CGAffineTransformMakeScale(0.1, 0.1)
        self.viewQuestion.hidden = false;
        
        let diceRoll = Int(arc4random_uniform(UInt32(questions.count)))
        self.questionViewCtrl.populateQuestion(questions[diceRoll])
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.questionViewCtrl.view.transform = CGAffineTransformIdentity
        }) { (finished: Bool) -> Void in
            
        }
    }
    
    func closeQuestionDialog() {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.questionViewCtrl.view.transform = CGAffineTransformMakeScale(0.1, 0.1)
        }) { (finished: Bool) -> Void in
            self.viewQuestion.hidden = true
        }
    }
}
