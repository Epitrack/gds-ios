//
//  StartViewController.swift
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 4/25/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

import UIKit
import AVFoundation
import PKHUD

class StartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let questionRequest = QuestionRequester()
    var titleBarImage: UIImageView?
    var audioPlayer: AVAudioPlayer?
    var circleLayer: CAShapeLayer!
    var breakTime = false
    var currentQuestion: Question?
    var user = User.getInstance()
    var rankingList: [RankingItem] = []
    var puzzeDialog: PuzzeViewController?
    var showingMap = true

    
    @IBOutlet weak var viewPuzze: UIView!
    @IBOutlet weak var viewQuestion: UIView!
    @IBOutlet weak var viewQuestionTimer: UIView!
    @IBOutlet weak var lbTimer: UILabel!
    
    @IBOutlet weak var txQuestionDescription: UILabel!
    @IBOutlet weak var btnAnswer1: UIButton!
    @IBOutlet weak var btnAnswer2: UIButton!
    @IBOutlet weak var btnAnswer3: UIButton!
    @IBOutlet weak var viewPt3: UIView!
    @IBOutlet weak var imgPt3: UIImageView!
    @IBOutlet weak var txPoint: UILabel!
    @IBOutlet weak var viewRanking: UIView!
    @IBOutlet weak var tableRanking: UITableView!
    @IBOutlet weak var viewRankingParent: UIView!
    @IBOutlet weak var scrollMap: UIScrollView!
    @IBOutlet weak var imgMap: UIImageView!
    @IBOutlet weak var btnLevel1: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        let btnBack = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(handleBack(_:)))
        btnBack.image = UIImage(named: "icon_back")
        self.navigationItem.leftBarButtonItem = btnBack
        
        let path = NSBundle.mainBundle().pathForResource("effect_button", ofType: "mp3")
        if let _ = path {
            let url = NSURL.fileURLWithPath(path!)
            
            do{
                try self.audioPlayer = AVAudioPlayer(contentsOfURL: url)
            }catch{
                
            }
        }
        
        circleLayer = CAShapeLayer()
        user.points = 10
        
        questionRequest.getQuestion({
            HUD.show(.Progress)
        }, onSuccess: {questions in
            HUD.hide()
            self.currentQuestion = questions[0]
        }, onError: {error in
            HUD.hide()
        })
        
        var arrViews = self.navigationController?.viewControllers
        arrViews!.removeAtIndex(arrViews!.count - 2)
        self.navigationController!.viewControllers = arrViews!
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.viewRanking.layer.cornerRadius = 15
        self.tableRanking.layer.cornerRadius = 15
        
        if let _ = self.titleBarImage {
            self.navigationController?.navigationBar.addSubview(self.titleBarImage!)
        }else{
            self.titleBarImage = UIImageView(image: UIImage(named: "gdSToolbar"))
            let imgSize = CGSize(width: 400, height: 70)
            let imgXPoint = ((self.navigationController?.navigationBar.frame.size.width)!/2) - (imgSize.width/2)
            self.titleBarImage?.frame = CGRectMake(imgXPoint, -25, imgSize.width, imgSize.height)
            
            self.navigationController?.navigationBar.addSubview(self.titleBarImage!)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
//        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.viewQuestionTimer.frame.size.width / 2.0, y: self.viewQuestionTimer.frame.size.height / 2.0), radius: (self.viewQuestionTimer.frame.size.width - 10)/2, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
//        
//        circleLayer.path = circlePath.CGPath
//        circleLayer.fillColor = UIColor.clearColor().CGColor
//        circleLayer.strokeColor = UIColor(red: 239.0/255.0, green: 98.0/255.0, blue: 26.0/255.0, alpha: 1).CGColor
//        circleLayer.lineWidth = 7.0;
//        circleLayer.strokeEnd = 0.0
//        
//        self.viewQuestionTimer.layer.addSublayer(circleLayer)
//        self.viewQuestionTimer.layer.cornerRadius = self.viewQuestionTimer.frame.width/2;
//        
//        
//        
//        
//        
        UIView.animateWithDuration(1, animations: {
            let positionScreen = UIScreen.mainScreen().bounds.size.height/4.0
            
            let positionY = ((self.imgMap.frame.height*1222)/1408) - (positionScreen*3)
            self.scrollMap.contentOffset = CGPointMake(0, positionY)
        })

    }
    
    override func viewWillDisappear(animated: Bool) {
        if let _ = self.titleBarImage{
            self.titleBarImage?.removeFromSuperview()
        }
    }
    
    func resetQuestionDialog() {
        breakTime = false
        btnAnswer1.setBackgroundImage(UIImage(named: "btn_question"), forState: UIControlState.Normal)
        btnAnswer2.setBackgroundImage(UIImage(named: "btn_question"), forState: UIControlState.Normal)
        btnAnswer3.setBackgroundImage(UIImage(named: "btn_question"), forState: UIControlState.Normal)
    }

    @IBAction func btnMedalAction(sender: AnyObject) {
        self.playSoundButton()
    }
    
    @IBAction func btnTrofeuAction(sender: AnyObject) {
        self.playSoundButton()
        if self.rankingList.count == 0 {
            questionRequest.getRanking({HUD.show(.Progress)},
            onSuccess: {rankingList in
                HUD.hide()
                self.rankingList = rankingList
                self.tableRanking.reloadData()
                
                self.viewRankingParent.transform = CGAffineTransformMakeScale(0.1, 0.1)
                self.viewRankingParent.hidden = false;
                
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.viewRankingParent.transform = CGAffineTransformIdentity
                    self.viewRankingParent.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
                }) { (finished: Bool) -> Void in
                    self.animateCircle(14.0)
                }
            }, onError: {error in
                HUD.hide()
            })
        }else{
            self.viewRankingParent.transform = CGAffineTransformMakeScale(0.1, 0.1)
            self.viewRankingParent.hidden = false;
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.viewRankingParent.transform = CGAffineTransformIdentity
                self.viewRankingParent.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
            }) { (finished: Bool) -> Void in
                self.animateCircle(14.0)
            }
        }
    }
    
    @IBAction func btnCloseQuestion(sender: AnyObject) {
        closePopUp(self.viewQuestion)
        self.resetQuestionDialog()
    }
    
    @IBAction func btnCloseRankingDialogAction(sender: AnyObject) {
        self.closePopUp(self.viewRankingParent)
    }
    
    func closePopUp(view: UIView) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            view.transform = CGAffineTransformMakeScale(0.1, 0.1)
            view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }) { (finished: Bool) -> Void in
            view.hidden = true
        }
    }
    
    @IBAction func btnQuestionAction(sender: AnyObject) {
        self.playSoundButton()
        self.viewQuestion.transform = CGAffineTransformMakeScale(0.1, 0.1)
        self.viewQuestion.hidden = false;
        
        self.txQuestionDescription.text = self.currentQuestion?.question
        
        let answer1 = self.currentQuestion!.alternatives[0]
        self.btnAnswer1.setTitle(answer1.answer, forState: UIControlState.Normal)
        
        let answer2 = self.currentQuestion!.alternatives[1]
        self.btnAnswer2.setTitle(answer2.answer, forState: UIControlState.Normal)
        
        let answer3 = self.currentQuestion!.alternatives[2]
        self.btnAnswer3.setTitle(answer3.answer, forState: UIControlState.Normal)
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.viewQuestion.transform = CGAffineTransformIdentity
            self.viewQuestion.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        }) { (finished: Bool) -> Void in
            self.animateCircle(14.0)
        }
    }
    
    func transitionQuestion() {
        let img = UIImage(named: "img_level1_pt1_min")
        let imgSize = imageWithImage(img!, scaledToSize: viewPt3.bounds.size)
        let imgPt3New = UIImageView(image: imgSize)
        imgPt3.bounds = imgPt3.bounds
        
        UIView.transitionFromView(imgPt3, toView: imgPt3New, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func playSoundButton() {
        if let _ = self.audioPlayer {
            if audioPlayer!.playing {
                audioPlayer!.stop()
                audioPlayer?.currentTime = 0
            }
            audioPlayer!.play()
        }
    }
    @IBAction func btnAnswerAction(sender: UIButton) {
        self.user.points -= 1
        self.txPoint.text = "\(user.points) Energias"
        
        let answer = self.currentQuestion!.alternatives[sender.tag]
        if answer.isCorrect {
            self.playSoundButton()
            self.circleLayer.removeAllAnimations();
            self.breakTime = true
            sender.setBackgroundImage(UIImage(named: "btn_correct_answer"), forState: UIControlState.Normal)
            
            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            dispatch_async(queue, {
                sleep(3)
                
                dispatch_async(dispatch_get_main_queue(), {
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.viewQuestion.transform = CGAffineTransformMakeScale(0.1, 0.1)
                        self.viewQuestion.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                    }) { (finished: Bool) -> Void in
                        self.viewQuestion.hidden = true
                        self.resetQuestionDialog()
                    }
                    
                    
                    let congratulationScreen = CongratulationsViewController()
                    congratulationScreen.startViewReference = self
                    self.navigationController?.pushViewController(congratulationScreen, animated: true)
                })
            })
        }else{
            sender.setBackgroundImage(UIImage(named: "btn_wrong_answer"), forState: UIControlState.Normal)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rankingList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cacheId = self.rankingList[indexPath.row].country!
        var cellView = tableView.dequeueReusableCellWithIdentifier(cacheId)
        if cellView == nil {
            cellView = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cacheId)
            cellView?.textLabel?.text = cacheId
        }
        
        return cellView!
    }
    @IBAction func btnLevel(sender: UIButton) {
//        sender.setBackgroundImage(UIImage(named: "ic_map_medal"), forState: UIControlState.Normal)
        if self.puzzeDialog == nil {
            self.puzzeDialog = PuzzeViewController()
            self.puzzeDialog!.startViewRef = self
            self.addChildViewController(self.puzzeDialog!)
            self.puzzeDialog!.view.frame = self.view.frame
            self.viewPuzze.addSubview(self.puzzeDialog!.view)
            self.puzzeDialog!.didMoveToParentViewController(self)
        }
        showingMap = false
        self.viewPuzze.bounds.origin.x = -self.view.frame.width
        self.viewPuzze.hidden = false
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn,
                                   animations: {
                                    self.scrollMap.bounds.origin.x = self.view.frame.width
                                    self.viewPuzze.bounds.origin.x = 0
            },completion: nil)
    }
    
    
    
    func closeDialogPuzze() {
        if let puzzeDialog = self.puzzeDialog {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                puzzeDialog.view.transform = CGAffineTransformMakeScale(0.1, 0.1)
            }) { (finished: Bool) -> Void in
                self.viewPuzze.hidden = true
            }
        }
    }
    
    func handleBack(sender: AnyObject) {
        if showingMap {
            self.navigationController?.popViewControllerAnimated(true)
        }else{
            showingMap = true
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut,
                                       animations: {
                                        self.scrollMap.bounds.origin.x = 0
                                        self.viewPuzze.bounds.origin.x = -self.view.frame.width
                },completion: {finshed in self.viewPuzze.hidden = true})
        }
    }
    
    
}
