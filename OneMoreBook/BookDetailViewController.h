//
//  BookDetailViewController.h
//  TimeToRead
//
//  Created by Yang Xiaozhu on 14-5-19.
//  Copyright (c) 2014年 XiaoZhuAndJiaNing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+AFNetworking.h>

@interface BookDetailViewController : UIViewController

@property (nonatomic, copy) NSString *bookTitle;
@property (nonatomic, copy) NSString *bookAuthor;
@property (nonatomic, strong) NSData *bookImage;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UILabel *publisherLabel;
@property (strong, nonatomic) IBOutlet UILabel *isbnNumberLabel;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *textViewLabel;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UILabel *evaluationLabel;


@end
