//
//  ChangeProfileViewController.m
//  chazuan
//
//  Created by BecksZ on 2019/4/26.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "ChangeProfileViewController.h"

@interface ChangeProfileViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, readwrite, strong) ChangeProfileViewModel *viewModel;

@end

@implementation ChangeProfileViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self);
    [self.viewModel.photoSub subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self checkPhoto];
    }];
}

- (void)checkPhoto {
    
    UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:@"选择头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.navigationBar.translucent=NO; // 去掉毛玻璃，解决iOS11，遮挡导航栏问题
        CGRect frame = imagePicker.navigationBar.frame;
        UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [imagePicker.view insertSubview:alphaView belowSubview:imagePicker.navigationBar];
        [imagePicker.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        imagePicker.navigationBar.layer.masksToBounds = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    [alertSheet addAction:photoAction];
    [alertSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self.navigationController presentViewController:alertSheet animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        // 处理
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        [self.viewModel.uploadSub sendNext:image];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    } else {
        Alert(@"请在‘设置-相册-查钻’授权使用相册功能", @"取消", @"确定", ^(BOOL action) {
            [picker dismissViewControllerAnimated:YES completion:nil];
        });
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
