//
//  BaseViewController.h
//  YSCKit
//
//  Created by  YangShengchao on 14-2-13.
//  Copyright (c) 2014年  YangShengchao. All rights reserved.
//  FORMATED!
//

#import <UIKit/UIKit.h>
//静态类


//自定义view
#import "TitleBarView.h"

//第三方库
//#import "UIViewController+ScrollingNavbar.h"


@interface BaseViewController : UIViewController <UITextFieldDelegate>

#pragma mark - 视图切换
@property (nonatomic, strong) NSDictionary *params; //显示该视图控制器的时候传入的参数

@property (nonatomic, strong) TitleBarView *titleBarView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, assign) BackType backType;    //返回类型（是上一级还是侧边栏）默认是pop上一级
@property (nonatomic, assign) BOOL isAppeared;      //当前viewcontroller是否显示
@property (nonatomic, assign) BOOL isSetupConstraints;          //是否已经设置过约束了
@property (nonatomic, assign) BOOL isRunViewDidLoadExtension;   //扩展viewDidLoad方法，只执行一次，但由于与UI size相关，放在了viewDidAppear中调用，因此需要一个bool值来控制

#pragma mark - 这里可以获取相对布局的view大小，在viewDidAppear中调用
- (void)viewDidiLoadExtension;

#pragma mark - constraints
- (void)setupConstraints;

#pragma mark - push & pop & dismiss view controller
- (UIViewController *)pushViewController:(NSString *)className;
- (UIViewController *)pushViewController:(NSString *)className withParams:(NSDictionary *)paramDict;
- (UIViewController *)pushViewController:(NSString *)className withParams:(NSDictionary *)paramDict animated:(BOOL)animated;
//返回上一级，最多到根
- (UIViewController *)popViewController;
//返回上一级，直到dismiss
- (UIViewController *)backViewController;
//返回到根
- (UIViewController *)popToRootViewController;

-(void)backSecondView;

#pragma mark - present & dismiss viewcontroller [presentingViewController -> self -> presentedViewController]
- (UIViewController *)presentViewController:(NSString *)className;
- (UIViewController *)presentViewController:(NSString *)className withParams:(NSDictionary *)paramDict;
//在self上一级viewController调用dismiss（通常情况下使用该方法）
- (void)dismissOnPresentingViewController;
//在self下一级viewController调用dismiss
- (void)dismissOnPresentedViewController;


#pragma mark - scrollingNavbar
- (UIView *)scrollableView;

#pragma mark - push & pop with animation
//- (UIViewController *)pushViewController:(NSString *)className withParams:(NSDictionary *)paramDict withAnimation:(ADTransition *)transition;

#pragma mark -  show & hide HUD
- (MBProgressHUD *)showHUDLoading:(NSString *)hintString;
- (MBProgressHUD *)showHUDLoadingOnWindow:(NSString *)hintString;
- (MBProgressHUD *)showHUDLoading:(NSString *)hintString onView:(UIView *)view;

- (void)hideHUDLoading;
- (void)hideHUDLoadingOnWindow;
- (void)hideHUDLoadingOnView:(UIView *)view;

- (void)showResultThenHide:(NSString *)resultString;
- (void)showResultThenHideOnWindow:(NSString *)resultString;
- (void)showResultThenPop:(NSString *)resultString;
- (void)showResultThenPopOnWindow:(NSString *)resultString;
- (void)showResultThenBack:(NSString *)resultString;
- (void)showResultThenBackOnWindow:(NSString *)resultString;
- (void)showResultThenDismiss:(NSString *)resultString;
- (void)showResultThenDismissOnWindow:(NSString *)resultString;
- (void)showResultThenHide:(NSString *)resultString afterDelay:(NSTimeInterval)delay onView:(UIView *)view;


#pragma mark - alert view
- (UIAlertView *)showAlertVieWithMessage:(NSString *)message;
- (UIAlertView *)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message;


#pragma mark - Overridden methods 缓存相关
//- (NSString *)cacheFilePath;
//- (NSString *)cacheFilePath:(NSString *)suffix;
- (id)cachedObjectForKey:(NSString *)cachedKey;
- (id)cachedObjectForKey:(NSString *)cachedKey withSuffix:(NSString *)suffix;
- (void)saveObject:(id)object forKey:(NSString *)cachedKey;
- (void)saveObject:(id)object forKey:(NSString *)cachedKey withSuffix:(NSString *)suffix;
- (NSMutableArray *)commonLoadCaches:(NSString *)cacheKey;


#pragma mark - Overridden methods 业务相关
- (NSArray *)customBarButtonOnNavigationBar:(UIView *)customButton withFixedSpaceWidth:(NSInteger)width;
- (IBAction)backButtonClicked:(id)sender;
- (IBAction)popButtonClicked:(id)sender;
- (IBAction)leftSlideButtonClicked:(id)sender;
- (BOOL)showCustomTitleBarView;
- (void)hideKeyboard;
- (BOOL)willCareKeyboard;
- (void)willLayoutForKeyboardHeight:(CGFloat)keyboardHeight;
- (void)layoutForKeyboardHeight:(CGFloat)keyboardHeight;
- (void)didLayoutForKeyboardHeight:(CGFloat)keyboardHeight;
- (void)networkReachablityChanged:(BOOL)reachable;

@end
