//
//  YBNavTabBar.m
//  YBSCNavTabBarDemo
//
//  Created by clx on 16/7/29.
//  Copyright © 2016年 clx. All rights reserved.
//

#import "YBNavTabBar.h"
#import "Macro.h"


@interface YBNavTabBar ()
{
    UIScrollView     *_navgationTabbar;
    UIImageView      *_arrowButton;
    
    UIView           *_line;
    
    NSMutableArray   *_items;
    NSMutableArray   *_itemsWidth;
    BOOL             _showArrowButton;
    BOOL             _popItemMenu;
    
    NSInteger        _oldSelectedIndex;   //最后一次选中的tab选项索引
    
}

@end

@implementation YBNavTabBar

- (id)initWithFrame:(CGRect)frame showArrowButton:(BOOL)show
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _showArrowButton = show;
        [self initConfig];
    }
    return self;
}



- (void)initConfig
{
    _items = [@[] mutableCopy];
    [self viewConfig];
}

- (void)viewConfig
{
    CGFloat functionButtonX = _showArrowButton ? (SCREEN_WIDTH - ARROW_BUTTON_WIDTH) : SCREEN_WIDTH;
    if (_showArrowButton)
    {
        _arrowButton = [[UIImageView alloc] initWithFrame:CGRectMake(functionButtonX, DOT_COORDINATE, ARROW_BUTTON_WIDTH, ARROW_BUTTON_WIDTH)];
        _arrowButton.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _arrowButton.image = _arrowImage;
        _arrowButton.userInteractionEnabled = YES;
        [self addSubview:_arrowButton];
        [self viewShowShadow:_arrowButton shadowRadius:20.0f shadowOpacity:20.0f];
    }
    
    _navgationTabbar = [[UIScrollView alloc] initWithFrame:CGRectMake(DOT_COORDINATE, DOT_COORDINATE, functionButtonX, NAV_TAB_BAR_HEIGHT)];
    _navgationTabbar.showsHorizontalScrollIndicator = NO;
    [self addSubview:_navgationTabbar];
    
}

- (void)showLineWithButtonWidth:(CGFloat)width
{
    _line = [[UIView alloc] initWithFrame:CGRectMake(2.0f, NAVIGATION_BAR_HEIGHT - 3.0f,width - 4.0f, 3.0f)];
    _line.backgroundColor = _lineColor ? _lineColor : UIColorWithRGBA(20.0f, 80.0f, 200.0f, 0.7f);
    [_navgationTabbar addSubview:_line];
}

- (CGFloat)contentWidthAndAddNavTabBarItemsWithButtonsWidth:(NSArray *)widths
{
    CGFloat buttonX = DOT_COORDINATE;
    CGFloat splitLineWidth = 1,splitlineHeight = NAV_TAB_BAR_HEIGHT - 20;
    UIView *split;
    for (NSInteger index = 0; index < [_itemTitles count]; index++)
    {
        //分割线
        if (_showTitleSplitLine) {
            if(index > 0){
                buttonX += 7;
                split = [[UIView alloc] initWithFrame
                         :CGRectMake(buttonX, (NAV_TAB_BAR_HEIGHT - splitlineHeight) / 2, splitLineWidth, splitlineHeight)];
                split.backgroundColor = _titleSplitLineColor ? _titleSplitLineColor : UIColorWithRGBA(210,210,210,1);
                [_navgationTabbar addSubview:split];
                buttonX += 7 + splitLineWidth;
            }
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonX, DOT_COORDINATE, [widths[index] floatValue], NAV_TAB_BAR_HEIGHT);
        [button setTitle:_itemTitles[index] forState:UIControlStateNormal];
        if(!self.titleColor){
            self.titleColor = [UIColor blackColor];
        }
        if (!self.selectedFontColor) {
            self.selectedFontColor = self.titleColor;
        }
        [button.titleLabel setFont:self.titleFont];
        [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_navgationTabbar addSubview:button];
        
        [_items addObject:button];
        buttonX += [widths[index] floatValue];
    }
    
    [self showLineWithButtonWidth:[widths[0] floatValue]];
    return buttonX;
}

- (void)itemPressed:(UIButton *)button
{
    
    NSInteger index = [_items indexOfObject:button];
    [_delegate itemDidSelectedWithIndex:index];
}

- (void)viewShowShadow:(UIView *)view shadowRadius:(CGFloat)shadowRadius shadowOpacity:(CGFloat)shadowOpacity
{
    view.layer.shadowRadius = shadowRadius;
    view.layer.shadowOpacity = shadowOpacity;
}

- (void)setCurrentItemIndex:(NSInteger)currentItemIndex
{
    CGFloat flag = _showArrowButton ? (SCREEN_WIDTH - ARROW_BUTTON_WIDTH) : SCREEN_WIDTH;
    UIButton *oldButton = _items[_currentItemIndex];
    [oldButton setTitleColor:self.titleColor forState:UIControlStateNormal];
    _currentItemIndex = currentItemIndex;
    UIButton *button = _items[currentItemIndex];
    //改变选中按钮的颜色
    [button setTitleColor:self.selectedFontColor forState:UIControlStateNormal];
    
    if (button.frame.origin.x + button.frame.size.width > flag) {
        CGFloat offsetX = button.frame.origin.x + button.frame.size.width - flag;
        if (_currentItemIndex < [_itemTitles count] - 1) {
            offsetX = offsetX + 40.0f;
        }
        [_navgationTabbar setContentOffset:CGPointMake(offsetX, DOT_COORDINATE) animated:YES];
    }
    else
    {
        [_navgationTabbar setContentOffset:CGPointMake(DOT_COORDINATE, DOT_COORDINATE)];
    }
    [UIView animateWithDuration:0.2f animations:^{
        _line.frame = CGRectMake(button.frame.origin.x + 2.0f, _line.frame.origin.y, [_itemsWidth[currentItemIndex] floatValue] - 4.0f, _line.frame.size.height);
    }];
}

- (NSArray *)getButtonWidthWithTitles:(NSArray *)titles
{
    NSMutableArray *widths = [@[] mutableCopy];
    CGSize size;
    if (!self.titleFont) {
        self.titleFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    for (NSString *title in titles) {
        if (self.isFixWidth) {
            NSNumber *width = [NSNumber numberWithFloat:self.fixWidth];
            [widths addObject:width];
        }
        else{
            NSDictionary *arrtribute = @{NSFontAttributeName:self.titleFont};
            size = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:arrtribute context:nil].size;
            NSNumber *width  = [NSNumber numberWithFloat:size.width + 40.f];
            [widths addObject:width];
        }
    }
    return widths;
}


- (void)updateData
{
    _arrowButton.backgroundColor = self.backgroundColor;
    
    _itemsWidth = (NSMutableArray *)[self getButtonWidthWithTitles:_itemTitles];
    if (_itemTitles.count) {
        CGFloat contentWidth = [self contentWidthAndAddNavTabBarItemsWithButtonsWidth:_itemsWidth];
        _navgationTabbar.contentSize = CGSizeMake(contentWidth, DOT_COORDINATE);
    }
    
    //选中颜色该表
    _oldSelectedIndex = _currentItemIndex;
    UIButton *button = _items[_currentItemIndex];
    [button setTitleColor:self.selectedFontColor forState:UIControlStateNormal];
}


@end
