//
//  TutorialViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 06/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "TutorialViewController.h"
#import "SelectTypeLoginViewController.h"
#import "SelectTypeCreateAccoutViewController.h"
#import "SWRevealViewController.h"
#import "User.h"
#import "AFNetworking/AFNetworking.h"
#import "HomeViewController.h"
#import <Google/Analytics.h>
#import "Constants.h"

@interface TutorialViewController () {
    
    User *user;
}
@property (strong, nonatomic) IBOutlet UIPageControl *pageController;
- (IBAction)changeScreen:(id)sender;

@property NSArray *arrImg;

@end

@implementation TutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    user = [User getInstance];
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    
    if (result.height < 568) {
        [self.txtDescription setFont:[UIFont fontWithName:@"Foco-Regular" size:10]];
    }
    
    self.lbDescription.hidden = NO;
    self.txtDescription.text = @"";
    self.navigationItem.hidesBackButton = YES;
    self.indexTutorial = 0;
    self.arrImg = @[@"icon_logo_tutorial.png", @"imgTutorial01.png", @"imgTutorial02.png", @"imgTutorial03.png"];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    
    [self.imgBgTutorial addGestureRecognizer:rightSwipe];
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.imgBgTutorial addGestureRecognizer:leftSwipe];
    

    self.btnEnter.hidden = self.hideButtons;
    self.btnNewUser.hidden = self.hideButtons;
    
    if (self.hideButtons) {
        self.contsPagPanel.constant = -10;
        self.navigationItem.title = NSLocalizedString(@"tutorial.tutorial", @"");
        self.navigationItem.hidesBackButton = NO;
        self.imageConstraint.constant = 20;
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                             forBarMetrics:UIBarMetricsDefault];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Tutorial Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    [self.navigationController setNavigationBarHidden:!self.hideButtons animated:animated];
    [super viewWillAppear:animated];
    self.revealViewController.panGestureRecognizer.enabled=NO;
}

- (void)didSwipe: (UISwipeGestureRecognizer *) sender {
    
    UISwipeGestureRecognizerDirection direction = sender.direction;
    
    if (direction == UISwipeGestureRecognizerDirectionLeft) {
        
        switch (self.indexTutorial) {
            case 0:
                self.imgTutorial.image = [UIImage imageNamed:self.arrImg[1]];
                self.txtTitle.text = NSLocalizedString(@"tutorial.how_is_your_health", @"");
                self.txtDescription.text = NSLocalizedString(@"tutorial.check_your_symptoms", @"");
                self.lbDescription.hidden = YES;
                self.indexTutorial += 1;
                [self.pageControl setCurrentPage:self.indexTutorial];
                
                [self setContraintCustom];
                break;
            case 1:
                self.imgTutorial.image = [UIImage imageNamed:self.arrImg[2]];
                self.txtTitle.text = NSLocalizedString(@"tutorial.health_map", @"");
                self.txtDescription.text = NSLocalizedString(@"tutorial.health_map_description", @"");
                self.lbDescription.hidden = YES;
                self.indexTutorial += 1;
                [self.pageControl setCurrentPage:self.indexTutorial];
                
                [self setContraintCustom];
                break;
            case 2:
                self.imgTutorial.image = [UIImage imageNamed:self.arrImg[3]];
                self.txtTitle.text = NSLocalizedString(@"tutorial.health_tips", @"");
                self.txtDescription.text = NSLocalizedString(@"tutorial.health_tips_description", @"");
                self.lbDescription.hidden = YES;
                self.indexTutorial += 1;
                [self.pageControl setCurrentPage:self.indexTutorial];
                
                [self setContraintCustom];
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
                self.txtTitle.text = NSLocalizedString(@"tutorial.health_map", @"");
                self.txtDescription.text = NSLocalizedString(@"tutorial.health_map_description", @"");
                self.lbDescription.hidden = YES;
                self.indexTutorial -= 1;
                [self.pageControl setCurrentPage:self.indexTutorial];
                [self setContraintCustom];
                break;
            case 2:
                self.imgTutorial.image = [UIImage imageNamed:self.arrImg[1]];
                self.txtTitle.text = NSLocalizedString(@"tutorial.how_is_your_health", @"");
                self.txtDescription.text = NSLocalizedString(@"tutorial.check_your_symptoms", @"");
                self.lbDescription.hidden = YES;
                self.indexTutorial -= 1;
                [self.pageControl setCurrentPage:self.indexTutorial];
                
                [self setContraintCustom];
                break;
            case 1:
                self.imgTutorial.image = [UIImage imageNamed:self.arrImg[0]];
                self.txtTitle.text = NSLocalizedString(@"tutorial.welcome", @"");
                self.txtDescription.text = @"";
                self.lbDescription.hidden = NO;
                self.indexTutorial -= 1;
                [self.pageControl setCurrentPage:self.indexTutorial];
                
                [self setConstraintsDefault];
                break;
            case 0:
                
                break;
            default:
                break;
        }
    }
}

-(void) setConstraintsDefault{
    if (self.hideButtons) {
        self.imageConstraint.constant = 20;
    }else{
        self.imageConstraint.constant = 0;
    }
    self.titleConstraint.constant = 70;
    
}

-(void) setContraintCustom{
    self.titleConstraint.constant = 8;
    if (self.hideButtons) {
        self.imageConstraint.constant = -30;
    }else{
        self.imageConstraint.constant = -50;
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
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_enter"
                                                           label:@"Enter"
                                                           value:nil] build]];
    
    SelectTypeLoginViewController *selectTypeLoginViewController = [[SelectTypeLoginViewController alloc] init];
    [self.navigationController pushViewController:selectTypeLoginViewController animated:YES];
}

- (IBAction)btnNewUser:(id)sender {
    
    SelectTypeCreateAccoutViewController *selectTypeCreateAccoutViewController = [[SelectTypeCreateAccoutViewController alloc] init];
    [self.navigationController pushViewController:selectTypeCreateAccoutViewController animated:YES];
}
@end
