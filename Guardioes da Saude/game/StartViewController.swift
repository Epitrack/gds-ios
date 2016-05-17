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
    var levelMapPosition = [[121.0, 1_177.0],
                            [190.0, 1_164.0],
                            [237.0, 1_135.0],
                            [265.0, 1_100.0],
                            [255.0, 1_058.0],
                            [213.0, 1_030.0],
                            [156.0, 1_020.0],
                            [97.0, 1_009.0],
                            [43.0, 995.0],
                            [9.0, 960.0],
                            [19.0, 908.0],
                            [70.0, 887.0],
                            [123.0, 876.0],
                            [228.0, 848.0],
                            [259.0, 817.0]]

    
    @IBOutlet weak var viewPuzze: UIView!
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
        user.level = 1
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
    
    func setLevelMap() {
        let mapWidth = Double(self.imgMap.frame.width)
        let mapHeight = Double(self.imgMap.frame.height)
        
        for position in self.levelMapPosition {
            let x = (position[0] * mapWidth)/320
            let y = (position[1] * mapHeight)/1400
            let width = (55*mapWidth)/320
            let height = (55*mapHeight)/1400
            
            let positionRect = CGRect(x: x, y: y, width: width, height: height)
            let button = UIButton(frame: positionRect)
            button.setBackgroundImage(UIImage(named: "ic_map_medal"), forState: UIControlState.Normal)
            self.scrollMap.addSubview(button)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(1, animations: {
            let positionScreen = UIScreen.mainScreen().bounds.size.height/4.0
            
            let positionY = ((self.imgMap.frame.height*1222)/1408) - (positionScreen*3)
            self.scrollMap.contentOffset = CGPointMake(0, positionY)
        })

        setLevelMap()
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let _ = self.titleBarImage{
            self.titleBarImage?.removeFromSuperview()
        }
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
                
            }
        }
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
            },completion: { finished in
                self.scrollMap.hidden = true
        })
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
            
            self.scrollMap.hidden = false
            self.scrollMap.bounds.origin.x  =   self.view.frame.width
            
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut,
                                       animations: {
                                        self.scrollMap.bounds.origin.x = 0
                                        self.viewPuzze.bounds.origin.x = -self.view.frame.width
                },completion: {finshed in self.viewPuzze.hidden = true})
        }
    }
    
    func reducePoint() {
        self.user.points -= 1
        self.txPoint.text = "\(user.points) Energias"
    }
}
