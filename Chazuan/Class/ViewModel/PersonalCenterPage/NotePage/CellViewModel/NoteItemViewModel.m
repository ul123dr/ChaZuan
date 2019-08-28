//
//  NoteItemViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "NoteItemViewModel.h"
#import "NoteCell.h"

@implementation NoteItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.tableViewCellClass = NoteCell.class;
    }
    return self;
}

@end
