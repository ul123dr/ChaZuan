//
//  EditRightsItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "EditRightsItemViewModel.h"
#import "EditRightsCell.h"

@implementation EditRightsItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.shouldEdited = YES;
        self.tableViewCellClass = EditRightsCell.class;
    }
    return self;
}


@end
