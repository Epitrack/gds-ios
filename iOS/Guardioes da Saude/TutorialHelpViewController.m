//
//  TutorialHelpViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 13/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "TutorialHelpViewController.h"
#import <Google/Analytics.h>

@interface TutorialHelpViewController ()

@property NSArray *arrImg;

@end

@implementation TutorialHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Tutorial";
    
    self.indexTutorial = 0;
    self.arrImg = @[@"icon_logo_tutorial.png", @"icon_tutorial01", @"icon_tutorial02", @"icon_tutorial03"];
    
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    
    [self.imgBgTutorial addGestureRecognizer:rightSwipe];
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.imgBgTutorial addGestureRecognizer:leftSwipe];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Tutorial Help Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
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
                [self.pageController setCurrentPage:self.indexTutorial];
                break;
            case 1:
                self.imgTutorial.image = [UIImage imageNamed:self.arrImg[2]];
                self.txtTitle.text = @"Mapa da Saúde";
                self.txtDescription.text = @"Acompanhe os casos de doenças em seu bairro ou um determinado local.";
                self.indexTutorial += 1;
                [self.pageController setCurrentPage:self.indexTutorial];
                break;
            case 2:
                self.imgTutorial.image = [UIImage imageNamed:self.arrImg[3]];
                self.txtTitle.text = @"Dicas de Saúde";
                self.txtDescription.text = @"Veja como se prevenir de doenças, quais são as UPAS e farmácias mais próximas de você e telefones úteis para caso de emergência.";
                self.indexTutorial += 1;
                [self.pageController setCurrentPage:self.indexTutorial];
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
                [self.pageController setCurrentPage:self.indexTutorial];
                break;
            case 2:
                self.imgTutorial.image = [UIImage imageNamed:self.arrImg[1]];
                self.txtTitle.text = @"Como está sua saúde?";
                self.txtDescription.text = @"Maque na lista os sintomas que você apresenta.";
                self.indexTutorial -= 1;
                [self.pageController setCurrentPage:self.indexTutorial];
                break;
            case 1:
                self.imgTutorial.image = [UIImage imageNamed:self.arrImg[0]];
                self.txtTitle.text = @"Bem-vindo";
                self.txtDescription.text = @"Preparado para se tornar um Guardião da Saúde?";
                self.indexTutorial -= 1;
                [self.pageController setCurrentPage:self.indexTutorial];
                break;
            case 0:
                
                break;
            default:
                break;
        }
    }
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


@end
