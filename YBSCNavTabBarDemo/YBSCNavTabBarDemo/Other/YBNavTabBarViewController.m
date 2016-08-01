//
//  YBNavTabBarControllerViewController.m
//  YBSCNavTabBarDemo
//
//  Created by clx on 16/8/1.
//  Copyright © 2016年 clx. All rights reserved.
//

#import "YBNavTabBarViewController.h"
#import "YBNavTabBarLazyLoadDelegate.h"
#import "YBNavTabBar.h"
#import "Macro.h"
//#import "SCNavTabBarLazyLoadDelegate.h"

@interface YBNavTabBarViewController () <UIScrollViewDelegate,YBNavTabBarLazyLoadDelegate,YBNavBarDelegate>
{
    NSInteger       _currentIndex;              // current page index
    NSMutableArray  *_titles;                   // array of children view controller's title
    
    YBNavTabBar     *_navTabBar;                // NavTabBar: press item on it to exchange view
    UIScrollView    *_mainView;                 // content view
}

@end

@implementation YBNavTabBarViewController


- (id)initWithShowArrowButton:(BOOL)show
{
    self = [super init];
    if (self)
    {
        _showArrowButton = show;
    }
    return self;
}

- (id)initWithSubViewControllers:(NSArray *)subViewControllers
{
    self = [super init];
    if (self)
    {
        _subViewControllers = subViewControllers;
    }
    return self;
}

- (id)initWithParentViewController:(UIViewController *)viewController
{
    self = [super init];
    if (self)
    {
        [self addParentController:viewController];
    }
    return self;
}

- (id)initWithSubViewControllers:(NSArray *)subControllers andParentViewController:(UIViewController *)viewController showArrowButton:(BOOL)show;
{
    self = [self initWithSubViewControllers:subControllers];
    
    _showArrowButton = show;
    [self addParentController:viewController];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initConfig];
    [self viewConfig];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
#pragma mark -
- (void)initConfig
{
    // Iinitialize value
    _currentIndex = 1;
    _navTabBarColor = _navTabBarColor ? _navTabBarColor : NavTabbarColor;
    
    // Load all title of children view controllers
    _titles = [[NSMutableArray alloc] initWithCapacity:_subViewControllers.count];
    for (UIViewController *viewController in _subViewControllers)
    {
        [_titles addObject:viewController.title];
    }
}

- (void)viewInit
{
    // Load NavTabBar and content view to show on window
    _navTabBar = [[YBNavTabBar alloc] initWithFrame:CGRectMake(DOT_COORDINATE, DOT_COORDINATE, SCREEN_WIDTH, NAV_TAB_BAR_HEIGHT) showArrowButton:_showArrowButton];
    _navTabBar.delegate = self;
    _navTabBar.backgroundColor = _navTabBarColor;
    _navTabBar.lineColor = _navTabBarLineColor;
    _navTabBar.itemTitles = _titles;
    _navTabBar.arrowImage = _navTabBarArrowImage;
    _navTabBar.titleSplitLineColor = _titleSplitLineColor;
    _navTabBar.showTitleSplitLine = _showTitleSplitLine;
    _navTabBar.isFixWidth = _isTabBarFixWidth;
    _navTabBar.fixWidth = _fixTabBarWidth;
    _navTabBar.titleColor = _navTabBarFontColor;
    _navTabBar.selectedFontColor = _navTabBarSelectedFontColor;
    _navTabBar.titleFont = _titleFont;
    
    [_navTabBar updateData];
    
    CGFloat height = _navTabBar.frame.origin.y + _navTabBar.frame.size.height;
    //水平分割线
    if(_showContentHorizontalLine){
        UIView * hLine = [[UIView alloc] initWithFrame:CGRectMake(DOT_COORDINATE, height, SCREEN_WIDTH, 1)];
        hLine.backgroundColor = _contentHLineColor ? _contentHLineColor : UIColorWithRGBA(210,210,210,1);
        [self.view addSubview:hLine];
        height += 1;
    }
    
    _mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(DOT_COORDINATE, height, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - height)];
    _mainView.delegate = self;
    _mainView.pagingEnabled = YES;
    _mainView.bounces = _mainViewBouces;
    _mainView.showsHorizontalScrollIndicator = NO;
    _mainView.contentSize = CGSizeMake(SCREEN_WIDTH * _subViewControllers.count, DOT_COORDINATE);
    [self.view addSubview:_mainView];
    [self.view addSubview:_navTabBar];
}

- (void)viewConfig
{
    [self viewInit];
    
    // Load children view controllers and add to content view
    [_subViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        
        UIViewController *viewController = (UIViewController *)_subViewControllers[idx];
        viewController.view.frame = CGRectMake(idx * SCREEN_WIDTH, DOT_COORDINATE, SCREEN_WIDTH, _mainView.frame.size.height);
        [_mainView addSubview:viewController.view];
        [self addChildViewController:viewController];
        //延迟加载默认第一页需加载数据
        if (_dataLazyLoad && idx == 0) {
            [self itemDidSelectedWithIndex:0];
        }
    }];
}

#pragma mark - Public Methods
#pragma mark -
- (void)setNavTabbarColor:(UIColor *)navTabbarColor
{
    // prevent set [UIColor clear], because this set can take error display
    CGFloat red, green, blue, alpha;
    if ([navTabbarColor getRed:&red green:&green blue:&blue alpha:&alpha] && !red && !green && !blue && !alpha)
    {
        navTabbarColor = NavTabbarColor;
    }
    _navTabBarColor = navTabbarColor;
}

- (void)addParentController:(UIViewController *)viewController
{
    // Close UIScrollView characteristic on IOS7 and later
    if ([viewController respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        viewController.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [viewController addChildViewController:self];
    [viewController.view addSubview:self.view];
}

#pragma mark - Scroll View Delegate Methods
#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _currentIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
    _navTabBar.currentItemIndex = _currentIndex;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _currentIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
    //_navTabBar.currentItemIndex = _currentIndex;
    if(_dataLazyLoad){
        [self itemDidSelectedWithIndex:_currentIndex];
    }
}

#pragma mark - SCNavTabBarDelegate Methods
#pragma mark -
- (void)itemDidSelectedWithIndex:(NSInteger)index
{
    [_mainView setContentOffset:CGPointMake(index * SCREEN_WIDTH, DOT_COORDINATE) animated:_scrollAnimation];
    if(_dataLazyLoad){
        //开启延迟加载功能
        UIViewController* currentVC = _subViewControllers[index];
        SEL selector = NSSelectorFromString(@"tabBarLazyLoadData:");
        if ([currentVC conformsToProtocol:@protocol(YBNavTabBarLazyLoadDelegate)]){
            // do something appropriate
            if ([currentVC respondsToSelector:selector]) {
                if ([currentVC respondsToSelector:selector]) {
                    IMP imp = [currentVC methodForSelector:selector];
                    void (*func)(id, SEL, NSNumber*) = (void *)imp;
                    func(currentVC, selector, [[NSNumber alloc] initWithInteger:index]);
                }
            }
        }
    }
}

- (void)tabBarLazyLoadData:(NSNumber *)index
{
}

@end
