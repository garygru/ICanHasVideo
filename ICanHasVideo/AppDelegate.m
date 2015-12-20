//
//  AppDelegate.m
//  ICanHasVideo
//
//  Created by Gary Grutzek on 08.11.15.
//  Copyright © 2015 Gary Grutzek. No rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	dl = [[Downloader alloc] init];
	[console setTextColor:[NSColor whiteColor]];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
	[dl abort];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
	return YES;
}

- (IBAction)download:(id)sender
{
	NSURL *url = [NSURL URLWithString:[urlField stringValue]];
	if ([[url absoluteString] length] > 0) {
		[dl download:url];
	}
}

- (IBAction)abort:(id)sender
{
	[dl abort];
}

- (void) updateConsole:(NSString*)text
{
	[console setString:text];
}

- (void)updateLabel:(NSString*)text
{
	NSString * oneLineText = [text stringByReplacingOccurrencesOfString:@"\r" withString:@""];
	[label setStringValue:oneLineText];
}

@end
