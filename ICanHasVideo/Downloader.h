//
//  Downloader.h
//  ICanHasVideo
//
//  Created by Gary Grutzek on 08.11.15.
//  Copyright © 2015 Gary Grutzek. No rights reserved.
//

#import <Foundation/Foundation.h>

@interface Downloader : NSObject {
	NSMutableData *stdErrorData;
	NSFileHandle *outFile;
	NSFileHandle *errFile;

}

- (void)createTask:(NSURL*)url;
- (void)download:(NSURL*)url;
- (void)abort;

@property NSTask *task;

@end
