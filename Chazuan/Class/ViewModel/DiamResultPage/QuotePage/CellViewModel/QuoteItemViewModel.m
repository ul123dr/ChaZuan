//
//  QuoteItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/13.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "QuoteItemViewModel.h"
#import "QuoteCell.h"

@implementation QuoteItemViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tableViewCellClass = QuoteCell.class;
    }
    return self;
}

@end
