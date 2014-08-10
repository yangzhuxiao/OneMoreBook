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
#import "BookDetailViewController.h"

@implementation IngViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarItem.title = @"MyBooks";
    self.navigationItem.title = @"正在读的书";
    
    //TO BE DONE...
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchDisplayController:shouldReloadTableForSearchString:)];
    _searchedBooks = [NSMutableArray array];
    _selectedBook = [[BookInfo alloc] init];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:YES];
//    if (_searchDisplayController.active == NO) {
//        [_searchDisplayController setActive:YES animated:YES];
//    }
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:YES];
//    if (_searchDisplayController.active == YES) {
//        [_searchDisplayController setActive:NO animated:YES];
//    }
//}

- (void)searchByKeyword:(NSString *)searchString
{
    [SearchViaDoubanAPI searchBook:searchString WithResults:^(NSArray *resultsArray) {
        for (BookInfo *book in resultsArray){
            [_searchedBooks addObject:book];
        }
        [self.searchDisplayController.searchResultsTableView reloadData];
    }];
}

- (void)pushViewControllerAtIndex:(NSInteger)index
{
    _searchedBooks = [_searchedBooks objectAtIndex:index];
    BookDetailViewController *detailViewController = [[BookDetailViewController alloc] init];
    
    detailViewController.titleString = _selectedBook.bookTitle;
    detailViewController.authorString = [_selectedBook.bookAuthor componentsJoinedByString:@" "];
    detailViewController.imageString = _selectedBook.bookImage;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_searchedBooks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CustomCell";
    UINib *nib = [UINib nibWithNibName:@"CustomCell" bundle:nil];
    if (nib){
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    }
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell){
        cell = [[CustomCell alloc] init];
    }
    
    BookInfo *newBook = [[BookInfo alloc] init];
    newBook = [_searchedBooks objectAtIndex:indexPath.row];
    
    cell.bookTitle.text = [newBook valueForKey:@"bookTitle"];
    NSArray *bookAuthorArray = [newBook valueForKey:@"bookAuthor"];
    //不能用objectAtIndex:因为若bookAuthorArray为empty时会报错！！！
//    NSString *author1 = [bookAuthorArray objectAtIndex:0];
    NSString *authorAll = [bookAuthorArray componentsJoinedByString:@" "];
    NSString *authorPref = @"作者：";
    cell.bookAuthor.text = [authorPref stringByAppendingString:authorAll];
    NSString *imagePath = [newBook valueForKey:@"bookImage"];
    //方式一：Ios自己的类来实现
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]];
    cell.bookImage.image = [UIImage imageWithData:data];
    
/*  //方式二：restkit中AFNetworking库中的方法
    NSURL *imageURL = [NSURL URLWithString:imagePath];
    [cell.bookImage setImageWithURL:imageURL placeholderImage:nil];
*/
    return cell;
}

#pragma mark - UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchDisplayController.searchBar resignFirstResponder];//目的为了点击隐藏键盘
    [self pushViewControllerAtIndex:indexPath.row];
}
#pragma mark - UISearchDisplayDelegate medhods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSString *pref = [NSString stringWithFormat:@"%@?apikey=%@&q=", kSearchURL, kAPIKey];
    searchString = [pref stringByAppendingString:searchString];
    [self searchByKeyword:searchString];
    return YES;
}
@end
