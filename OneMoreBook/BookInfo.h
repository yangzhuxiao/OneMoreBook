//
//  bookInfo.h
//  OneMoreBook
//
//  Created by Yang Xiaozhu on 14-8-6.
//  Copyright (c) 2014年 Xiaozhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookInfo : NSObject

@property (nonatomic, copy) NSString *bookTitle;
@property (nonatomic, copy) NSString *bookImage;
@property (nonatomic, copy) NSArray *bookAuthor;

@end
