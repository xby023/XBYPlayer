//
//  XBYPlayer.m
//  XBYPlayer
//
//  Created by xby023 on 2018/11/12.
//  Copyright © 2018年 com.BToken. All rights reserved.
//

#import "XBYPlayer.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <Masonry.h>
//播放器默认宽
#define XBYPlayeWidth [UIScreen mainScreen].bounds.size.width
//播放器默认高
#define XBYPlayeHeight [UIScreen mainScreen].bounds.size.width / 16 * 9

#define XBYScreenHeight  [[UIScreen mainScreen] bounds].size.height

#define XBYScreenWidth   [[UIScreen mainScreen] bounds].size.width

#define XBYNavHeight     ([[UIApplication sharedApplication] statusBarFrame].size.height + 44)

#define XBYNAVIBAR_Space (XBYNavHeight - 64.f)

#define XBYTabbarHeight  ([[UIApplication sharedApplication] statusBarFrame].size.height == 44 ? 83.f : 49.f)
#define XBYTabBar_Space  (XBYTabbarHeight - 49.f)

@interface XBYPlayer()

@property (nonatomic ,assign) CGFloat playerWidth;

@property (nonatomic ,assign) CGFloat playerHeight;

@property (nonatomic ,assign) CGFloat playerOriginX;

@property (nonatomic ,assign) CGFloat playerOriginY;

@property (nonatomic ,strong) AVPlayer *player;

@property (nonatomic ,strong) AVPlayerItem *playerItem;

@property (nonatomic ,strong) AVPlayerLayer *playerLayer;

//控件

@property (nonatomic ,strong) UIView *bottonView;

//播放 暂停
@property (nonatomic ,strong) UIButton *playButton;

//全屏 非全屏
@property (nonatomic ,strong) UIButton *fullScreenButton;

//时间
@property (nonatomic ,strong) UILabel *timeLabel;

//播放进度
@property (nonatomic ,strong) UISlider *progressSliderView;

//缓存进度
@property (nonatomic ,strong) UISlider *cacheSliderView;

@property (nonatomic ,strong) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic ,strong) UIView *playSuperView;

@property (nonatomic ,strong) CAGradientLayer *gradientLayer;

@property (nonatomic ,assign) NSInteger countDown;

@end

@implementation XBYPlayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0,0, XBYPlayeWidth, XBYPlayeHeight);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (frame.size.width == 0.0 && frame.size.height == 0.0 ) {
            self.playerWidth  = XBYPlayeWidth;
            self.playerHeight = XBYPlayeHeight;
            self.playerOriginX = 0;
            self.playerOriginY = 0;
        }else{
            self.playerWidth  = frame.size.width;
            self.playerHeight = frame.size.height;
            self.playerOriginX = frame.origin.x;
            self.playerOriginY = frame.origin.y;
        }
        
        //添加控件
        [self initUserInterface];
        
    }
    return self;
}

- (void)initUserInterface{
    self.backgroundColor = [UIColor blackColor];
    
    
    //静音播放声音
    AVAudioSession *audioSession= [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    
    
    self.bottonView = [[UIView alloc]init];
    [self addSubview:self.bottonView];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, self.playerWidth, 50);
    gradientLayer.colors = @[(__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0.0].CGColor,(__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0.6].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.locations = @[@0.0, @1.0];
    [self.bottonView.layer insertSublayer:gradientLayer atIndex:0];
    self.gradientLayer = gradientLayer;
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playButton setImage:[UIImage imageNamed:@"xbystop"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"xbyplay"] forState:UIControlStateSelected];
    [self.playButton addTarget:self action:@selector(actionForPlayButton) forControlEvents:UIControlEventTouchUpInside];
    [self.bottonView addSubview:self.playButton];

    
    self.fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.fullScreenButton setImage:[UIImage imageNamed:@"xbyfullscreen"] forState:UIControlStateNormal];
    [self.fullScreenButton setImage:[UIImage imageNamed:@"xbysmallscreen"] forState:UIControlStateSelected];
    [self.fullScreenButton addTarget:self action:@selector(actionForfullScreenButton) forControlEvents:UIControlEventTouchUpInside];
    [self.bottonView addSubview:self.fullScreenButton];
    
    
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.text = @"00:00/00:00";
    [self.bottonView addSubview:self.timeLabel];
    
    
    
    self.cacheSliderView = [[UISlider alloc]init];
    self.cacheSliderView.minimumValue = 0;
    self.cacheSliderView.maximumValue = 1;
    self.cacheSliderView.value = 0;
    self.cacheSliderView.minimumTrackTintColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.cacheSliderView.maximumTrackTintColor = [UIColor clearColor];
    self.cacheSliderView.thumbTintColor = [UIColor clearColor];
    [self.bottonView addSubview:self.cacheSliderView];
    
    
    self.progressSliderView = [[UISlider alloc]init];
    self.progressSliderView.minimumValue = 0;
    self.progressSliderView.maximumValue = 1;
    self.progressSliderView.minimumTrackTintColor = [UIColor whiteColor];
    self.progressSliderView.maximumTrackTintColor = [UIColor colorWithWhite:1 alpha:0.3];
    self.progressSliderView.value = 0;
    [self.progressSliderView setThumbImage:[UIImage imageNamed:@"xbypoint"] forState:UIControlStateNormal];
    [self.progressSliderView setThumbImage:[UIImage imageNamed:@"xbypointh"] forState:UIControlStateHighlighted];
    [self.progressSliderView addTarget:self action:@selector(actionForProgress:) forControlEvents:UIControlEventValueChanged];
    [self.bottonView addSubview:self.progressSliderView];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc]init];
    self.activityIndicatorView.center = CGPointMake(self.playerWidth/2, self.playerHeight/2);
    self.activityIndicatorView.hidesWhenStopped = YES;
    self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [self addSubview:self.activityIndicatorView];
    
    [self.activityIndicatorView startAnimating];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionForShowBottonView)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGesture];
    
    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)pauseVideo{
    self.playButton.selected = NO;
    [self.player pause];
}

- (void)actionForShowBottonView{
    
    if (self.bottonView.alpha == 0.0) {
        self.countDown = 5;
        [UIView animateWithDuration:0.3 animations:^{
            self.bottonView.alpha = 1.0;
        }];
    }else{
        self.countDown = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.bottonView.alpha = 0.0;
        }];
    }
}

- (void)layoutSubviews{
    
    __weak typeof(self) ws = self;
    
    [self.bottonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.mas_left).offset(0);
        make.right.mas_equalTo(ws.mas_right).offset(0);
        make.bottom.mas_equalTo(ws.mas_bottom).offset(0);
        make.height.mas_equalTo(50);
    }];
    
    if (self.fullScreenButton.selected == YES) {
        [self.playButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.bottonView.mas_left).offset(10);
            make.top.mas_equalTo(ws.bottonView.mas_top).offset(10);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(40);
        }];
        
        [self.fullScreenButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(ws.bottonView.mas_right).offset(-10);
            make.top.mas_equalTo(ws.bottonView.mas_top).offset(10);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(40);
        }];
    }else{
        [self.playButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.bottonView.mas_left).offset(0);
            make.top.mas_equalTo(ws.bottonView.mas_top).offset(10);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(40);
        }];
        
        [self.fullScreenButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(ws.bottonView.mas_right).offset(0);
            make.top.mas_equalTo(ws.bottonView.mas_top).offset(10);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(40);
        }];
    }
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(ws.fullScreenButton.mas_left).offset(0);
        make.top.mas_equalTo(ws.bottonView.mas_top).offset(10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(70);
    }];
    
    [self.cacheSliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(ws.timeLabel.mas_left).offset(13);
        make.top.mas_equalTo(ws.bottonView.mas_top).offset(10);
        make.left.mas_equalTo(ws.playButton.mas_right).offset(0);
        make.height.mas_equalTo(40);
    }];
    
    [self.progressSliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(ws.timeLabel.mas_left).offset(0);
        make.top.mas_equalTo(ws.bottonView.mas_top).offset(10);
        make.left.mas_equalTo(ws.playButton.mas_right).offset(0);
        make.height.mas_equalTo(40);
    }];
    
    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(ws.timeLabel.center).offset(0);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
}

- (void)actionForfullScreenButton{
    //去掉隐式动画

    if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
        if (self.fullScreenButton.selected == YES) {
            self.fullScreenButton.selected = NO;
            [self.playSuperView  addSubview:self];
            
            self.bounds = CGRectMake(0, 0, self.playerWidth, self.playerHeight);
            self.center = CGPointMake(self.playerOriginX + self.playerWidth /2 , self.playerOriginY + self.playerHeight/2);
            self.transform = CGAffineTransformIdentity;
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            self.playerLayer.frame = CGRectMake(0, 0, self.playerWidth, self.playerHeight);
            self.gradientLayer.frame = CGRectMake(0, 0, self.playerWidth, 50);
            [CATransaction commit];
            [UIApplication sharedApplication].statusBarHidden = NO;
        }else{
            self.fullScreenButton.selected = YES;
            self.playSuperView = self.superview;
            [[UIApplication sharedApplication].keyWindow addSubview:self];
            
            self.bounds = CGRectMake(0, 0, XBYScreenHeight, XBYScreenWidth);
            self.center = CGPointMake(XBYScreenWidth/2, XBYScreenHeight/2);
            self.transform = CGAffineTransformMakeRotation(M_PI/2);
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            self.playerLayer.frame = CGRectMake(0, 0, XBYScreenHeight, XBYScreenWidth);
            self.gradientLayer.frame = CGRectMake(0, 0, XBYScreenHeight, 50);
            [CATransaction commit];
            [UIApplication sharedApplication].statusBarHidden = YES;
        }
        
        [self layoutIfNeeded];
    }
}

- (void)actionForPlayButton{
    if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
        self.countDown = 5;
        if (self.playButton.selected == YES) {
            self.playButton.selected = NO;
            [self.player pause];
        }else{
            self.playButton.selected = YES;
            [self.player play];
        }
    }
}

- (void)actionForProgress:(UISlider *)slider{
    if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
        self.countDown = 5;
        [self.player seekToTime:CMTimeMake(slider.value * CMTimeGetSeconds(self.playerItem.duration), 1) completionHandler:^(BOOL finished) {
        }];
    }
}

- (void)setVideoUrl:(NSString *)videoUrl{
    _videoUrl = videoUrl;
    
    self.countDown = 5;
    [UIView animateWithDuration:0.3 animations:^{
        self.bottonView.alpha = 1.0;
    }];

    if (!self.player) {

        self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_videoUrl]];
        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
        __weak typeof(self) ws = self;
        
        //刷新播放时间
        [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
           ws.progressSliderView.value = CMTimeGetSeconds(time) / CMTimeGetSeconds(ws.playerItem.duration);
           ws.timeLabel.text = [NSString stringWithFormat:@"%@/%@",[ws exchangeTimeFormatWithTimeInterval:CMTimeGetSeconds(time)],[ws exchangeTimeFormatWithTimeInterval:CMTimeGetSeconds(ws.playerItem.duration)]];
            if (CMTimeGetSeconds(time) / CMTimeGetSeconds(ws.playerItem.duration) == 1) {
                [ws.player seekToTime:CMTimeMake(0, 1) completionHandler:^(BOOL finished) {
                    ws.playButton.selected = NO;
                    ws.progressSliderView.value = 0;
                    [ws.player pause];
                }];
            }
            //监听隐藏bottonView
            if (ws.countDown > 0) {
                ws.countDown = ws.countDown - 1;
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    ws.bottonView.alpha = 0.0;
                }];
            }
        }];

        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        playerLayer.frame = CGRectMake(0, 0, self.playerWidth, self.playerHeight);
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.layer insertSublayer:playerLayer atIndex:0];
        self.playerLayer = playerLayer;

        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    }else{
        
        self.playButton.selected = NO;
        self.progressSliderView.value = 0;
        self.cacheSliderView.value = 0;
        self.playerItem = nil;
        [self.activityIndicatorView startAnimating];
        self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_videoUrl]];
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        //判断视频是否准备播放
        AVPlayerItemStatus status = [change[@"new"] integerValue];
        switch (status) {
            case AVPlayerItemStatusReadyToPlay:
                //准备播放
                //处理显示视频时长
                  CMTimeGetSeconds(self.playerItem.duration);
                self.timeLabel.text = [NSString stringWithFormat:@"00:00/%@",[self exchangeTimeFormatWithTimeInterval:CMTimeGetSeconds(self.playerItem.duration)]];
                [self.player play];
                self.playButton.selected = YES;
                [self.activityIndicatorView stopAnimating];
                break;
            case AVPlayerItemStatusFailed:
                //加载失败
                
                break;
            case AVPlayerItemStatusUnknown:
                //发生未知错误
                
                break;
            default:
                //加载失败
                break;
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        //获取缓存进度
        if (self.playerItem.loadedTimeRanges.count > 0) {
            CMTimeRange range = [self.playerItem.loadedTimeRanges.lastObject CMTimeRangeValue];
            //开始时间（每次更新开始时间） range.start; 时长 range.duration;
            //计算缓存时长
            NSTimeInterval totalTimeInterval = CMTimeGetSeconds(range.start) +  CMTimeGetSeconds(range.duration);
            self.cacheSliderView.value = totalTimeInterval / CMTimeGetSeconds(self.playerItem.duration);
            NSLog(@"cache -- %f",self.cacheSliderView.value);
        }
    }else if ([keyPath isEqualToString:@"frame"]){
        CGRect rect = [change[@"new"] CGRectValue];
        self.playerOriginX = rect.origin.x;
        self.playerOriginY = rect.origin.y;
         self.playerHeight = rect.size.height;
         self.playerWidth = rect.size.width;
    }
}


/**
 转换时间格式

 @param timeInterval 时间
 @return 返回格式化时间
 */
- (NSString *)exchangeTimeFormatWithTimeInterval:(NSTimeInterval)timeInterval{
    int second ,minute,total = timeInterval;
    minute = total / 60;
    second = total % 60;
    return [NSString stringWithFormat:@"%02d:%02d",minute,second];
}

- (void)dealloc{
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self removeObserver:self forKeyPath:@"frame"];
}

@end
