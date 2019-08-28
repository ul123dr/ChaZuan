//
//  PopGoodCell.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/2.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StyleDetailList.h"

NS_ASSUME_NONNULL_BEGIN

@interface PopGoodCell : UITableViewCell

@property (nonatomic, readwrite, strong) UILabel *temp1Label;
@property (nonatomic, readwrite, strong) UILabel *temp2Label;
@property (nonatomic, readwrite, strong) UILabel *temp3Label;
@property (nonatomic, readwrite, strong) UILabel *temp4Label;
@property (nonatomic, readwrite, strong) UILabel *temp5Label;
@property (nonatomic, readwrite, strong) UILabel *temp6Label;
@property (nonatomic, readwrite, strong) UILabel *temp7Label;
@property (nonatomic, readwrite, strong) UILabel *temp8Label;
@property (nonatomic, readwrite, strong) UILabel *statusLabel;
@property (nonatomic, readwrite, strong) UIImageView *dividerLine;

@property (nonatomic, readwrite, strong) UILabel *priceLabel;
@property (nonatomic, readwrite, strong) ZGButton *clickBtn;

- (void)bindModel:(StyleDetailList *)list type:(StyleType)type;

- (void)doSelectCell;

@end

NS_ASSUME_NONNULL_END
