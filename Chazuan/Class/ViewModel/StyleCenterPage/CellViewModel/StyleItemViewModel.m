//
//  StyleItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/5.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "StyleItemViewModel.h"
#import "StyleTableViewCell.h"

@interface StyleItemViewModel ()

@property (nonatomic, readwrite, strong) NSArray *model;

@end

@implementation StyleItemViewModel

- (instancetype)initWithModel:(NSArray *)models {
    if (self = [super init]) {
        self.model = models;
        self.tableViewCellClass = StyleTableViewCell.class;
    }
    return self;
}

@end
