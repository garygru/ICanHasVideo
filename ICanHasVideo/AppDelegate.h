//
//  AppDelegate.h
//  ICanHasVideo
//
//  Created by Gary Grutzek on 08.11.15.
//  Copyright © 2015 Gary Grutzek. No rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Downloader.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
	
	IBOutlet NSTextField *urlField;
	IBOutlet NSScrollView *scrollView;
	IBOutlet NSTextView *console;
	IBOutlet NSTextField *label;
	Downloader *dl;
}

- (IBAction) download:(id)sender;
- (IBAction) abort:(id)sender;
- (void)updateConsole:(NSString*)text;
- (void)updateLabel:(NSString*)text;

@end

