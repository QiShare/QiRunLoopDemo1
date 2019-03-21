//
//  TimerSourceViewController.m
//  RunLoopDemo
//
//  Created by chenbin-c on 2019/3/12.
//  Copyright © 2019 chenbin-c. All rights reserved.
//

#import "TimerSourceViewController.h"

@interface TimerSourceViewController ()
<UIScrollViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger counter;

@end

@implementation TimerSourceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.counter = 0;
    [self updateNavigationBarTitle];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"loop" style:UIBarButtonItemStylePlain target:self action:@selector(loop:)];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(count:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)loop:(id)sender
{
    for (int i = 0; i < 100000; i++) {
        // do nothing
        NSLog(@"%d", i);
    }
}

- (void)count:(id)sender
{
    self.counter++;
    [self updateNavigationBarTitle];
    
    NSLog(@"count: %td current Run Loop Mode %@", self.counter, [[NSRunLoop currentRunLoop] currentMode]);
}

- (void)updateNavigationBarTitle
{
    self.title = [NSString stringWithFormat:@"%td", self.counter];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll: current Run Loop Mode %@", [[NSRunLoop currentRunLoop] currentMode]);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%td", indexPath.row+1];
    return cell;
}

@end
