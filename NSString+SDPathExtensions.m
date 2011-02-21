//
//  NSString+SDPathExtensions.m
//  FileProcess
//
//  Created by Simon Maddox on 21/02/2011.
//  Copyright 2011 Sensible Duck Ltd. All rights reserved.
//

#import "NSString+SDPathExtensions.h"


@implementation NSString (SDPathExtensions)

- (BOOL) isDirectory
{
	NSError *error;
	if ([[[NSFileManager defaultManager] attributesOfItemAtPath:self error:&error] objectForKey:NSFileType] == NSFileTypeDirectory){
		return YES;
	}
	
	return NO;
}

@end
