//
//  TutorialViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 06/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "TutorialViewController.h"
#import "SelectTypeLoginViewController.h"
#import "CreateAccountViewController.h"
#import "SelectTypeCreateAccoutViewController.h"

@interface TutorialViewController ()
@property (strong, nonatomic) IBOutlet UIPageControl *pageController;
- (IBAction)changeScreen:(id)sender;

@property NSArray *arrImg;

@end

@implementation TutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    self.indexTutorial = 0;
    self.arrImg = @[@"icon_logo_tutorial.png", @"icon_tutorial01", @"icon_tutorial02", @"icon_tutorial03"];
    
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    
    [self.imgBgTutorial addGestureRecognizer:rightSwipe];
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.imgBgTutorial addGestureRecognizer:leftSwipe];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)didSwipe: (UISwipeGestureRecognizer *) sender {
    
    UISwipeGestureRecognizerDirection direction = sender.direction;
    
    if (direction == UISwipeGestureRecognizerDirectionLeft) {
        
        switch (self.indexTutorial) {
            case 0:
                self.imgTutorial.image = [UIImage imageNamed:self.arrImg[1]];
                self.txtTitle.text = @"Como está sua saúde?";
                self.txtDescription.text = @"Maque na lista os sintomas que você apresenta.";
                self.indexTutorial += 1;
                break;
            case 1:
                self.imgTutorial.image = [UIImage imageNamed:self.arrImg[2]];
                self.txtTitle.text = @"Mapa da Saúde";
                self.txtDescription.text = @"Acompanhe os casos de doenças em seu bairro ou um determinado local.";
                self.indexTutorial += 1;
                break;
            case 2:
                self.imgTutorial.image = [UIImage imageNamed:self.arrImg[3]];
                self.txtTitle.text = @"Dicas de Saúde";
                self.txtDescription.text = @"Veja como se prevenir de doenças, quais são as UPAS e farmácias mais próximas de você e telefones úteis para caso de emergência.";
                self.indexTutorial += 1;
                break;
            case 3:
                
                break;
            default:
                break;
        }
    } else if (direction == UISwipeGestureRecognizerDirectionRight) {
        
        switch (self.indexTutorial) {
            case 3:
                self.imgTutorial.image = [UIImage imageNamed:self.arrImg[2]];
                self.txtTitle.text = @"Mapa da Saúde";
                self.txtDescription.text = @"Acompanhe os casos de doenças em seu bairro ou um determinado local.";
                self.indexTutorial -= 1;
                break;
            case 2:
                self.imgTutorial.image = [UIImage imageNamed:self.arrImg[1]];
                self.txtTitle.text = @"Como está sua saúde?";
                self.txtDescription.text = @"Maque na lista os sintomas que você apresenta.";
                self.indexTutorial -= 1;
                break;
            case 1:
                self.imgTutorial.image = [UIImage imageNamed:self.arrImg[0]];
                self.txtTitle.text = @"Bem-vindo";
                self.txtDescription.text = @"Preparado para se tornar um Guardião da Saúde?";
                self.indexTutorial -= 1;
                break;
            case 0:
                
                break;
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changeScreen:(id)sender {
    NSInteger index = self.pageController.currentPage;
    
    self.imgTutorial.image = [UIImage imageNamed:self.arrImg[index]];
}
- (IBAction)btnEnter:(id)sender {
    
    SelectTypeLoginViewController *selectTypeLoginViewController = [[SelectTypeLoginViewController alloc] init];
    [self.navigationController pushViewController:selectTypeLoginViewController animated:YES];
}

- (IBAction)btnNewUser:(id)sender {
    
    SelectTypeCreateAccoutViewController *selectTypeCreateAccoutViewController = [[SelectTypeCreateAccoutViewController alloc] init];
    [self.navigationController pushViewController:selectTypeCreateAccoutViewController animated:YES];
}
@end
