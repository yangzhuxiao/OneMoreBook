//
//  SearchViaDoubanAPI.m
//  OneMoreBook
//
//  Created by Yang Xiaozhu on 14-7-27.
//  Copyright (c) 2014年 Xiaozhu. All rights reserved.
//

#import "SearchViaDoubanAPI.h"

@implementation SearchViaDoubanAPI

+ (void)searchBook:(NSString *)searchString WithResults:(void (^)(NSArray * resultsArray))resultsBlock
{
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[SearchViaDoubanAPI class]];
    

    [mapping addAttributeMappingsFromDictionary:@{@"title": @"bookTitle",
                                                  @"image": @"bookImage",
                                                  @"author": @"bookAuthor"}];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodAny pathPattern:nil keyPath:@"books" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSString *urlString = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSArray *array = mappingResult.array;
        resultsBlock(mappingResult.array);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Shit, Searching failed...");
    }];
    [operation start];
}

@end

