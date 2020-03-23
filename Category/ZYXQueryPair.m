//
//  ZYXQueryPair.m
//  Xinan
//
//  Created by ZhanyaaLi on 2017/11/2.
//  Copyright © 2017年 zhanyaa. All rights reserved.
//

#import "ZYXQueryPair.h"

static NSString * const kZYXCharactersToBeEscapedInQueryString = @":/?&=;+!@#$()',*";

static NSString * ZYXPercentEscapedQueryStringKeyFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
    static NSString * const kZYXCharactersToLeaveUnescapedInQueryStringPairKey = @"[].";
    
    return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, (__bridge CFStringRef)kZYXCharactersToLeaveUnescapedInQueryStringPairKey, (__bridge CFStringRef)kZYXCharactersToBeEscapedInQueryString, CFStringConvertNSStringEncodingToEncoding(encoding));
}

static NSString * ZYXPercentEscapedQueryStringValueFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
    return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)kZYXCharactersToBeEscapedInQueryString, CFStringConvertNSStringEncodingToEncoding(encoding));
}


extern NSArray * ZYXQueryStringPairsFromDictionary(NSDictionary *dictionary);
extern NSArray * ZYXQueryStringPairsFromKeyAndValue(NSString *key, id value);
//获取排序后的字符串
static NSString * ZYXQueryStringFromParametersWithEncoding(NSDictionary *parameters, NSStringEncoding stringEncoding) {
    NSMutableArray *mutablePairs = [NSMutableArray array];
    for (ZYXQueryPair *pair in ZYXQueryStringPairsFromDictionary(parameters)) {
        [mutablePairs addObject:[pair URLCombineKeyEqualValue]];
    }
    return [mutablePairs componentsJoinedByString:@"&"];
}

//排序后的字符串 url编码
static NSString * ZYXQueryURLStringFromParametersWithEncoding(NSDictionary *parameters, NSStringEncoding stringEncoding) {
    NSMutableArray *mutablePairs = [NSMutableArray array];
    for (ZYXQueryPair *pair in ZYXQueryStringPairsFromDictionary(parameters)) {
        [mutablePairs addObject:[pair URLEncodedStringValueWithEncoding:stringEncoding]];
    }
    return [mutablePairs componentsJoinedByString:@"&"];
}

/*
//获取排序后的字典
static NSDictionary * ZYXQueryParamsFromParametersWithEncoding(NSDictionary *parameters, NSStringEncoding stringEncoding) {
    NSMutableDictionary *mutablePairs = [NSMutableDictionary dictionary];
    for (ZYXQueryPair *pair in ZYXQueryStringPairsFromDictionary(parameters)) {
        [mutablePairs setObject:pair.value forKey:pair.field];
    }
    return mutablePairs;
} */

NSArray * ZYXQueryStringPairsFromDictionary(NSDictionary *dictionary) {
    return ZYXQueryStringPairsFromKeyAndValue(nil, dictionary);
}

NSArray * ZYXQueryStringPairsFromKeyAndValue(NSString *key, id value) {
    NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)];
    
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = value;
        // Sort dictionary keys to ensure consistent ordering in query string, which is important when deserializing potentially ambiguous sequences, such as an array of dictionaries
        for (id nestedKey in [dictionary.allKeys sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            id nestedValue = [dictionary objectForKey:nestedKey];
            if (nestedValue) {
                [mutableQueryStringComponents addObjectsFromArray:ZYXQueryStringPairsFromKeyAndValue((key ? [NSString stringWithFormat:@"%@[%@]", key, nestedKey] : nestedKey), nestedValue)];
            }
        }
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = value;
        for (id nestedValue in array) {
            [mutableQueryStringComponents addObjectsFromArray:ZYXQueryStringPairsFromKeyAndValue([NSString stringWithFormat:@"%@[]", key], nestedValue)];
        }
    } else if ([value isKindOfClass:[NSSet class]]) {
        NSSet *set = value;
        for (id obj in [set sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            [mutableQueryStringComponents addObjectsFromArray:ZYXQueryStringPairsFromKeyAndValue(key, obj)];
        }
    } else {
        [mutableQueryStringComponents addObject:[[ZYXQueryPair alloc] initWithField:key value:value]];
    }
    
    return mutableQueryStringComponents;
}




@interface ZYXQueryPair ()

@property (readwrite, nonatomic, strong) id field;
@property (readwrite, nonatomic, strong) id value;

@end

@implementation ZYXQueryPair

- (id)initWithField:(id)field value:(id)value {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.field = field;
    self.value = value;
    
    return self;
}

- (NSString *)URLCombineKeyEqualValue {
    return [NSString stringWithFormat:@"%@=%@", [self.field description], [self.value description]];
}

- (NSString *)URLEncodedStringValueWithEncoding:(NSStringEncoding)stringEncoding {
     if (!self.value || [self.value isEqual:[NSNull null]]) {
         return ZYXPercentEscapedQueryStringKeyFromStringWithEncoding([self.field description], stringEncoding);
     } else {
     return [NSString stringWithFormat:@"%@=%@", ZYXPercentEscapedQueryStringKeyFromStringWithEncoding([self.field description], stringEncoding), ZYXPercentEscapedQueryStringValueFromStringWithEncoding([self.value description], stringEncoding)];
     }
}

@end


@interface ZYXQuery ()


@end

@implementation ZYXQuery

+ (NSString *)queryStringFromParams:(NSDictionary *)params {
    return ZYXQueryStringFromParametersWithEncoding(params, NSUTF8StringEncoding);
}

+ (NSString *)queryURLStringFromParams:(NSDictionary *)params {
    return ZYXQueryURLStringFromParametersWithEncoding(params, NSUTF8StringEncoding);
}

/*
+ (NSDictionary *)querySortParamsFromParams:(NSDictionary *)params {
    return ZYXQueryParamsFromParametersWithEncoding(params, NSUTF8StringEncoding);
} */


@end


