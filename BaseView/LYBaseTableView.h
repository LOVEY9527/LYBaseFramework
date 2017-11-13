//
//  LYBaseTableView.h
//  LYBannerTest
//
//  Created by 李勇 on 2017/10/30.
//  Copyright © 2017年 李勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

typedef void(^BaseTableViewPushBlock)(UIViewController *goalViewController, BOOL needLogin, BOOL needCustomReturnBlock);

@protocol LYBaseTableViewDelegate;

@interface LYBaseTableView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<LYBaseTableViewDelegate> delegate;

//列表类型
@property (assign, readonly, nonatomic) UITableViewStyle tableViewStyle;
//pushBlock
@property (copy, readonly, nonatomic) BaseTableViewPushBlock pushBlock;
//列表数据源
@property (strong, nonatomic) NSMutableArray *dataSource;

//列表头视图
@property (strong, readonly, nonatomic) UIView *tableViewHeaderView;
//列表
@property (strong, readonly, nonatomic) UITableView *tableView;

//点击状态栏返回顶部
@property (assign, nonatomic) BOOL scrollToTop;

/**
 初始化接口
 
 @param frame 尺寸和位置
 @param tableViewStyle 列表类型
 @param pushBlock pushBlock
 @return 初始化完的对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                        Style:(UITableViewStyle)tableViewStyle
                    pushBlock:(BaseTableViewPushBlock)pushBlock;

/**
 初始化数据源
 */
- (void)initDataSource;

/**
 初始化视图
 */
- (void)initView;

/**
 注册单元格
 (baseTableView里面使用了约束，如果在子类的initView中注册cell的话，注册操作会在table:numberForRowInSection:代理方法之后执行)
 */
- (void)registerCell;

/**
 自定义下拉刷新和加载更多视图
 */
- (void)customAdditionalView;

/**
 自定义列表头视图的内容(在该方法中需要把内容视图添加到tableViewHeaderView，并且为内容视图添加约束并返回,
 不需要为tableViewHeaderView添加约束，不需要调用updateTableHeaderView)
 @return 头视图内容视图
 */
- (UIView *)customTableHeaderContentView;

/**
 更新列表头视图(除了在方法customTableHeaderContentView之外更新头视图的时候都需要手动调用该方法)
 
 @param animated 是否动画
 */
- (void)updateTableHeaderViewWithAnimated:(BOOL)animated;

/**
 自定义列表尾视图(列表尾视图无法添加约束)

 @return 列表尾视图
 */
- (UIView *)customTableFooterView;

@end

@protocol LYBaseTableViewDelegate<NSObject>

- (void)tableView:(LYBaseTableView *)commodityHome
  scrollDirection:(ScrollDirection)scrollDirection;

@end
