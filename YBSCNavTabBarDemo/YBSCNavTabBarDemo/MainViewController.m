//
//  MainViewController.m
//  YBSCNavTabBarDemo
//
//  Created by clx on 16/7/29.
//  Copyright © 2016年 clx. All rights reserved.
//

#import "MainViewController.h"
#import "AViewController.h"
#import "BViewController.h"
#import "CViewController.h"
#import "DViewController.h"
#import "YBNavTabBarViewController.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"YYYYYY";
    YBNavTabBarViewController *_tab = [[YBNavTabBarViewController alloc] init];
    
    AViewController *_allOrderVc = [[AViewController alloc] init];
    _allOrderVc.title = @"A";
    
    BViewController *waitPayVc = [[BViewController alloc] init];
    waitPayVc.title = @"B";
    
    CViewController *waitSendVc = [[CViewController alloc]init];
    waitSendVc.title = @"C";
    
    DViewController *waitGoodVc = [[DViewController alloc] init];
    waitGoodVc.title = @"D";
    
    _tab.subViewControllers = @[
                                _allOrderVc,
                                waitPayVc,
                                waitSendVc,
                                waitGoodVc,
    ];
    _tab.showContentHorizontalLine = YES;
    _tab.showArrowButton = NO;
    _tab.scrollAnimation = YES;
    _tab.navTabBarColor = [UIColor whiteColor];
    _tab.navTabBarLineColor = [UIColor blueColor];
    _tab.navTabBarSelectedFontColor = [UIColor redColor];
    _tab.isTabBarFixWidth = YES;
    _tab.fixTabBarWidth = [UIScreen mainScreen].bounds.size.width/4;
    _tab.dataLazyLoad = YES;
    [_tab addParentController:self];
    [_tab itemDidSelectedWithIndex:1];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
