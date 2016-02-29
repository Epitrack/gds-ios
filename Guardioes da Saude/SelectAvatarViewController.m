//
//  SelectAvatarViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 24/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "SelectAvatarViewController.h"
#import "ProfileFormViewController.h"
#import "ViewUtil.h"
#import "AssetsLibrary/AssetsLibrary.h"
#import "MBProgressHUD.h"
#import <Google/Analytics.h>
@import PhotosUI;

@interface SelectAvatarViewController () {
    BOOL showCameraBtn;
}



@end

@implementation SelectAvatarViewController


- (instancetype)initWithBtnCamera: (bool) showBtnCamera{
    showCameraBtn = showBtnCamera;
    
    return [super init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Editar Foto";
    UIBarButtonItem *navBarButtonAppearance = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UINavigationBar class]]];
    [navBarButtonAppearance setTitleTextAttributes:@{
                                                     NSFontAttributeName:            [UIFont systemFontOfSize:0.1],
                                                     NSForegroundColorAttributeName: [UIColor clearColor] }
                                          forState:UIControlStateNormal];
    
    self.btnPhoto.hidden = !showCameraBtn;
}

- (void)requestPermissions:(void(^)(bool)) block
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    switch (status)
    {
        case PHAuthorizationStatusAuthorized:
            block(YES);
            break;
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus authorizationStatus)
             {
                 if (authorizationStatus == PHAuthorizationStatusAuthorized)
                 {
                     block(YES);
                 }
                 else
                 {
                     block(NO);
                 }
             }];
            break;
        }
        default:
            block(NO);
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Select Avatar Screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnPhotoAction:(id)sender {
    
    [self requestPermissions:^(bool authorized){
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertController *alert = [ViewUtil showAlertWithMessage:@"Aparelho não possui câmera."];
            
            [self presentViewController:alert animated:YES completion:nil];
        } else if(!authorized){
            UIAlertController *alert = [ViewUtil showAlertWithMessage:@"Verifique as permissões da galeria 'Fotos'."];
            
            [self presentViewController:alert animated:YES completion:nil];
        }else {
            // Init Picker
            UIImagePickerController* picker = [[UIImagePickerController alloc] init];
            
            //Create camera overlay for square pictures
            CGFloat navigationBarHeight = picker.navigationBar.bounds.size.height;
            CGFloat height = picker.view.bounds.size.height - navigationBarHeight;
            CGFloat width = picker.view.bounds.size.width;
            CGRect f = CGRectMake(0, navigationBarHeight-10, width, height);

            
            UIImageView *overlayIV = [[UIImageView alloc] initWithFrame:f];
            
            // Disable all user interaction on overlay
            [overlayIV setUserInteractionEnabled:NO];
            [overlayIV setExclusiveTouch:NO];
            [overlayIV setMultipleTouchEnabled:NO];
            
            // Map generated image to overlay
            //overlayIV.image = overlayImage;
            [overlayIV.layer addSublayer:[self doMakeLayerWithDiffHeight:navigationBarHeight+navigationBarHeight]];
            
            // Present Picker
    //        picker.modalPresentationStyle = UIModalPresentationCurrentContext;
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing = YES;
            if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
                picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            [picker setCameraOverlayView:overlayIV];
            
            [self presentViewController:picker animated:YES completion:nil];
        }
    }];
}

- (CAShapeLayer *) doMakeLayerWithDiffHeight: (double) diffHeight{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    
    UIBezierPath *path2 = [UIBezierPath bezierPathWithOvalInRect:
                           CGRectMake(0.0f, 55.0f, screenSize.width, screenSize.width)];
    [path2 setUsesEvenOddFillRule:YES];
    
    [circleLayer setPath:[path2 CGPath]];
    
    [circleLayer setFillColor:[[UIColor clearColor] CGColor]];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, screenSize.width, screenSize.height-(diffHeight+15)) cornerRadius:0];
    
    [path appendPath:path2];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.8;
    
    return fillLayer;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)selectAvatarAction:(id)sender {
    NSInteger tag = ((UIButton *) sender).tag;
    [self setAvatar:[NSNumber numberWithInteger:tag]];
}

-(void)setUrlPhoto:(NSString *)urlPhoto{
    [self.profileFormCtr setPhoto:urlPhoto];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_change_avatar"
                                                           label:@"Change avatar"
                                                           value:nil] build]];
    
    UIImage *image = (UIImage *) [info objectForKey: UIImagePickerControllerEditedImage];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __block NSString *url;
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        url = [[assetChangeRequest placeholderForCreatedAsset] localIdentifier];
    } completionHandler:^(BOOL success, NSError *error){
        if (!success) {
            NSLog(@"Error creating asset: %@", error);
            if (error.code == 2047) {
                UIAlertController *alert = [ViewUtil showAlertWithMessage:@"O Aplicativo não tem permissão para gravar a foto."];
                [self presentViewController:alert animated:YES completion:nil];
            }
        } else {
            [self.profileFormCtr setPhoto:url];
            [picker dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (UIImage *)imageByCroppingImage:(UIImage *)image
{
    // not equivalent to image.size (which depends on the imageOrientation)!
    double refWidth = CGImageGetWidth(image.CGImage);
    double refHeight = CGImageGetHeight(image.CGImage);
    CGSize size = image.size;
    
    double x = (refWidth - size.width) / 2.0;
    double y = (refHeight - size.height) / 2.0;
    

    CGRect cropRect = CGRectMake(x, y, size.width, size.width);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef scale:0.0 orientation:UIImageOrientationRight];
    CGImageRelease(imageRef);
    
    return cropped;
}

- (void) setAvatar:(NSNumber *)idAvatar {
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_change_avatar"
                                                           label:@"Change avatar"
                                                           value:nil] build]];
    
    [self.profileFormCtr setAvatarNumber:idAvatar];

    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
