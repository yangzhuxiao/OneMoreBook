//
//  SearchViaDoubanAPI.h
//  OneMoreBook
//
//  Created by Yang Xiaozhu on 14-7-27.
//  Copyright (c) 2014年 Xiaozhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit.h>

@interface SearchViaDoubanAPI : NSObject

+ (void)searchBook:(NSString *)searchString WithResults:(void (^)(NSArray * resultsArray))resultsBlock;

@property (nonatomic, copy) NSArray *bookAuthor;
@property (nonatomic, copy) NSString *bookTitle;
@property (nonatomic, copy) NSString *bookImage;

@end
