//
//  IngViewController.h
//  OneMoreBook
//
//  Created by Yang Xiaozhu on 14-7-25.
//  Copyright (c) 2014年 Xiaozhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IngViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate>

@property (nonatomic, copy) NSArray *titlesArray;
@property (nonatomic, copy) NSArray *authorsArray;
@property (nonatomic, copy) NSArray *imageArray;

@end
