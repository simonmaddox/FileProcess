//
//  FileProcessAppDelegate.m
//  FileProcess
//
//  Created by Simon Maddox on 20/02/2011.
//  Copyright 2011 Sensible Duck Ltd. All rights reserved.
//

#import "FileProcessAppDelegate.h"
#import "NSString+SDPathExtensions.h"

#define FileExtension @"txt"

@implementation FileProcessAppDelegate

@synthesize window, openPanel, textView, spinner, stopButton;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[self showOpenPanel];
}

- (void) showOpenPanel
{
	isStopped = NO;
	self.openPanel = [NSOpenPanel openPanel];
	[self.openPanel setCanChooseDirectories:YES];
	[self.openPanel setAllowsMultipleSelection:YES];
	[self.openPanel setCanChooseFiles:YES];
	[self.openPanel setDelegate:self];
	
	[self.openPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
		if (result == NSFileHandlingPanelOKButton){
			[self.textView setString:@""];
			for (NSURL *url in [self.openPanel URLs]){
				[NSThread detachNewThreadSelector:@selector(startFileSearchAtPath:) toTarget:self withObject:[url path]];
			}
		}
	}];
	
}

- (BOOL)panel:(id)sender shouldEnableURL:(NSURL *)url
{
	if ([[url path] isDirectory]){
		return YES;
	}
	
	if ([[[[url path] pathExtension] lowercaseString] isEqualToString:FileExtension]){
		return YES;
	}
	
	return NO;
}

- (void) startSpinner
{
	[self.spinner startAnimation:nil];
	[self.stopButton setEnabled:YES];
	[self.stopButton setHidden:NO];
}

- (void) stopSpinner
{
	[self.spinner stopAnimation:nil];
	[self.stopButton setHidden:YES];
}

- (void) startFileSearchAtPath:(NSString *)path
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[self performSelectorOnMainThread:@selector(startSpinner) withObject:nil waitUntilDone:NO];
	[self findFileWithExtension:FileExtension inPath:path recursive:YES];
	[self performSelectorOnMainThread:@selector(stopSpinner) withObject:nil waitUntilDone:NO];
	[pool drain];
}

- (void) findFileWithExtension:(NSString *)extension inPath:(NSString *)path recursive:(BOOL)recursive
{	
	if (isStopped){
		return;
	}
	
	if ([path isDirectory]){
		// this will get called if the user selects a directory
			
		NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
		
		for (NSString *filename in contents){
			NSString *fullPath = [path stringByAppendingPathComponent:filename];
			
			if (isStopped){
				return;
			}
			
			if ([fullPath isDirectory] && recursive){
				[self findFileWithExtension:extension inPath:fullPath recursive:recursive];
			} else if ([[[fullPath pathExtension] lowercaseString] isEqualToString:extension]){
				//[self performSelectorOnMainThread:@selector(handleFoundFile:) withObject:fullPath waitUntilDone:YES];
				[self handleFoundFile:fullPath];
			}
		}
	} else if ([[[path pathExtension] lowercaseString] isEqualToString:extension]){
		// this will get called if the user selects files
		//[self performSelectorOnMainThread:@selector(handleFoundFile:) withObject:path waitUntilDone:YES];
		[self handleFoundFile:path];
	}
}

- (void) handleFoundFile:(NSString *)path
{
	NSLog(@"Checking file: %@", path);
	
	NSTask *task;
	task = [[NSTask alloc] init];
	[task setLaunchPath:@"cat"];
	
	NSArray *arguments;
	arguments = [NSArray arrayWithObjects:path, nil];
	[task setArguments:arguments];
	
	NSPipe *pipe;
	pipe = [NSPipe pipe];
	
	NSPipe *errorPipe;
	errorPipe = [NSPipe pipe];
	
	[task setStandardOutput:pipe];
	[task setStandardError:errorPipe];
	
	NSFileHandle *file;
	file = [pipe fileHandleForReading];
	
	NSFileHandle *errorFile;
	errorFile = [errorPipe fileHandleForReading];
	
	[task launch];
	
	NSData *data;
	NSData *errorData;
	
	data = [file readDataToEndOfFile];
	errorData = [errorFile readDataToEndOfFile];
	
	NSString *returnString;
	returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	NSString *errorString;
	errorString = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
	
	NSString *logString = [NSString stringWithFormat:@"Found File: %@\n\n%@%@---------------\n\n", path, errorString, returnString];
	
	[returnString release];
	[errorString release];
	[task release];
	
	[self performSelectorOnMainThread:@selector(appendStringToLog:) withObject:logString waitUntilDone:YES];
}

- (void) appendStringToLog:(NSString *)string
{
	[self.textView setEditable:YES];
	[self.textView insertText:string];
	[self.textView setEditable:NO];
}

- (IBAction) chooseFiles:(id)sender
{
	[self showOpenPanel];
}

- (IBAction) saveLog:(id)sender
{
	NSSavePanel *savePanel = [NSSavePanel savePanel];
	[savePanel setTitle:@"Save Log"];
	[savePanel setRequiredFileType:@"txt"];
	
	[savePanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
		if (result == NSFileHandlingPanelOKButton){
			[[NSFileManager defaultManager] createFileAtPath:[[savePanel URL] path] contents:[[self.textView string] dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
		}
	}];
}

- (IBAction) stopProcess:(id)sender
{
	isStopped = YES;
	[self.stopButton setEnabled:NO];
}

@end
