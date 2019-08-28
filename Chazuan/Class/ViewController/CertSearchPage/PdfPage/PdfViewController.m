//
//  PdfViewController.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "PdfViewController.h"
#import <WebKit/WebKit.h>
#import "PdfViewModel.h"

@interface PdfViewController ()

@property (nonatomic, readwrite, strong) PdfViewModel *viewModel;
@property (nonatomic, readwrite, strong) WKWebView* webView;
@property (nonatomic, readwrite, strong) UIProgressView *progressView;

@end

@implementation PdfViewController

@dynamic viewModel;

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setupSubviews];
    [self _setupSubviewsConstraint];
}

- (void)bindViewModel {
    [super bindViewModel];
    @weakify(self);
    [[RACObserve(self.viewModel, pdfUrl) ignore:nil] subscribeNext:^(NSString *pdfUrl) {
        @strongify(self);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:pdfUrl]];
        [self.webView loadRequest:request];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqual: @"estimatedProgress"] && object == self.webView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if(self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)_setupSubviews {
    WKWebView *webView = [[WKWebView alloc] init];
    webView.backgroundColor = UIColor.whiteColor;
    self.webView = webView;
    [self.view addSubview:webView];
    
    UIProgressView *progressView = [[UIProgressView alloc] init];
    self.progressView = progressView;
    [self.view addSubview:progressView];
    
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
}

- (void)_setupSubviewsConstraint {
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kNavHeight, 0, kBottomSpace, 0));
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kNavHeight);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(2);
    }];
}

@end
