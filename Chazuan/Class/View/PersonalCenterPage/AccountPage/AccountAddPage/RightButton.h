//
//  RightButton.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/21.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "ZGButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface RightButton : ZGButton

@property (nonatomic, readwrite, strong) UIImageView *imageIcon;
@property (nonatomic, readwrite, strong) UILabel *nameLabel;

@end

NS_ASSUME_NONNULL_END
