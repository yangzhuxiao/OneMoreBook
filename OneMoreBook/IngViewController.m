//
//  IngViewController.m
//  OneMoreBook
//
//  Created by Yang Xiaozhu on 14-7-25.
//  Copyright (c) 2014年 Xiaozhu. All rights reserved.
//

#import "IngViewController.h"
#import "SearchViaDoubanAPI.h"

@interface IngViewController ()

@end

@implementation IngViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)sendRequest:(NSString *)searchString
{
    [SearchViaDoubanAPI searchBook:searchString WithResults:^(NSArray *resultsArray) {
        _titlesArray = [resultsArray valueForKey:@"bookTitle"];
        _authorsArray = [resultsArray valueForKey:@"bookAuthor"];
        _imageArray = [resultsArray valueForKey:@"bookImage"];
        
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
    return [_titlesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CustomCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [_titlesArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UISearchDisplayDelegate medhods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSString *pref = @"https://api.douban.com/v2/book/search?apikey=0071e999e5b2c9100155bccdb1185b30&q=";
    searchString = [pref stringByAppendingString:searchString];
    
    [self sendRequest:searchString];
    return YES;
}

@end
