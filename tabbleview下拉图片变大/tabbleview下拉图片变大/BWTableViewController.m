//
//  BWTableViewController.m
//  tabbleview下拉图片变大
//
//  Created by libowen on 16/4/12.
//  Copyright © 2016年 libowen. All rights reserved.
//
#define navigationBarHeight 64.f
#define imageHeight 200.0f
#define iconMargin 10
#define iconW 80
#define iconH 80
#import "BWTableViewController.h"

@interface BWTableViewController ()
@property (nonatomic, weak) UIImageView * topImgView;
@property (nonatomic, weak) UIImageView * iconView;
@end

@implementation BWTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置图片的内边距空出一个imageView的位置
    self.tableView.contentInset = UIEdgeInsetsMake(imageHeight, 0, 0, 0);
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    //把图片设置到对应位置上
    UIImageView *topImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -imageHeight, screenSize.width, imageHeight)];
    
    //MARK: 把加载的图片设置需要的大小
    UIImage *oldImage = [UIImage imageNamed:@"5"];
    topImgView.image = [self originImage:oldImage scaleToSize:CGSizeMake(screenSize.width, imageHeight)];

    
    // UIViewContentModeScaleAspectFill也会证图片比例不变，但是是填充整个ImageView的，可能只有部分图片显示出来。
    //这里是为了让图片宽度随着高度的拉伸而拉伸
    topImgView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.view addSubview:topImgView];
    self.topImgView = topImgView;
    
    
    UIImageView * iconView = [[UIImageView alloc]initWithFrame:CGRectMake(iconMargin, imageHeight - (iconMargin + iconH), iconW, iconH)];
    
    iconView.layer.cornerRadius = 7.5f;
    iconView.image = [UIImage imageNamed:@"01"];
    iconView.clipsToBounds = YES;
    //自动布局，自适应顶部
    iconView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.topImgView addSubview:iconView];
    self.iconView = iconView;
}



#pragma mark - 数据源

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"第%zd行",indexPath.row];
    cell.textLabel.text = @"测试数据,往下拉看效果...";
    
    return cell;
}

#pragma mark - 监听滚动(程序启动会调用2次，设置内边距会调用一次)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //因为有导航栏的关系，所以要获得移动的距离需要加上导航栏的高度
    CGFloat y = scrollView.contentOffset.y + navigationBarHeight;
    
    if (y < -imageHeight) {
        
        CGRect frame = self.topImgView.frame;
        //MARK: 核心代码
        frame.origin.y = y;
        frame.size.height = -y;
        
        self.topImgView.frame = frame;
        
    }
//    NSLog(@"%@",NSStringFromCGPoint(self.topImgView.frame.origin));
}
#pragma mark - 给图片设置尺寸
- (UIImage *)originImage:(UIImage *)image scaleToSize:(CGSize)size{
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage * scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaleImage;
}
@end
