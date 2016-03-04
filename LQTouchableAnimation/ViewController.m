//
//  ViewController.m
//  LQTouchableAnimation
//
//  Created by renren on 16/3/4.
//  Copyright © 2016年 luqiang. All rights reserved.
//

#import "ViewController.h"
#import "LQAnimationBackView.h"

@interface ViewController () <UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dateItems;
@property (nonatomic, strong) UIImageView *animatedView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self initViews];
    
}

- (void)initViews {
    // table view
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.animatedView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feed_game_icon"]];
    
    //动画背景，可响应触摸事件
    LQAnimationBackView *animatedBackView = [[LQAnimationBackView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/2)];
    animatedBackView.animatedView = self.animatedView;
    [animatedBackView addSubview:self.animatedView];
    [self.view addSubview:animatedBackView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animatedTouch:)];
    [animatedBackView addGestureRecognizer:tap];
    
    //添加动画
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, 0, 20);
    CGPathAddQuadCurveToPoint(curvedPath, NULL, SCREEN_WIDTH, SCREEN_HEIGHT/4, 0, SCREEN_HEIGHT/2);
    pathAnimation.path = curvedPath;
    pathAnimation.duration = 5;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    
    [self.animatedView.layer addAnimation:pathAnimation forKey:@"pathAnimation"];
}


- (void)animatedTouch:(id)sender {
    NSLog(@"animated view is touched.");
    [self addFragmentAnimationToView:self.view];
}

- (void)loadData {
    self.dateItems = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i = 0; i < 20; i++) {
        NSDate *date = [NSDate date];
        [self.dateItems addObject:date];
    }
}

- (void)addFragmentAnimationToView:(UIView *)view {
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    emitter.emitterPosition = CGPointMake(SCREEN_WIDTH / 2.0, -30);
    emitter.emitterSize     = CGSizeMake(SCREEN_WIDTH, 0.0);;
    emitter.emitterMode    = kCAEmitterLayerPoints;
    emitter.emitterShape	= kCAEmitterLayerLine;
    
    CGFloat scaleRatio = 1;
    
    CAEmitterCell *(^generateEmitterCell)(NSString *) = ^(NSString *iconName) {
        CAEmitterCell *flowerFlake = [CAEmitterCell emitterCell];
        CGFloat random = (arc4random()%100) / 100.f;
        flowerFlake.birthRate		= 3 * random;
        flowerFlake.lifetime		= 120.0;
        flowerFlake.velocity		= 100;
        flowerFlake.yAcceleration   = 75;
        flowerFlake.emissionRange   = -M_PI;
        flowerFlake.spinRange		= 2 * M_PI;
        flowerFlake.scale           = 0.4 * scaleRatio;
        flowerFlake.contents		= (id)[[UIImage imageNamed:iconName] CGImage];
        return flowerFlake;
    };
    
    NSMutableArray *emitterCells = [NSMutableArray array];
    for (int iconIndex = 1; iconIndex < 25; ++iconIndex) {
        NSString *iconName = [@"Fragment_" stringByAppendingString:[@(iconIndex) stringValue]];
        [emitterCells addObject:generateEmitterCell(iconName)];
    }
    emitter.emitterCells = emitterCells;
    [view.layer addSublayer:emitter];
}




#pragma mark - tableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dateItems.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commonCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commonCell"];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSString *describe = [NSString stringWithFormat:@"%ld   %@", indexPath.item, [dateFormatter stringFromDate:self.dateItems[indexPath.item]]];
    cell.textLabel.text = describe;
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
