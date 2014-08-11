//
//  IngViewController.m
//  OneMoreBook
//
//  Created by Yang Xiaozhu on 14-7-25.
//  Copyright (c) 2014年 Xiaozhu. All rights reserved.
//

#import "AppDelegate.h"
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
    
    id delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Book"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    NSError *error = nil;
    _fetchedSuccessfully = [_fetchedResultsController performFetch:&error];
}

- (void)searchByKeyword:(NSString *)searchString
{
    [SearchViaDoubanAPI searchBook:searchString WithResults:^(NSArray *resultsArray) {
        for (BookInfo *book in resultsArray){
            [_searchedBooks addObject:book];
        }
        [self.searchDisplayController.searchResultsTableView reloadData];
    }];
}

- (void)pushViewControllerWithBookTitle:(NSString *)title bookAuthor:(NSString *)author bookImage:(NSData *)image
{
    BookDetailViewController *detailViewController = [[BookDetailViewController alloc] init];
    
    detailViewController.bookTitle = title;
    detailViewController.bookAuthor = author;
    detailViewController.bookImage = image;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView){
        return 1;
    }
    else return [[_fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_searchedBooks count];
    }
    else if ([[_fetchedResultsController sections] count] > 0)
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:0];
        return [sectionInfo numberOfObjects];
    }
    else return 0;
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
    
    NSString *authorPref = @"作者：";
    BookInfo *newBook = [[BookInfo alloc] init];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        newBook = [_searchedBooks objectAtIndex:indexPath.row];
        
        cell.bookTitle.text = [newBook valueForKey:@"bookTitle"];
        NSArray *bookAuthorArray = [newBook valueForKey:@"bookAuthor"];
        NSString *authorAll = [bookAuthorArray componentsJoinedByString:@" "];
        cell.bookAuthor.text = [authorPref stringByAppendingString:authorAll];
        NSString *imagePath = [newBook valueForKey:@"bookImage"];

        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]];
        cell.bookImage.image = [UIImage imageWithData:data];
    }
    else if (_fetchedSuccessfully)
    {
        NSManagedObject *managedObject = [_fetchedResultsController objectAtIndexPath:indexPath];
        cell.bookTitle.text = [managedObject valueForKey:@"title"];
        cell.bookAuthor.text = [authorPref stringByAppendingString:[managedObject valueForKey:@"author"]];
        NSData *imageData = [managedObject valueForKey:@"image"];
        cell.bookImage.image = [UIImage imageWithData:imageData];
    }
    return cell;
}

#pragma mark - UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title;
    NSString *author;
    NSData *image;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        [self.searchDisplayController.searchBar resignFirstResponder];//目的为了点击隐藏键盘
        _selectedBook = [_searchedBooks objectAtIndex:indexPath.row];
        title = _selectedBook.bookTitle;
        author = [_selectedBook.bookAuthor componentsJoinedByString:@" "];
        image = [NSData dataWithContentsOfURL:[NSURL URLWithString:_selectedBook.bookImage]];
    }
    else
    {
        NSManagedObject *managedObject = [_fetchedResultsController objectAtIndexPath:indexPath];
        title = [managedObject valueForKey:@"title"];
        author = [managedObject valueForKey:@"author"];
        image = [managedObject valueForKey:@"image"];
    }
    [self pushViewControllerWithBookTitle:title bookAuthor:author bookImage:image];
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
