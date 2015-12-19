//
//  Downloader.m
//  ICanHasVideo
//
//  Created by Gary Grutzek on 08.11.15.
//  Copyright © 2015 Gary Grutzek. No rights reserved.
//

#import "Downloader.h"
#import "AppDelegate.h"

@implementation Downloader
@synthesize task;

- (instancetype)init
{
	self = [super init];
	if (self) {
		stdErrorData = [[NSMutableData alloc] init];
	}
	return self;
}

- (void)createTask:(NSURL*)url
{
	if ([task isRunning]) {
		NSLog(@"nope, busy");
	}
	else {
		task = [[NSTask alloc] init];
		NSBundle *mainBundle = [NSBundle mainBundle];
		[task setLaunchPath:[mainBundle pathForResource:@"youtube-dl" ofType:nil]];
		[task setCurrentDirectoryPath:@"~/Desktop"];

		NSString* urlString = [url absoluteString];
		task.arguments = @[@"-f", @"best", @"-v", urlString];
		
		// Std Out
		NSPipe *errPipe = [NSPipe pipe];
		task.standardError = errPipe;
		errFile = [errPipe fileHandleForReading];
		[errFile readToEndOfFileInBackgroundAndNotify];
		
		// Std Err
		NSPipe *outPipe = [NSPipe pipe];
		task.standardOutput = outPipe;
		outFile = [outPipe fileHandleForReading];
		[outFile readInBackgroundAndNotify];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(fileHandleReadCompletionNotification:)
													 name:NSFileHandleReadCompletionNotification
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(fileHandleReadCompletionNotification:)
													 name:NSFileHandleReadToEndOfFileCompletionNotification
												   object:errFile];
	}
}


- (void)fileHandleReadCompletionNotification: (NSNotification*)notification
{
	AppDelegate *delegate = [[NSApplication sharedApplication] delegate];
	
	NSData *data = [notification.userInfo objectForKey: NSFileHandleNotificationDataItem];
	if(notification.object == outFile) {
		if( data.length > 0 ) {
			[outFile readInBackgroundAndNotify];
			NSString *output = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
			[delegate updateLabel:output];
			[delegate updateConsole:@"loading...."];
		}
		else {
			[outFile closeFile];
			outFile = nil;
		}
	}
	else if(notification.object == errFile) {
		if( data.length > 0 ) {
			NSString *output = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
			[delegate updateConsole:output];
			[task terminate];
			[errFile closeFile];
		}
		else {
			[errFile closeFile];
			errFile = nil;
		}
	}
}


- (void)download:(NSURL*)url
{
	if ([task isRunning]) {
		NSLog(@"nope, busy");
	}
	else {
		[self createTask:url];
		[task launch];
	}
}


- (void)abort
{
	if ([task isRunning]) {
		[task terminate];
	}
}


@end
