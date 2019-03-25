//
//  SSChangeTitleVC.m
//  NaviDemo
//
//  Created by sun on 2019/3/21.
//  Copyright © 2019年 sunny. All rights reserved.
//

#import "SSChangeTitleVC.h"
#import "UINavigationBar+SSAlphaView.h"

static const CGFloat cellHeight = 44;

@interface SSChangeTitleVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tbView;

@end

@implementation SSChangeTitleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

- (void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"title";
    
    self.tbView.frame = self.view.frame;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tbView) {
        CGFloat offsetY = scrollView.contentOffset.y;
        NSLog(@"%.2f",offsetY);
        if (offsetY > cellHeight * 3 - Height_NavBar) {
            self.title = @"hakunamatata";
        }else{
            self.title = @"title";
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ss"];
    if (indexPath.row == 2) {
        cell.textLabel.text = @"hakunamatata";
    }else{
        cell.textLabel.text = @"name";
    }
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
