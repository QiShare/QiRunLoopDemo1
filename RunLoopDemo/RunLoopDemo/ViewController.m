//
//  ViewController.m
//  RunLoopDemo
//
//  Created by chenbin-c on 2019/3/12.
//  Copyright © 2019 chenbin-c. All rights reserved.
//

#import "ViewController.h"
#import "TimerSourceViewController.h"
#import "MainRunLoopViewController.h"
#import "LongLifeThreadViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)enterMainRunLoopViewController:(id)sender
{
    MainRunLoopViewController *vc = [[MainRunLoopViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)enterTimerSourceViewController:(id)sender
{
    TimerSourceViewController *vc = [[TimerSourceViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)enterLongLifeThreadViewController:(id)sender
{
    LongLifeThreadViewController *vc = [[LongLifeThreadViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
