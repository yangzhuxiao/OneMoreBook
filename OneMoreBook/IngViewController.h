//
//  IngViewController.h
//  OneMoreBook
//
//  Created by Yang Xiaozhu on 14-7-25.
//  Copyright (c) 2014年 Xiaozhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookInfo.h"

@interface IngViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate>

@property (nonatomic, copy) NSMutableArray *searchedBooks;
@property (nonatomic, copy) NSMutableArray *savedBooks;

@property (nonatomic, strong) BookInfo *selectedBook;

@end