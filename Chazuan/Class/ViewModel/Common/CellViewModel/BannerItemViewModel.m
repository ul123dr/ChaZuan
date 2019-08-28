//
//  BannerItemViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/17.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "BannerItemViewModel.h"
#import "BannerCell.h"

@interface BannerItemViewModel ()

@property (nonatomic, readwrite, strong) NSArray *model;

@end

@implementation BannerItemViewModel

- (instancetype)initWithModel:(NSArray *)bannerArr {
    if (self = [super init]) {
        self.model = bannerArr;
        self.tableViewCellClass = BannerCell.class;
    }
    return self;
}

@end
