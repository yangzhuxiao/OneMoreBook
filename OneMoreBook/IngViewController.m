//
//  IngViewController.m
//  OneMoreBook
//
//  Created by Yang Xiaozhu on 14-7-25.
//  Copyright (c) 2014年 Xiaozhu. All rights reserved.
//

#import "IngViewController.h"
#import "SearchViaDoubanAPI.h"
#import "DoubanHeaders.h"
#import "CustomCell.h"

@implementation IngViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarItem.title = @"MyBooks";
    _booksArray = [NSArray array];
}

- (void)searchByKeyword:(NSString *)searchString
{
    [SearchViaDoubanAPI searchBook:searchString WithResults:^(NSArray *resultsArray) {
        _booksArray = resultsArray;
        [self.searchDisplayController.searchResultsTableView reloadData];
    }];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_booksArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CustomCell";
    
    UINib *nib = [UINib nibWithNibName:@"CustomCell" bundle:nil];

    if (nib)
    {
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    }
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        cell = [[CustomCell alloc] init];
    }
    
    cell.bookTitle.text = [[_booksArray objectAtIndex:indexPath.row] valueForKey:@"bookTitle"];
    cell.bookTitle.text = [[_booksArray objectAtIndex:indexPath.row] valueForKey:@"bookAuthor"];

    NSString *imagePath = [[_booksArray objectAtIndex:indexPath.row] valueForKey:@"bookImage"];
    NSURL *imageURL = [NSURL URLWithString:imagePath];
    
    [cell.bookImage setImageWithURL:imageURL placeholderImage:nil];
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

#pragma mark - UISearchDisplayDelegate medhods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSString *pref = [NSString stringWithFormat:@"%@?apikey=%@&q=", kSearchURL, kAPIKey];
    searchString = [pref stringByAppendingString:searchString];
    //   searchString =@"https://api.douban.com/v2/book/search?apikey=0071e999e5b2c9100155bccdb1185b30&q=we";
    [self searchByKeyword:searchString];
    return YES;
}
@end
