//
//  ViewController.m
//  XBYPlayer
//
//  Created by xby023 on 2018/11/9.
//  Copyright © 2018年 com.BToken. All rights reserved.
//

#import "ViewController.h"
#import "XBYPlayer.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) XBYPlayer *player;

@property (nonatomic ,strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"播放器";
    
//    @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
//    @"http://vfx.mtime.cn/Video/2017/03/31/mp4/170331093811717750.mp4"
    
    XBYPlayer *player = [[XBYPlayer alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.width / 16 * 9)];
    player.videoUrl = @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:player];
    
    
}

#pragma mark ==================================== tableView ===================================

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.view.frame.size.width / 16 * 9;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

#pragma mark ====================================getter===================================

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource  = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = YES;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
