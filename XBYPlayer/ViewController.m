//
//  ViewController.m
//  XBYPlayer
//
//  Created by xby023 on 2018/11/9.
//  Copyright © 2018年 com.BToken. All rights reserved.
//

#import "ViewController.h"
#import "XBYPlayer.h"
#import <MJExtension/MJExtension.h>
#import "ListModel.h"
#import "ListCell.h"

#define ScreenHeight  [[UIScreen mainScreen] bounds].size.height

#define ScreenWidth   [[UIScreen mainScreen] bounds].size.width

#define NavHeight     ([[UIApplication sharedApplication] statusBarFrame].size.height + 44)

#define NAVIBAR_Space (NavHeight - 64.f)

#define TabbarHeight  ([[UIApplication sharedApplication] statusBarFrame].size.height == 44 ? 83.f : 49.f)
#define TabBar_Space  (TabbarHeight - 49.f)


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) XBYPlayer *player;

@property (nonatomic ,strong) NSMutableArray *dataArray;

@end

@implementation ViewController

//    @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
//    @"http://vfx.mtime.cn/Video/2017/03/31/mp4/170331093811717750.mp4"

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeUserInterface];
    [self initializeDataSource];
}

- (void)initializeDataSource{
     NSString *path = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"json"];
     NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingAllowFragments error:nil];
     self.dataArray = [ListModel mj_objectArrayWithKeyValuesArray:dic[@"data"][@"videos"]];
     [self.tableView reloadData];
}

- (void)initializeUserInterface{
    self.title = @"Video Player";
    XBYPlayer *player = [[XBYPlayer alloc]initWithFrame:CGRectMake(0,0,ScreenWidth, ScreenWidth / 16 * 9)];
    self.player = player;
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:player];
    
    self.player.hidden = YES;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //控制播放器
    CGRect rect = [self.player convertRect:self.player.bounds toView:self.view];
    if (rect.origin.y <= (NavHeight - (ScreenWidth / 16 * 9 + 1))) {
        self.player.hidden = YES;
        [self.player pauseVideo];
    }else if (rect.origin.y > (NavHeight - (ScreenWidth / 16 * 9 + 1)) && rect.origin.y < NavHeight) {
        
    }else if(rect.origin.y >= NavHeight && rect.origin.y <= (ScreenHeight - (ScreenWidth / 16 * 9 + 1))){
        
    }else if(rect.origin.y > (ScreenHeight - (ScreenWidth / 16 * 9 + 1)) && rect.origin.y <= ScreenHeight){
        
    }else{
        [self.player pauseVideo];
        self.player.hidden = YES;
    }
    
    //视差效果
    NSArray <ListCell *>*cells = [self.tableView visibleCells];
    for (NSInteger index = 0; index < cells.count ; index ++) {
        ListCell *cell = cells[index];
        [cell imageContentOffY];
    }
}

#pragma mark ==================================== tableView ===================================

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ListModel *model = self.dataArray[indexPath.row];
    cell.listModel = model;
    cell.playBlock = ^(CGRect rect) {
        self.player.hidden = NO;
        self.player.frame = CGRectMake(0,rect.origin.y,ScreenWidth, ScreenWidth / 16 * 9);
        ListStreamsModel *smodel = model.streams.lastObject;
        self.player.videoUrl = smodel.url;
    };
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ScreenWidth / 16 * 9 + 1;
    
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
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ListCell class]) bundle:nil] forCellReuseIdentifier:@"ListCell"];
    }
    return _tableView;
    
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
