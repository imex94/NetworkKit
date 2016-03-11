//
//  AFAuthFunctions.m
//  OAuthTest
//
//  Created by Oliver Drobnik on 6/23/14.
//  Copyright (c) 2014 Cocoanetics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFAuthFunctions.h"

NSDictionary *AFAuthDictionaryFromQueryString(NSString *string)
{
	NSMutableDictionary *result = [NSMutableDictionary dictionary];
	NSArray *parameters = [string componentsSeparatedByString:@"&"];
	
	for (NSString *parameter in parameters)
	{
		NSArray *parts = [parameter componentsSeparatedByString:@"="];
		NSString *key = [[parts objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		
		if ([parts count] > 1)
		{
			id value = [[parts objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			[result setObject:value forKey:key];
		}
	}
	return result;
}