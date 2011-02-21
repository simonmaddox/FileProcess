//
//  FileProcessConfig.h
//  FileProcess
//
//  Created by Simon Maddox on 21/02/2011.
//  Copyright 2011 Sensible Duck Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileProcessConfig : NSObject {

}

+ (NSString *) extension;
+ (NSString *) launchPath;
+ (NSArray *) argumentsWithPath:(NSString *) path;
+ (NSString *) logStringWithOutput:(NSString *)output error:(NSString *)error path:(NSString *)path;

@end
