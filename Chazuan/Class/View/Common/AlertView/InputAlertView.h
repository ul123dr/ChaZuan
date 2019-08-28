//
//  InputAlertView.h
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^InputAlertHandle)(BOOL action, NSString *inputStr);

@interface InputAlertView : UIView

+ (void)alertWithHandle:(nullable InputAlertHandle)handle;

@end

NS_ASSUME_NONNULL_END
