//
//  NSObject+Addition.m
//  Kit
//
//  Created by  wzh on 14-7-2.
//  Copyright (c) 2014年 wzh. All rights reserved.
//

#import "NSObject+Addition.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
//
//  针对NSObject扩展
//
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NSObject (Addition)

#pragma mark -  check empty
+ (BOOL)isEmpty:(id)object {
	return (object == nil
	        || [object isKindOfClass:[NSNull class]]
	        || ([object respondsToSelector:@selector(length)] && [(NSData *)object length] == 0)
	        || ([object respondsToSelector:@selector(count)]  && [(NSArray *)object count] == 0));
}

+ (BOOL)isNotEmpty:(id)object {
    return ( ! [self isEmpty:object]);
}

@end
