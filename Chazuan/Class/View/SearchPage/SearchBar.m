//
//  SearchBar.m
//  Chazuan
//
//  Created by BecksZ on 2019/5/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "SearchBar.h"

#define IOS11_ORLATER ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending )

@implementation SearchBar
{
    NSString *_cancelTitle;
    UIEdgeInsets _insets;
    UITextField *_searchField;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _setUpView];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self _setUpView];
    }
    return self;
}

- (void)_setUpView {
    // 设置搜索图标
//    [self setImage: [UIImage imageNamed:@"search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    // iOS11版本以后 高度限制为44
    if (IOS11_ORLATER) {
        [self.heightAnchor constraintEqualToConstant:38.0].active = YES;
        self.searchTextPositionAdjustment = (UIOffset){10, 0}; // 光标偏移量
    }
    // 设置边距
    CGFloat top = 3;
    CGFloat bottom = top;
    CGFloat left = 12;
    CGFloat right = left;
    _insets = UIEdgeInsetsMake(top, left, bottom, right);
}

- (void)_hookSearchBar {
    // 遍历子视图，获取输入UITextFiled
    if (!_searchField) {
        NSArray *subviewArr = self.subviews;
        for(int i = 0; i < subviewArr.count ; i++) {
            UIView *viewSub = [subviewArr objectAtIndex:i];
            NSArray *arrSub = viewSub.subviews;
            for (int j = 0; j < arrSub.count ; j ++) {
                id tempId = [arrSub objectAtIndex:j];
                if([tempId isKindOfClass:[UITextField class]]) {
                    _searchField = (UITextField *)tempId;
                }
            }
        }
    }
    
    if (_searchField) {
        //自定义UISearchBar
        UITextField *searchField = _searchField;
        if (IOS11_ORLATER) {
            // iOS11版本以后进行适配
            CGRect frame = searchField.frame;
            CGFloat offsetX = frame.origin.x - _insets.left;
            CGFloat offsetY = frame.origin.y - _insets.top;
            frame.origin.x = _insets.left;
            frame.origin.y = _insets.top;
            frame.size.height += offsetY * 2;
            frame.size.width += offsetX * 2;
            searchField.frame = frame;
        }
        // 自定义样式
        searchField.placeholder = @"请输入订单号";
        searchField.font = [UIFont systemFontOfSize:16];
        searchField.backgroundColor = [UIColor whiteColor];
        [searchField setBorderStyle:UITextBorderStyleNone];
        [searchField setTextAlignment:NSTextAlignmentLeft];
        [searchField setTextColor:[UIColor grayColor]];
        // 设置圆角
        searchField.layer.masksToBounds = YES;
        searchField.layer.cornerRadius = 5.0f;
        // 设置placeholder是否居中显示
        SEL centerSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"setCenter", @"Placeholder:"]);
        if ([self respondsToSelector:centerSelector]) {
            BOOL hasCentredPlaceholder = NO;
            NSMethodSignature *signature = [[UISearchBar class] instanceMethodSignatureForSelector:centerSelector];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self];
            [invocation setSelector:centerSelector];
            [invocation setArgument:&hasCentredPlaceholder atIndex:2];
            [invocation invoke];
        }
    }
}
#pragma mark - Layout
-(void) layoutSubviews {
    [super layoutSubviews];
    [self _hookSearchBar];
}


@end
