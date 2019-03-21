//
//  MainRunLoopViewController.m
//  RunLoopDemo
//
//  Created by chenbin-c on 2019/3/12.
//  Copyright © 2019 chenbin-c. All rights reserved.
//

#import "MainRunLoopViewController.h"

@interface MainRunLoopViewController ()

@end

@implementation MainRunLoopViewController


- (void)dealloc
{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)startUpMainRunLoop:(id)sender
{
    NSLog(@"startUpMainRunLoop method run");
    while (true) {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    }
}

- (IBAction)log:(id)sender
{
    NSLog(@"log method run");
}

@end
