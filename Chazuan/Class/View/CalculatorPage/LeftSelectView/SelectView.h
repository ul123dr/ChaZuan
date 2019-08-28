//
//  SelectView.h
//  chazuan
//
//  Created by BecksZ on 2019/4/27.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectView : UIView

+ (instancetype)selectViewWithData:(NSArray *)data isLeft:(BOOL)left;
@property (nonatomic, readonly, copy) NSString *select;

@end

NS_ASSUME_NONNULL_END
