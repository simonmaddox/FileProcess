//
//  FileProcessConfig.m
//  FileProcess
//
//  Created by Simon Maddox on 21/02/2011.
//  Copyright 2011 Sensible Duck Ltd. All rights reserved.
//

#import "FileProcessConfig.h"


@implementation FileProcessConfig

+ (NSString *) extension
{
	return @"txt";
}

+ (NSString *) launchPath
{
	return @"/bin/cat";
}

+ (NSArray *) argumentsWithPath:(NSString *) path
{
	return [NSArray arrayWithObjects:path, nil];
}

+ (NSString *) logStringWithOutput:(NSString *)output error:(NSString *)error path:(NSString *)path
{
	return [NSString stringWithFormat:@"Found File: %@\n\n%@%@---------------\n\n", path, error, output];
}

@end
