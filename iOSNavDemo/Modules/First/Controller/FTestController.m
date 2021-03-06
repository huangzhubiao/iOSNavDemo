//
//  FTestController.m
//  iOSNavDemo
//
//  Created by zijinsuo_hgc on 2017/12/4.
//  Copyright © 2017年 Curtis. All rights reserved.
//

#import "FTestController.h"

#define Height_Header SCREEN_Width * 910 / 1200.0

@interface FTestController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

/**
 标记当前页面滑动偏移量
 */
@property (nonatomic, assign) CGFloat contentOffSet_Y;

@end

@implementation FTestController

#pragma mark -lazy load
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kVCViewColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(StatusBarHeight, 0, 0, 0);
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_Width, Height_Header)];
        _tableView.tableHeaderView = headView;
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_Width, Height_Header)];
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.image = IMAGE(@"header");
        img.tag = 2017;
        [headView addSubview:img];
        
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self changeNavBarAlpha:self.contentOffSet_Y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    
    ///初始化
    self.contentOffSet_Y = 0;
    
}

#pragma mark -setupUI
- (void)setupUI
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.trailing.equalTo(@0);
        make.top.equalTo(self.mas_topLayoutGuideBottom).mas_offset(-kNavBarHeight);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld--%02zd", indexPath.section, indexPath.row];
    
    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"---click cell: %@", indexPath);
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    ///允许下拉 头视图拉伸效果
    CGFloat yOffset = scrollView.contentOffset.y;
    if (yOffset < 0) {//下拉
        
        //取出图片视图
        UIImageView *imgView = (UIImageView *)[self.tableView.tableHeaderView viewWithTag:2017];
        
        imgView.frame = CGRectMake(0, yOffset, SCREEN_Width, Height_Header - yOffset);
    }
    NSLog(@"contentOffset.y: %f", scrollView.contentOffset.y);
    self.contentOffSet_Y = scrollView.contentOffset.y;
    [self changeNavBarAlpha:self.contentOffSet_Y];
    
}

#pragma mark -滑动导航渐变
- (void)changeNavBarAlpha:(CGFloat)yOffset
{
    CGFloat currentAlpha = (yOffset - (-0))/(Height_Header/2.0 - (-0));
    currentAlpha = currentAlpha <= 0.0 ? 0.0 : (currentAlpha >= 1.0 ? 1.0 : currentAlpha);
    NSLog(@"---%f", currentAlpha);
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:kNavBarColorString alpha:currentAlpha]] forBarMetrics:UIBarMetricsDefault];
    
    if (yOffset > Height_Header/2.0) {
        self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
        
        [self.backButton setImage:IMAGE(@"navLeft_gray") forState:UIControlStateNormal];
        [self.backButton setImage:IMAGE(@"navLeft_gray") forState:UIControlStateHighlighted];
        
        //设置导航栏title属性
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:[UIColor blackColor]}];
        self.title = @"FTest";
    } else {
        self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
        
        [self.backButton setImage:IMAGE(@"navLeft") forState:UIControlStateNormal];
        [self.backButton setImage:IMAGE(@"navLeft") forState:UIControlStateHighlighted];
        
        //设置导航栏title属性
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]}];
        self.title = @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
