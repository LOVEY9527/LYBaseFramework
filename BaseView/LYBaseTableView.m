//
//  LYBaseTableView.m
//  LYBannerTest
//
//  Created by 李勇 on 2017/10/30.
//  Copyright © 2017年 李勇. All rights reserved.
//

#import "LYBaseTableView.h"

static NSString * kLYTVTableViewCellReUseId = @"kLYTVTableViewCellReUseId";
static CGFloat kLYBTVUpdateTableHeaderContentDuring = 0.25;

@interface LYBaseTableView()

//列表类型
@property (assign, readwrite, nonatomic) UITableViewStyle tableViewStyle;
//pushBlock
@property (copy, readwrite, nonatomic) BaseTableViewPushBlock pushBlock;

//列表头视图
@property (strong, readwrite, nonatomic) UIView *tableViewHeaderView;
@property (strong, readwrite, nonatomic) UIView *tableViewHeaderContentView;
//列表
@property (strong, readwrite,  nonatomic) UITableView *tableView;

//记录开始滑动的位置
@property (assign, nonatomic) CGFloat startPointY;

@end

@implementation LYBaseTableView

/**
 初始化接口
 
 @param frame 尺寸和位置
 @param tableViewStyle 列表类型
 @param pushBlock pushBlock
 @return 初始化完的对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                        Style:(UITableViewStyle)tableViewStyle
                    pushBlock:(BaseTableViewPushBlock)pushBlock
{
    if (self = [super initWithFrame:frame])
    {
        self.tableViewStyle = tableViewStyle;
        self.pushBlock = pushBlock;
        
        [self initDataSource];
        [self initView];
    }
    
    return self;
}

#pragma mark - property

- (UIView *)tableViewHeaderView
{
    if (!_tableViewHeaderView)
    {
        _tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableViewHeaderView.backgroundColor = [UIColor whiteColor];
    }
    
    return _tableViewHeaderView;
}

- (void)setScrollToTop:(BOOL)scrollToTop
{
    if (scrollToTop != self.tableView.scrollsToTop)
    {
        self.tableView.scrollsToTop = scrollToTop;
    }
}

#pragma mark - func

/**
 初始化数据源
 */
- (void)initDataSource
{
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
}

/**
 初始化视图
 */
- (void)initView
{
    //列表
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:self.tableViewStyle];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self registerCell];    
    self.tableView.tableHeaderView = self.tableViewHeaderView;
    self.tableView.tableFooterView = [self customTableFooterView];
    [self addSubview:self.tableView];
    [self customAdditionalView];
    
    //添加约束
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.tableViewHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView);
        make.leading.trailing.equalTo(self);
    }];
    self.tableViewHeaderContentView = [self customTableHeaderContentView];
    [self updateTableHeaderViewWithAnimated:NO];
}

/**
 注册单元格
 */
- (void)registerCell
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kLYTVTableViewCellReUseId];
}

/**
 自定义下拉刷新和加载更多视图
 */
- (void)customAdditionalView
{
    
}

/**
 自定义列表头视图的内容(在该方法中需要把内容视图添加到tableViewHeaderView，并且为内容视图添加约束并返回,
 不需要为tableViewHeaderView添加约束，不需要调用updateTableHeaderView)
 @return 头视图内容视图
 */
- (UIView *)customTableHeaderContentView
{
    return nil;
}

/**
 更新列表头视图(除了在方法customTableHeaderContentView之外更新头视图的时候都需要手动调用该方法)
 
 @param animated 是否动画
 */
- (void)updateTableHeaderViewWithAnimated:(BOOL)animated
{
    [self.tableViewHeaderView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.tableViewHeaderContentView)
        {
            make.height.equalTo(self.tableViewHeaderContentView);
        }else{
            make.height.mas_equalTo(0);
        }
    }];
    
    if (animated)
    {
        [UIView animateWithDuration:kLYBTVUpdateTableHeaderContentDuring
                         animations:^{
                             [self.tableView layoutIfNeeded];
                         }];
    }else{
        [self.tableView layoutIfNeeded];
    }
    self.tableView.tableHeaderView = self.tableViewHeaderView;
//    if (animated)
//    {
//        [self.tableView beginUpdates];
//        self.tableView.tableHeaderView = self.tableViewHeaderView;
//        [self.tableView endUpdates];
//    }else{
//        self.tableView.tableHeaderView = self.tableViewHeaderView;
//    }
}

- (UIView *)customTableFooterView
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.startPointY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self.delegate respondsToSelector:@selector(tableView:scrollDirection:)])
    {
        ScrollDirection scrollViewDirection;
        if (scrollView.contentOffset.y > self.startPointY)
        {
            scrollViewDirection = ScrollDirectionDown;
        }else{
            scrollViewDirection = ScrollDirectionUp;
        }
        
        [self.delegate tableView:self scrollDirection:scrollViewDirection];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLYTVTableViewCellReUseId
                                                            forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld-%ld", indexPath.section, indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

@end
