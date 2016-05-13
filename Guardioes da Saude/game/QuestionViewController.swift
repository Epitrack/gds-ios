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

    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var btnAlternativeOne: UIButton!
    @IBOutlet weak var btnAlternativeTwo: UIButton!
    @IBOutlet weak var btnAlternativeThree: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    func populateQuestion(question: Question) {
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
    }
}
