//
//  SSSetVC.m
//  SunnyCalendar
//
//  Created by sun on 2019/3/21.
//  Copyright © 2019年 sunny. All rights reserved.
//

#import "SSSetVC.h"
#import "UINavigationBar+SSAlphaView.h"
#import "SSImageView.h"

// bannerView 的高度
static const CGFloat BannerViewH = 200;

@interface SSSetVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tbView;

@property (nonatomic, weak)SSImageView *imgView;

@end

@implementation SSSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

- (void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    // tableView 不随导航栏偏移
    if (@available(iOS 11.0, *)) {
        self.tbView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    // 去除导航栏底部实线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar overRideSetBackgroundColor:[UIColor clearColor]];
    
    self.tbView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
}

# pragma
# pragma mark - scrollView delegate -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"%.2f",scrollView.contentOffset.y);
    CGFloat offsetY = scrollView.contentOffset.y;
    UIColor *color = [UIColor colorWithRed:6/225.0 green:173/255.0 blue:114/225.0 alpha:1];
    if (offsetY < 0) {
        CGFloat topViewHeight = kScreenW;
        //拉伸后图片总高度
        CGFloat totalHeight = topViewHeight - offsetY;
        //图片放大比例
        CGFloat scale = totalHeight / topViewHeight;
        self.imgView.frame = CGRectMake(-(kScreenW*scale - kScreenW)/2, offsetY, kScreenW * scale, totalHeight);
//        self.imgView.transform = CGAffineTransformMakeScale(scale, scale); // 这种放大,会遮盖下面的 cell
    }
    
    if (offsetY > 0) {
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        [self.navigationController.navigationBar overRideSetBackgroundColor:[color colorWithAlphaComponent:offsetY/64.0]];
        self.title = @"hakunamatata";
    }else{
        [self.navigationController.navigationBar overRideSetBackgroundColor:[color colorWithAlphaComponent:0]];
        self.title = @"";
    }
}

# pragma
# pragma mark - UITableViewDelegate, UITableViewDataSource -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        SSImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SSImageCellID"];
        cell.imgView.originalImg = [UIImage imageNamed:@"erji"];
        cell.imgView.scrollView = tableView;
        self.imgView = cell.imgView;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ss"];
        cell.textLabel.text = @"name";
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return kScreenW;
    }else {
        return 44;
    }
}

- (UITableView *)tbView{
    if (!_tbView) {
        _tbView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tbView.delegate = self;
        _tbView.dataSource = self;
        [self.view addSubview:_tbView];
        [_tbView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ss"];
        [_tbView registerClass:[SSImageCell class] forCellReuseIdentifier:@"SSImageCellID"];
    }
    return _tbView;
}

@end

@implementation SSImageCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    SSImageView *imgView = [[SSImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW)];
    self.imgView = imgView;
    [self.contentView addSubview:imgView];
}

@end
