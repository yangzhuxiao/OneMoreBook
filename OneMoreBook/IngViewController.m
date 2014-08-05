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
    self.tabBarItem.title = @"我的书";
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
    
    
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
    if (nibs.count > 0)
    {
        [tableView registerNib:nibs[0] forCellReuseIdentifier:cellIdentifier];
    }
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSString *bookTitle = [[_booksArray objectAtIndex:indexPath.row] valueForKey:@"bookTitle"];
//    NSString *bookAuthor = [[_booksArray objectAtIndex:indexPath.row] valueForKey:@"bookAuthor"];
    NSString *bookImage = [[_booksArray objectAtIndex:indexPath.row] valueForKey:@"bookImage"];

    if (bookTitle)
    {
        cell.bookTitle.text = [[_booksArray objectAtIndex:indexPath.row] valueForKey:@"bookTitle"];
    }
//    if (bookAuthor)
//    {
//        cell.bookAuthor.text = [[_booksArray objectAtIndex:indexPath.row] valueForKey:@"bookAuthor"];
//    }
    if (bookImage)
    {
        NSString *imageURL = [[_booksArray objectAtIndex:indexPath.row] valueForKey:@"bookImage"];
        UIImage *image = [UIImage imageWithContentsOfFile:imageURL];
        cell.bookImage = [[UIImageView alloc] initWithImage:image];
    }
    
    return cell;
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
