//
//  QiTaskSource.h
//  Notes
//
//  Created by chenbin-c on 2019/3/2.
//  Copyright © 2019 chenbin-c. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QiTask.h"

@interface QiTaskSource : NSObject

@property (nonatomic, readonly) QiTask *task;

- (CFRunLoopSourceRef)getCFRunLoopSourceRef;

- (void)invalidate;
- (void)fireTask:(QiTask *)task;

- (void)clear;

@end
