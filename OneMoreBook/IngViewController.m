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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchDisplayController:shouldReloadTableForSearchString:)];
    _booksArray = [NSMutableArray array];
    _selectedBook = [[BookInfo alloc] init];
}

- (void)searchByKeyword:(NSString *)searchString
{
    [SearchViaDoubanAPI searchBook:searchString WithResults:^(NSArray *resultsArray) {
        for (BookInfo *book in resultsArray){
            [_booksArray addObject:book];
        }
        [self.searchDisplayController.searchResultsTableView reloadData];
    }];
}

- (void)pushViewControllerAtIndex:(NSInteger)index
{
    _selectedBook = [_booksArray objectAtIndex:index];
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
    return [_booksArray count];
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
    newBook = [_booksArray objectAtIndex:indexPath.row];
    
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
    [self pushViewControllerAtIndex:indexPath.row];
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
