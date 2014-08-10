//
//  BookDetailViewController.m
//  TimeToRead
//
//  Created by Yang Xiaozhu on 14-5-19.
//  Copyright (c) 2014年 XiaoZhuAndJiaNing. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "BookDetailViewController.h"
#import "AppDelegate.h"

@implementation BookDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBookToReadingStore)];
    
    _titleLabel.text = _titleString;
    _authorLabel.text = _authorString;

    NSURL *imageURL = [NSURL URLWithString:_imageString];
    [_imageView setImageWithURL:imageURL placeholderImage:nil];
}

- (void)addBookToReadingStore
{
    id delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSManagedObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:context];
    [newObject setValue:_titleString forKey:@"title"];
    [newObject setValue:_authorString forKey:@"author"];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_imageString]];
    [newObject setValue:imageData forKey:@"image"];
    
    [delegate saveContext];
}
@end
