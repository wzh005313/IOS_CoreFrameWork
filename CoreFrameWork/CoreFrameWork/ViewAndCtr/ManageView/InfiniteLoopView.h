//
//  InfiniteLoopView.h
//  YSCKit
//
//  Created by  YangShengchao on 14-7-16.
//  Copyright (c) 2014年 yangshengchao. All rights reserved.
//  FORMATED!
//

#import <UIKit/UIKit.h>
#import "SMPageControl.h"

#pragma mark - define blocks

/**
 *  返回页面的显示内容
 *
 *  @param pageIndex 第几页
 *
 *  @return UIView
 */
typedef UIView *(^PageViewAtIndex)(NSInteger pageIndex);
/**
 *  点击页面执行操作
 *
 *  @param pageIndex 第几页
 */
typedef void(^TapPageAtIndex)(NSInteger pageIndex, UIView *contentView);


typedef void(^PageDidChangedAtIndex)(NSInteger pageIndex);




/**
 *  无限循环view
 */
@interface InfiniteLoopView : UIView

@property (nonatomic, assign) NSInteger currentPageIndex;                   //当前页码
@property (nonatomic, assign) NSTimeInterval animationDuration;             //默认5秒
@property (nonatomic, assign) NSInteger totalPageCount;
@property (nonatomic, strong) SMPageControl *pageControl;
@property (nonatomic, copy) PageViewAtIndex pageViewAtIndex;
@property (nonatomic, copy) TapPageAtIndex tapPageAtIndex;
@property (nonatomic, copy) PageDidChangedAtIndex pageDidChanged;           //如果外边需要处理页面切换事件的话，就用该回调即可

- (void)reloadData;

@end
