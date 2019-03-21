//
//  QiTaskSource.m
//  Notes
//
//  Created by chenbin-c on 2019/3/2.
//  Copyright © 2019 chenbin-c. All rights reserved.
//

#import "QiTaskSource.h"

static void RunLoopInputSourceScheduleRoutine(void *info, CFRunLoopRef rl, CFStringRef mode);
static void RunLoopInputSourceCancelRoutine(void *info, CFRunLoopRef rl, CFStringRef mode);
static void RunLoopInputSourcePerformRoutine(void *info);

@interface QiTaskSource ()

@property (nonatomic, assign) CFRunLoopSourceRef sourceRef;

@end

@implementation QiTaskSource

- (void)dealloc
{
    if (_sourceRef != NULL) {
        CFRelease(_sourceRef);
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        CFRunLoopSourceContext ctx = {
//            0, (__bridge void *)(self),
//            NULL, NULL, NULL, NULL, NULL,
//            &RunLoopInputSourceScheduleRoutine,
//            &RunLoopInputSourceCancelRoutine,
//            &RunLoopInputSourcePerformRoutine
//        };
        CFRunLoopSourceContext sourceContext;
        sourceContext.info = (__bridge void *)(self);
        sourceContext.perform = &RunLoopInputSourcePerformRoutine;
        _sourceRef = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &sourceContext);
    }
    return self;
}

- (CFRunLoopSourceRef)getCFRunLoopSourceRef
{
    return _sourceRef;
}

- (void)fireTask:(QiTask *)task
{
    _task = task;
    CFRunLoopSourceSignal(_sourceRef);
}

- (void)invalidate
{
    [self clear];
    CFRunLoopSourceInvalidate(_sourceRef);
}

- (void)clear
{
    _task = nil;
}

@end

//当将InputSource加到RunLoop中后，会回调该方法
static void RunLoopInputSourceScheduleRoutine(void *info, CFRunLoopRef rl, CFStringRef mode)
{
    NSLog(@"InputSource Schedule Routine");
}

//当调用CFRunLoopSourceInvalidate方法时，会回调该方法
static void RunLoopInputSourceCancelRoutine(void *info, CFRunLoopRef rl, CFStringRef mode)
{
    NSLog(@"InputSource Cancel Routine");
}

//One of the most important callback routines is the one used to process custom data when your input source is signaled.
static void RunLoopInputSourcePerformRoutine(void *info)
{
   NSLog(@"InputSource Perform Routine");
    QiTaskSource *source = (__bridge QiTaskSource *)info;
    [source.task start];
    [source clear];
}
