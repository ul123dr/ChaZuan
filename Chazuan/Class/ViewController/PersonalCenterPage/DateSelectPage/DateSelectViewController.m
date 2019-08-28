//
//  DateSelectViewController.m
//  chazuan
//
//  Created by BecksZ on 2019/4/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "DateSelectViewController.h"
#import "PGDatePickManager.h"

@interface DateSelectViewController ()<PGDatePickerDelegate>

@property (nonatomic, readwrite, strong) DateSelectViewModel *viewModel;
@property (nonatomic, readwrite, assign) BOOL start;

@end

@implementation DateSelectViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self);
    [self.viewModel.dateSub subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.start = x.boolValue;
        
        PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
        datePickManager.style = PGDatePickManagerStyleAlertBottomButton;
        datePickManager.isShadeBackground = true;
        PGDatePicker *datePicker = datePickManager.datePicker;
        datePicker.delegate = self;
        datePicker.datePickerType = PGDatePickerTypeVertical;
        datePicker.datePickerMode = PGDatePickerModeDate;
        [self presentViewController:datePickManager animated:false completion:nil];
        
        // 自定义收起动画逻辑
        datePickManager.customDismissAnimation = ^NSTimeInterval(UIView *dismissView, UIView *contentView) {
            NSTimeInterval duration = 0.3f;
            [UIView animateWithDuration:duration animations:^{
                contentView.frame = (CGRect){{contentView.frame.origin.x, CGRectGetMaxY(self.view.bounds)}, contentView.bounds.size};
            } completion:^(BOOL finished) {
            }];
            return duration;
        };
    }];
}

#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate setYear:dateComponents.year month:dateComponents.month day:dateComponents.day hour:0 minute:0];
    if (self.start) {
        self.viewModel.startDate = [formatter stringFromDate:date];
    } else {
        self.viewModel.endDate = [formatter stringFromDate:date];
    }
}

@end
