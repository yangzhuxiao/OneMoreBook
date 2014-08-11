//
//  IngViewController.h
//  OneMoreBook
//
//  Created by Yang Xiaozhu on 14-7-25.
//  Copyright (c) 2014年 Xiaozhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookInfo.h"
#import <CoreData/CoreData.h>

@interface IngViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate>

@property (nonatomic, copy) NSMutableArray *searchedBooks;

@property (nonatomic, strong) BookInfo *selectedBook;
@property (nonatomic, assign) BOOL fetchedSuccessfully;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end