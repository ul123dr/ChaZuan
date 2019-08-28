//
//  PdfViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "PdfViewModel.h"

@interface PdfViewModel ()

@property (nonatomic, readwrite, copy) NSString *pdf;
@property (nonatomic, readwrite, copy) NSString *type;

@property (nonatomic, readwrite, copy) NSString *pdfUrl;

@end

@implementation PdfViewModel

- (void)initialize {
    [super initialize];
    
    self.type = self.params[ViewModelPdfTypeKey];
    self.pdf = self.params[ViewModelPdfUrlKey];
    @weakify(self);
    [RACObserve(self, pdf) subscribeNext:^(NSString *pdf) {
        [MBProgressHUD zgc_show];
        @strongify(self);
        if (kStringIsEmpty(pdf)) [self.services popViewModelAnimated:YES];
        else if ([self _isImage:pdf]) [self _showImage];
        else [self _getPdf];
    }];
}

- (BOOL)_isImage:(NSString *)url {
    NSString *lowUrl = [url lowercaseString];
    if ([lowUrl containsString:@".jpg"]) return YES;
    if ([lowUrl containsString:@".png"]) return YES;
    if ([lowUrl containsString:@".jpeg"]) return YES;
//    if ([lowUrl containsString:@".bmp"]) return YES;
    return NO;
}

- (void)_showImage {
    if (![self.pdf hasPrefix:@"http"]) {
        NSString *picUrl = [NSString stringWithFormat:@"http://%@/fileserver/api/%@/%@", [SingleInstance stringForKey:ZGCUserWwwKey].length>0?[SingleInstance stringForKey:ZGCUserWwwKey]:ServerHttp, [self.type lowercaseString], self.pdf];
        if ([SharedAppDelegate.manager.isOwnServer zgc_parseInt] == 2) {
            picUrl = [NSString stringWithFormat:@"http://www.zuansoft.com/fileserver/api/%@/%@", [self.type lowercaseString], self.pdf];
        }
        self.pdfUrl = picUrl;
    } else {
        self.pdfUrl = self.pdf;
    }
    [MBProgressHUD zgc_hideHUDDelay:0.5];
}

- (void)_getPdf {
    self.pdfUrl = self.pdf;
    [MBProgressHUD zgc_hideHUDDelay:0.5];
}

@end
