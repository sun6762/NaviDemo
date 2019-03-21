//
//  SSMainVC.m
//  NaviDemo
//
//  Created by sun on 2019/3/21.
//  Copyright © 2019年 sunny. All rights reserved.
//

#import "SSMainVC.h"
#import "SSSetVC.h"
#import "SSChangeTitleVC.h"

@interface SSMainVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tbView;

@property (nonatomic, strong)NSArray *dataArr;

@end

@implementation SSMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

- (void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArr = @[@"可拉伸banner", @"可变更self.title"];
    self.title = @"Main";
    self.tbView.frame = self.view.frame;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            SSSetVC *vc = [SSSetVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            SSChangeTitleVC *vc = [SSChangeTitleVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ss"];
    cell.textLabel.text = _dataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableView *)tbView{
    if (!_tbView) {
        _tbView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tbView.delegate = self;
        _tbView.dataSource = self;
        [self.view addSubview:_tbView];
        [_tbView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ss"];
    }
    return _tbView;
}


@end
