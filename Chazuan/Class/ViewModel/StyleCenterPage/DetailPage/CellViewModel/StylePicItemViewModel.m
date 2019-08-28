//
//  StylePicItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/25.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "StylePicItemViewModel.h"
#import "CyclePicCell.h"

@interface StylePicItemViewModel ()

@property (nonatomic, readwrite, strong) NSArray *model;

@end

@implementation StylePicItemViewModel

- (instancetype)initWithModel:(NSArray *)bannerArr {
    if (self = [super init]) {
        self.model = bannerArr;
        self.tableViewCellClass = CyclePicCell.class;
        self.shouldHideDividerLine = YES;
    }
    return self;
}


@end
