//
//  KeyboardView.h
//  chazuan
//
//  Created by BecksZ on 2019/4/28.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyboardView : UIView

+ (instancetype)keyboardView;

@property (nonatomic, readwrite, copy) VoidBlock_string handle;

@end

NS_ASSUME_NONNULL_END
