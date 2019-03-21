//
//  LongLifeThreadViewController.m
//  RunLoopDemo
//
//  Created by chenbin-c on 2019/3/12.
//  Copyright © 2019 chenbin-c. All rights reserved.
//

#import "LongLifeThreadViewController.h"

static void RunLoopInputSourcePerformRoutine(void *info);

@interface LongLifeThreadViewController ()

@property (nonatomic, strong) NSThread *normalThread;
@property (nonatomic, strong) NSThread *longLifeThread;

@property (nonatomic, assign) CFRunLoopRef runLoopRef;
@property (nonatomic, assign) CFRunLoopSourceRef runLoopSourceRef;

@end

@implementation LongLifeThreadViewController

- (void)dealloc
{
    if (self.normalThread != nil) {
        [self.normalThread cancel];
        self.normalThread = nil;
    }
    
    if (_runLoopRef != NULL) {
        _runLoopRef = NULL;
    }
    
    if (_runLoopSourceRef != NULL) {
        CFRunLoopSourceInvalidate(_runLoopSourceRef);
        _runLoopSourceRef = NULL;
    }
    
    if (self.longLifeThread != nil) {
        [self.longLifeThread cancel];
        self.longLifeThread = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.normalThread = [[NSThread alloc] initWithTarget:self selector:@selector(startUpNormalThread) object:nil];
    self.normalThread.name = @"Normal Thread";
    [self.normalThread start];
    
    self.longLifeThread = [[NSThread alloc] initWithTarget:self selector:@selector(startUpLongLifeThread) object:nil];
    self.longLifeThread.name = @"Long Life Thread";
    [self.longLifeThread start];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)startUpNormalThread
{
    NSLog(@"Normal Thread Start Up");
}

//- (void)startUpLongLifeThread
//{
//    NSLog(@"Long Life Thread Start Up");
//    @try {
//        while (true) {
//            CFRunLoopRun();
//        }
//    }
//    @catch (NSException *exception) {
//        @throw exception;
//    }
//}

- (void)startUpLongLifeThread
{
    NSLog(@"Long Life Thread Start Up");

    //将源或计时器添加到RunLoop中，否则RunLoop启动完成后立刻结束
    _runLoopRef = CFRunLoopGetCurrent();
    CFRunLoopSourceContext sourceContext = {};
    sourceContext.info = (__bridge void *)(self);
    sourceContext.perform = &RunLoopInputSourcePerformRoutine;
    _runLoopSourceRef = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &sourceContext);
    CFRunLoopAddSource(_runLoopRef, _runLoopSourceRef, kCFRunLoopDefaultMode);

    BOOL done = NO;
    do {
        CFRunLoopRunResult result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 5, YES);
        if (result == kCFRunLoopRunStopped || result == kCFRunLoopRunFinished) {
            done = YES;
        }

    } while (done == NO);

    CFRelease(_runLoopSourceRef);
}

- (void)hello
{
    NSLog(@"Hello Thread %@", [[NSThread currentThread] name]);
}

- (IBAction)sayHelloInNormalThread:(id)sender
{
    [self performSelector:@selector(hello) onThread:self.normalThread withObject:nil waitUntilDone:NO];
}

- (IBAction)sayHelloInLongLifeThread:(id)sender
{
//    [self performSelector:@selector(hello) onThread:self.longLifeThread withObject:nil waitUntilDone:NO];
    
    if (CFRunLoopIsWaiting(_runLoopRef) == YES) {
        CFRunLoopWakeUp(_runLoopRef);
    }
    CFRunLoopSourceSignal(_runLoopSourceRef);
}

@end


static void RunLoopInputSourcePerformRoutine(void *info)
{
    LongLifeThreadViewController *vc = (__bridge LongLifeThreadViewController *)(info);
    [vc hello];
}
