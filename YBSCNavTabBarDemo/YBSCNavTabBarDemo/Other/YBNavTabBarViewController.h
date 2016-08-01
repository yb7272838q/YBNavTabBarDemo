//
//  YBNavTabBarControllerViewController.h
//  YBSCNavTabBarDemo
//
//  Created by clx on 16/8/1.
//  Copyright © 2016年 clx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YBNavTabBar;
@interface YBNavTabBarViewController : UIViewController

@property (nonatomic, assign)       BOOL       showArrowButton;           // Default value: YES
@property (nonatomic, assign)       BOOL       scrollAnimation;           // Default value: NO
@property (nonatomic, assign)       BOOL       mainViewBouces;            // Default value: NO
@property (nonatomic, assign)       BOOL       showContentHorizontalLine; // Default value: NO
@property (nonatomic, assign)       BOOL       showTitleSplitLine;        // Default value: NO
@property (nonatomic, assign)       BOOL       dataLazyLoad;              //是否开启延迟加载，用于动态加载数据 default value:NO


@property (nonatomic, strong)       NSArray    *subViewControllers;       //An array of children view controllers

@property (nonatomic, strong)       UIColor    *navTabBarColor;

@property (nonatomic, strong)       UIColor     *navTabBarLineColor;
@property (nonatomic, strong)       UIImage     *navTabBarArrowImage;
@property (nonatomic, strong)       UIColor     *contentHLineColor;
@property (nonatomic, strong)       UIColor     *titleSplitLineColor;
/**
 *  nav tab bar 字体颜色
 */
@property (nonatomic, strong)   UIColor     *navTabBarFontColor;
/**
 *  选中字体的颜色
 */
@property (nonatomic, strong)   UIColor     *navTabBarSelectedFontColor;

/**
 *  是否固定宽度
 */
@property (nonatomic, assign) BOOL isTabBarFixWidth;
/**
 *  固定宽度
 */
@property (nonatomic, assign) CGFloat fixTabBarWidth;
/**
 *  字体
 */
@property (nonatomic , strong) UIFont * titleFont;
/**
 *  Initialize Methods
 *
 *  @param show - is show the arrow button
 *
 *  @return Instance
 */
- (id)initWithShowArrowButton:(BOOL)show;

/**
 *  Initialize SCNavTabBarViewController Instance And Show Children View Controllers
 *
 *  @param subViewControllers - set an array of children view controllers
 *
 *  @return Instance
 */
- (id)initWithSubViewControllers:(NSArray *)subViewControllers;

/**
 *  Initialize SCNavTabBarViewController Instance And Show On The Parent View Controller
 *
 *  @param viewController - set parent view controller
 *
 *  @return Instance
 */
- (id)initWithParentViewController:(UIViewController *)viewController;

/**
 *  Initialize SCNavTabBarViewController Instance, Show On The Parent View Controller And Show On The Parent View Controller
 *
 *  @param subControllers - set an array of children view controllers
 *  @param viewController - set parent view controller
 *  @param show           - is show the arrow button
 *
 *  @return Instance
 */
- (id)initWithSubViewControllers:(NSArray *)subControllers andParentViewController:(UIViewController *)viewController showArrowButton:(BOOL)show;

/**
 *  Show On The Parent View Controller
 *
 *  @param viewController - set parent view controller
 */
- (void)addParentController:(UIViewController *)viewController;


- (void)itemDidSelectedWithIndex:(NSInteger)index;

@end
