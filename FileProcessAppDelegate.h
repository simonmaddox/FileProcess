//
//  FileProcessAppDelegate.h
//  FileProcess
//
//  Created by Simon Maddox on 20/02/2011.
//  Copyright 2011 Sensible Duck Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FileProcessAppDelegate : NSObject <NSApplicationDelegate, NSOpenSavePanelDelegate> {
    NSWindow *window;
	NSOpenPanel *openPanel;
	NSTextView *textView;
	NSProgressIndicator *spinner;
	NSButton *stopButton;
	BOOL isStopped;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSOpenPanel *openPanel;
@property (assign) IBOutlet NSTextView *textView;
@property (assign) IBOutlet NSProgressIndicator *spinner;
@property (assign) IBOutlet NSButton *stopButton;

- (void) showOpenPanel;

- (void) findFileWithExtension:(NSString *)extension inPath:(NSString *)path recursive:(BOOL)recursive;
- (void) handleFoundFile:(NSString *)path;

- (IBAction) stopProcess:(id)sender;

- (IBAction) chooseFiles:(id)sender;
- (IBAction) saveLog:(id)sender;

@end
