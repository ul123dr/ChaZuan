//
//  QRCodeViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "QRCodeViewModel.h"

@interface QRCodeViewModel ()

@property (nonatomic, readwrite, copy) UIImage *qrImage;

@end

@implementation QRCodeViewModel

- (void)initialize {
    [super initialize];
    
    self.title = self.params[ViewModelTitleKey];
    self.backgroundColor = UIColor.whiteColor;
    NSString *url;
    if ([SingleInstance stringForKey:UserSellerIdKey]) {
        url = [NSString stringWithFormat:@"http://%@/newManager/app/index.html#!/codeReg?salesmen_id=%@", [SingleInstance stringForKey:ZGCUserWwwKey], [SingleInstance stringForKey:UserSellerIdKey]];
    }
    if (self.services.client.currentUser.userType == 99) {
        url = [NSString stringWithFormat:@"http://%@/newManager/app/index.html#!/codeReg", [SingleInstance stringForKey:ZGCUserWwwKey]];
    }
    if (kStringIsNotEmpty(url)) {
        self.qrImage = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:url] withSize:ZGCConvertToPx(200)];
    }
}

// 二维码生成－YourtionGuo
#pragma mark - InterpolatedUIImage
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - QRCodeGenerator
- (CIImage *)createQRForString:(NSString *)qrString
{
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // Send the image back
    return qrFilter.outputImage;
}

@end
