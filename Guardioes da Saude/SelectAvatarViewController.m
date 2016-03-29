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
#import <MobileCoreServices/UTCoreTypes.h>
@import PhotosUI;

@interface SelectAvatarViewController () {
    BOOL showCameraBtn;
    UIImagePickerController* picker;
}
@end

@implementation SelectAvatarViewController


- (instancetype)initWithBtnCamera: (bool) showBtnCamera{
    showCameraBtn = showBtnCamera;
    
    return [super init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"select_avatar.title", @"");
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
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Guardiões da Saúde"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *cameraOption = [UIAlertAction actionWithTitle:@"Câmera"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self showCamera];
                                                          }];
    [alert addAction:cameraOption];
    
    UIAlertAction *galeryOption = [UIAlertAction actionWithTitle:@"Galeria"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self showGallery];
                                                          }];
    [alert addAction:galeryOption];
    
    UIAlertAction *cancelOption = [UIAlertAction actionWithTitle:@"Cancelar"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                         }];
    [alert addAction:cancelOption];
    
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showGallery{
    [self requestPermissions:^(bool authorized){
        if(!authorized){
            UIAlertController *alert = [ViewUtil showAlertWithMessage:NSLocalizedString(@"select_avatar.check_galery_permission", @"")];
            
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            picker = [[UIImagePickerController alloc] init];
            picker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage,nil];
            [picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            [picker setDelegate:self];
            picker.modalPresentationStyle = UIModalPresentationCurrentContext;
           
            [self presentViewController:picker animated:YES completion:nil];
        }
    }];
}

- (void)showCamera{
    [self requestPermissions:^(bool authorized){
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertController *alert = [ViewUtil showAlertWithMessage:@"Aparelho não possui câmera."];
            
            [self presentViewController:alert animated:YES completion:nil];
        } else if(!authorized){
            UIAlertController *alert = [ViewUtil showAlertWithMessage:NSLocalizedString(@"select_avatar.check_galery_permission", @"")];
            
            [self presentViewController:alert animated:YES completion:nil];
        }else {
            // Init Picker
            picker = [[UIImagePickerController alloc] init];
            
            CGFloat navigationBarHeight = picker.navigationBar.bounds.size.height;
            CGFloat height = picker.view.bounds.size.height - navigationBarHeight;
            CGFloat width = picker.view.bounds.size.width;
            CGRect f = CGRectMake(0, 0, width, height);
            
            
            UIImageView *overlayIV = [[UIImageView alloc] initWithFrame:f];
            
            [overlayIV setUserInteractionEnabled:NO];
            [overlayIV setExclusiveTouch:NO];
            [overlayIV setMultipleTouchEnabled:NO];
            [overlayIV.layer addSublayer:[self doMakeLayerWithDiffHeight:navigationBarHeight+navigationBarHeight]];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.allowsEditing = YES;
            if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
                picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            
            UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-54, self.view.frame.size.width, 55)];
            
            toolBar.barStyle =  UIBarStyleBlackOpaque;
            NSArray *items=[NSArray arrayWithObjects:
                            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel  target:self action:@selector(cancelPicture)],
                            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil],
                            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera  target:self action:@selector(shootPicture)],
                            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil],
                            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil],
                            nil];
            [toolBar setItems:items];
            
            UIView *cameraView=[[UIView alloc] initWithFrame:self.view.bounds];
            [cameraView addSubview:overlayIV];
            [cameraView addSubview:toolBar];
            
            picker.showsCameraControls=NO;
            [picker setCameraOverlayView:cameraView];
            
            [self presentViewController:picker animated:YES completion:nil];
        }
    }];
}

-(void) cancelPicture{
    [picker dismissViewControllerAnimated:NO completion:NULL];
}

-(void)shootPicture{
    [picker takePicture];
}

- (CAShapeLayer *) doMakeLayerWithDiffHeight: (double) diffHeight{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat previewHeight = screenSize.width + (screenSize.width / 3);
    CGFloat totalBlack = screenSize.height - previewHeight;
    CGFloat heightOfBlackTopAndBottom = totalBlack / 2;
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    
    UIBezierPath *path2 = [UIBezierPath bezierPathWithOvalInRect:
                           CGRectMake(0.0f, heightOfBlackTopAndBottom, screenSize.width, screenSize.width)];
    [path2 setUsesEvenOddFillRule:YES];
    
    [circleLayer setPath:[path2 CGPath]];
    
    [circleLayer setFillColor:[[UIColor clearColor] CGColor]];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, screenSize.width, previewHeight+(heightOfBlackTopAndBottom*.5)) cornerRadius:0];
    
    [path appendPath:path2];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.8;
    
    return fillLayer;
}

- (IBAction)selectAvatarAction:(id)sender {
    NSInteger tag = ((UIButton *) sender).tag;
    [self setAvatar:[NSNumber numberWithInteger:tag]];
}

-(void)setUrlPhoto:(NSString *)urlPhoto{
    [self.profileFormCtr setPhoto:urlPhoto];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)localPicker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    // GOOGLE ANALYTICS
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"
                                                          action:@"button_change_avatar"
                                                           label:@"Change avatar"
                                                           value:nil] build]];
    
    UIImage *image = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
    UIImage *imageCroped = [self imageByCroppingImage:image];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __block NSString *url;
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:imageCroped];
        url = [[assetChangeRequest placeholderForCreatedAsset] localIdentifier];
    } completionHandler:^(BOOL success, NSError *error){
        if (!success) {
            NSLog(@"Error creating asset: %@", error);
            if (error.code == 2047) {
                UIAlertController *alert = [ViewUtil showAlertWithMessage:NSLocalizedString(@"select_avatar.no_galery_permission", @"")];
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
    
    double heightWith;
    if (size.width < size.height) {
        heightWith = size.width;
    } else {
        heightWith = size.height;
    }
    

    CGRect cropRect = CGRectMake(x, y, heightWith, heightWith*1.1);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    
    UIImage *cropped = [UIImage imageWithCGImage:imageRef scale:0.0 orientation:image.imageOrientation];
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
