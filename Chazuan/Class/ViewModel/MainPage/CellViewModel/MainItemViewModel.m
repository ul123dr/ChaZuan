//
//  MainItemViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/17.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MainItemViewModel.h"
#import "MainFuncCell.h"

@interface MainItemViewModel ()

@property (nonatomic, readwrite, strong) NSArray *icons;
@property (nonatomic, readwrite, strong) NSArray *names;
@property (nonatomic, readwrite, strong) NSArray *needLogins;
@property (nonatomic, readwrite, strong) NSArray *destViewModelClasses;

@end

@implementation MainItemViewModel

- (instancetype)initWithIcon:(NSArray *)icons name:(NSArray *)names login:(NSArray *)needLogins destClass:(NSArray *)destClass {
    if (self = [super init]) {
        self.icons = icons;
        self.names = names;
        self.needLogins = needLogins;
        self.destViewModelClasses = destClass;
        self.tableViewCellClass = MainFuncCell.class;
    }
    return self;
}

@end
