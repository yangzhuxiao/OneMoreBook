//
//  BookDetailViewController.m
//  TimeToRead
//
//  Created by Yang Xiaozhu on 14-5-19.
//  Copyright (c) 2014年 XiaoZhuAndJiaNing. All rights reserved.
//

#import "BookDetailViewController.h"

@implementation BookDetailViewController

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
//    [[IngBookStore sharedStore] createNewBookWithTitle:_titleString WithAuthor:_authorString WithImage:_imageView.image];
//    
//    [[IngBookStore sharedStore] saveChanges];
}
@end
