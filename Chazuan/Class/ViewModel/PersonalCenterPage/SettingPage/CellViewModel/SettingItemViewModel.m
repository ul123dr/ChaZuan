//
//  SettingItemViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "SettingItemViewModel.h"
#import "SettingCell.h"

@implementation SettingItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.tableViewCellClass = SettingCell.class;
    }
    return self;
}

@end
