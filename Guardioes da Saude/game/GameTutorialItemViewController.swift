//
//  GameTutorialItemViewController.swift
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 4/22/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

import UIKit

class GameTutorialItemViewController: UIViewController {
    
    var index: Int!
    @IBOutlet weak var lbPageNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.title = ""
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        switch index {
        case 0:
            self.lbPageNumber.text = "Bem-vindo a nossa pista de corrida! \nArraste para saber mais sobre como jogar."
        case 1:
            self.lbPageNumber.text = "Para jogar, é preciso ter pontos de energia.\nParticipe diariamente do Guardiões\nda Saúde para ganhá-los!"
        case 2:
            self.lbPageNumber.text = "Nossa pista de corrida é formada por\nfases. Conclua cada fase para chegar\nmais longe na corrida!"
        case 3:
            self.lbPageNumber.text = "Cada fase contém um quebra-cabeça.\nComplete-o para passar de fase."
        case 4:
            self.lbPageNumber.text = "Responda corretamente as perguntas\nsobre saúde para revelar peças."
        case 5:
            self.lbPageNumber.text = "Colecione figurinhas dos esportes \nolímpicos após concluir cada fase!"
        default:
            self.lbPageNumber.text = "Screen #\(self.index)"
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
