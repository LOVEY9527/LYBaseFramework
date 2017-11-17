//
//  ViewController.m
//  LYBaseFramework
//
//  Created by 李勇 on 2017/11/17.
//  Copyright © 2017年 李勇. All rights reserved.
//

#import "ViewController.h"
#import "LYBaseTableView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    LYBaseTableView *tableView =  [[LYBaseTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                                                                                    self.view.frame.size.height)
                                                                   Style:UITableViewStylePlain
                                                               pushBlock:^(UIViewController *goalViewController, BOOL needLogin, BOOL   needCustomReturnBlock) {
                                     
                                                               }];
    tableView.dataSource = [NSMutableArray arrayWithArray:@[@"123", @"345"]];
    [self.view addSubview:tableView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
