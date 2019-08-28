//
//  UpDownButton.h
//  chazuan
//
//  Created by BecksZ on 2019/4/17.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UpDownButton : UIButton

- (void)setShowBorder:(BOOL)showBorder;

- (void)setImage:(NSString *)imgPath title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
