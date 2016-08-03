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
//    var audioPlayer: AVAudioPlayer?
    var circleLayer: CAShapeLayer!
    var breakTime = false
    var currentQuestion: Question?
    var user = User.getInstance()
    var rankingList: [RankingItem] = []
    var showingMap = true
    var btnPin: UIButton!
    var puzzeDialog: PuzzeViewController!
    let levelMapPosition = [[138.0, 110.0],
                            [233.0, 133.0],
                            [106.0, 189.0],
                            [30.0, 200.0],
                            [18.0, 252.0],
                            [94.0, 270.0],
                            [206.0, 280.0],
                            [261.0, 319.0],
                            [250.0, 375.0],
                            [45.0, 427.0],
                            [9.0, 460.0],
                            [23.0, 495.0],
                            [75.0, 509.0],
                            [126.0, 511.0],
                            [177.0, 512.0],
                            [227.0, 519.0],
                            [262.0, 544.0],
                            [266.0, 586.0],
                            [235.0, 613.0],
                            [177.0, 619.0],
                            [124.0, 615.0],
                            [63.0, 612.0],
                            [14.0, 625.0],
                            [2.0, 661.0],
                            [26.0, 703.0],
                            [231.0, 747.0],
                            [262.0, 778.0],
                            [259.0, 817.0],
                            [228.0, 847.0],
                            [176.0, 866.0],
                            [122.0, 873.0],
                            [70.0, 885.0],
                            [19.0, 906.0],
                            [9.0, 960.0],
                            [43.0, 993.0],
                            [97.0, 1_009.0],
                            [155.0, 1_018.0],
                            [212.0, 1_028.0],
                            [256.0, 1_055.5],
                            [265.0, 1_100.0],
                            [236.0, 1_134.0],
                            [189.0, 1_158.0],
                            [122.0, 1_172.0]]
    let levelNames = ["Arco",
                      "Atletismo",
                      "Badminton",
                      "Basquetebol",
                      "BMX",
                      "Boxe",
                      "Canoagem slalom",
                      "Canoagem velocidade",
                      "Ciclismo estrada",
                      "Ciclismo pista",
                      "Esgrima",
                      "Futebol",
                      "ginastica artistica",
                      "Golfe",
                      "Greco",
                      "Handebol",
                      "Hipismo adestramento",
                      "Hipismo CCE",
                      "Hipismo Saltos",
                      "Hóquei",
                      "Judo",
                      "Levantamento",
                      "Luta livre",
                      "Maratonas aquáticas",
                      "Mountain bike",
                      "Nado sincronizado",
                      "Natação",
                      "Pentatlo",
                      "Polo Aquático",
                      "Remo",
                      "Ritmica",
                      "Rugby",
                      "Saltos ornamentais",
                      "Taekwondo",
                      "Tenis",
                      "Tenis de mesa",
                      "Tiro esportivo",
                      "Trampolim",
                      "Triatlo",
                      "Vela",
                      "Volei de praia",
                      "Voleibol"]
    
    @IBOutlet weak var viewPuzze: UIView!
    @IBOutlet weak var txPoint: UILabel!
    @IBOutlet weak var viewRanking: UIView!
    @IBOutlet weak var tableRanking: UITableView!
    @IBOutlet weak var viewRankingParent: UIView!
    @IBOutlet weak var viewTropheis: UIView!
    @IBOutlet weak var tableTropheis: UITableView!
    @IBOutlet weak var scrollMap: UIScrollView!
    @IBOutlet weak var imgMap: UIImageView!
    @IBOutlet weak var lblRankingTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        let btnBack = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(handleBack(_:)))
        btnBack.image = UIImage(named: "icon_back")
        self.navigationItem.leftBarButtonItem = btnBack
        
//        let path = NSBundle.mainBundle().pathForResource("effect_button", ofType: "mp3")
//        if let _ = path {
//            let url = NSURL.fileURLWithPath(path!)
//            
//            do{
//                try self.audioPlayer = AVAudioPlayer(contentsOfURL: url)
//            }catch{
//                
//            }
//        }
        
        circleLayer = CAShapeLayer()
        
        // Removing from stack tutorail view
        var arrViews = self.navigationController?.viewControllers
        let view = arrViews![arrViews!.count - 2]
        if view.isEqual(GameTutorialViewController) {
            arrViews!.removeAtIndex(arrViews!.count - 2)
            self.navigationController!.viewControllers = arrViews!
        }
        
        self.updateEnergyPoint()
        
        self.tableTropheis.registerNib(UINib(nibName: "TrophiesCell", bundle: nil), forCellReuseIdentifier: "TrophiesCell")
        
        let rightButton = UIBarButtonItem(image: UIImage(named: "icon_game_tutorial"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(goTutorial))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    func goTutorial() {
        let tutorial = GameTutorialViewController()
        
        self.navigationController?.pushViewController(tutorial, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.viewRanking.layer.cornerRadius = 15
        self.tableRanking.layer.cornerRadius = 15
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
    
    func setLevelMap(updateLevel: Bool) {
        let mapWidth = Double(self.imgMap.frame.width)
        let mapHeight = Double(self.imgMap.frame.height)
        
        let plots: Int = self.levelMapPosition.count - Int(self.user.level)
        
        if updateLevel {
            self.btnPin.removeFromSuperview()
        }
        
        for index in plots...self.levelMapPosition.count-1 {
            let position = self.levelMapPosition[index]
            let x = (position[0] * mapWidth)/320
            let y = (position[1] * mapHeight)/1400
            let width = (55*mapWidth)/320
            let height = (55*mapHeight)/1400
            
            if index == plots {
                let positionRect = CGRect(x: x, y: y-2.5, width: width, height: height+5)
                self.btnPin = UIButton(frame: positionRect)
                self.btnPin.setBackgroundImage(UIImage(named: "ic_map_pin"), forState: UIControlState.Normal)
                self.btnPin.addTarget(self, action: #selector(btnLevel(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                self.scrollMap.addSubview(self.btnPin)
            }else{
                let positionRect = CGRect(x: x, y: y, width: width, height: height)
                let img = UIImageView(frame: positionRect)
                img.image = UIImage(named: "ic_map_medal")
                self.scrollMap.addSubview(img)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if self.user.level < 37 {
            UIView.animateWithDuration(1, animations: {
                let positionScreen = UIScreen.mainScreen().bounds.size.height/8.0
                let indexPosition = self.levelMapPosition.count - Int(self.user.level)
                let positionPin = CGFloat(self.levelMapPosition[indexPosition][1])
                let heightImgMap = self.imgMap.frame.height
                
                let positionY = ((heightImgMap*positionPin)/1408) - (positionScreen*5)
                self.scrollMap.contentOffset = CGPointMake(0, positionY)
            })
        }

        setLevelMap(false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let _ = self.titleBarImage{
            self.titleBarImage?.removeFromSuperview()
        }
    }

    @IBAction func btnMedalAction(sender: AnyObject) {
        self.playSoundButton()
        self.viewTropheis.hidden = true
        self.lblRankingTitle.text = NSLocalizedString("game.ranking", comment: "")
        
        if self.rankingList.count == 0 {
            questionRequest.getRanking({HUD.show(.Progress)},
                                       onSuccess: {rankingList in
                                        HUD.hide()
                                        self.rankingList = rankingList
                                        self.tableRanking.reloadData()
                                        
                                        self.showDialogRanking()
                }, onError: {error in
                    HUD.hide()
            })
        }else{
            self.showDialogRanking()
        }
    }
    
    @IBAction func btnTrofeuAction(sender: AnyObject) {
        self.playSoundButton()
        self.viewTropheis.hidden = false
        self.tableTropheis.reloadData()
        self.lblRankingTitle.text = NSLocalizedString("game.trophies", comment: "")
        self.showDialogRanking()
    }
    
    func showDialogRanking() {
        self.viewRanking.transform = CGAffineTransformMakeScale(0.1, 0.1)
        self.viewRankingParent.hidden = false;
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.viewRanking.transform = CGAffineTransformIdentity
        }) { (finished: Bool) -> Void in
            
        }
    }
    
    @IBAction func btnCloseRankingDialogAction(sender: AnyObject) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.viewRanking.transform = CGAffineTransformMakeScale(0.1, 0.1)
        }) { (finished: Bool) -> Void in
            self.viewRankingParent.hidden = true
        }
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
//        if let _ = self.audioPlayer {
//            if audioPlayer!.playing {
//                audioPlayer!.stop()
//                audioPlayer?.currentTime = 0
//            }
//            audioPlayer!.play()
//        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isEqual(tableRanking) {
            return self.rankingList.count
        }else{
            return self.user.level - 1
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView.isEqual(self.tableRanking){
            var country = "No name \(indexPath.row)"
            if let listCountry = self.rankingList[indexPath.row].country{
                country = listCountry
            }
            
            let cacheId = country
            
            var cellView = tableView.dequeueReusableCellWithIdentifier(cacheId)
            if cellView == nil {
                cellView = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cacheId)
                cellView?.textLabel?.text = cacheId
            }
            
            return cellView!
        }else{
            let cellView = tableView.dequeueReusableCellWithIdentifier("TrophiesCell", forIndexPath: indexPath) as! TrophiesCell
            let image = UIImage(named: "img_lvl\(indexPath.row+1)")!
            cellView.setInformations(image, description: self.levelNames[indexPath.row])
            
            return cellView
        }
    }
    @IBAction func btnLevel(sender: UIButton) {
//        sender.setBackgroundImage(UIImage(named: "ic_map_medal"), forState: UIControlState.Normal)
        
        if let puzzeDialog = self.puzzeDialog{
            puzzeDialog.removeFromParentViewController()
            puzzeDialog.view.removeFromSuperview()
        }
        
        puzzeDialog = PuzzeViewController()
        puzzeDialog.startViewRef = self
        self.addChildViewController(puzzeDialog)
        puzzeDialog.view.frame = self.view.frame
        self.viewPuzze.addSubview(puzzeDialog.view)
        puzzeDialog.didMoveToParentViewController(self)
        
        showingMap = false
        self.viewPuzze.bounds.origin.x = -self.view.frame.width
        self.viewPuzze.hidden = false
        puzzeDialog.loadPuzzle()
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn,
                                   animations: {
                                    self.scrollMap.bounds.origin.x = self.view.frame.width
                                    self.viewPuzze.bounds.origin.x = 0
            },completion: { finished in
                self.scrollMap.hidden = true
        })
    }
    
    
    
    func closeDialogPuzze() {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.puzzeDialog.view.transform = CGAffineTransformMakeScale(0.1, 0.1)
        }) { (finished: Bool) -> Void in
            self.viewPuzze.hidden = true
        }
    }
    
    func handleBack(sender: AnyObject) {
        back()
    }
    
    func back() {
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
        self.updateEnergyPoint()
    }
    
    func updateEnergyPoint() {
        self.txPoint.text = String(format: NSLocalizedString("game.energy", comment: ""), user.points)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView.isEqual(self.tableTropheis) {
            return 97
        }else{
            return 73.5
        }
    }
}
