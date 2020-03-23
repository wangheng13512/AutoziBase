//
//  ZYXQueryPair.h
//  Xinan
//
//  Created by ZhanyaaLi on 2017/11/2.
//  Copyright © 2017年 zhanyaa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYXQuery : NSObject

+ (NSString *)queryStringFromParams:(NSDictionary *)params;

+ (NSString *)queryURLStringFromParams:(NSDictionary *)params; //urlencode 请求
//+ (NSDictionary *)querySortParamsFromParams:(NSDictionary *)params;

@end

@interface ZYXQueryPair : NSObject

@property (readonly, nonatomic, strong) id field;
@property (readonly, nonatomic, strong) id value;

- (id)initWithField:(id)field value:(id)value;

- (NSString *)URLCombineKeyEqualValue;

- (NSString *)URLEncodedStringValueWithEncoding:(NSStringEncoding)stringEncoding;

@end


