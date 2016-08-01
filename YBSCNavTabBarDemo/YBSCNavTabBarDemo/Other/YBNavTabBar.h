//
//  YBNavTabBar.h
//  YBSCNavTabBarDemo
//
//  Created by clx on 16/7/29.
//  Copyright © 2016年 clx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YBNavBarDelegate <NSObject>

@required
/**
 *  When NavTabBar Item Is Pressed Call Back
 *
 *  @param index - pressed item's index
 */
- (void)itemDidSelectedWithIndex:(NSInteger)index;

@end

@interface YBNavTabBar : UIView

@property (nonatomic, weak)     id              <YBNavBarDelegate>delegate;

@property (nonatomic, assign)   NSInteger      currentItemIndex;
@property (nonatomic, strong)   NSArray        *itemTitles;

@property (nonatomic, strong)   UIColor        *lineColor;
@property (nonatomic, strong)   UIImage        *arrowImage;

@property (nonatomic, assign)   BOOL           showTitleSplitLine;
@property (nonatomic, strong)   UIColor        *titleSplitLineColor;


/**
*    是否固定宽度
*/
@property (nonatomic, assign) BOOL isFixWidth;

/**
*    是否固定宽度
*/
@property (nonatomic, assign) CGFloat fixWidth;

/**
*  字体颜色
*/
@property (nonatomic, strong) UIColor *titleColor;

/**
*  选中字体颜色
*/
@property (nonatomic, strong) UIColor *selectedFontColor;
/**
 *  字体
 */
@property (nonatomic, strong) UIFont *titleFont;
/**
 *  Initialize Methods
 *  
 *  @param frame - YBNavTabBar frame
 *  @param show  - is show Arrow Button
 *  
 *  @return Instance
 */
- (id)initWithFrame:(CGRect)frame showArrowButton:(BOOL)show;

/**
 *  update Item Data
 */
- (void)updateData;
@end
