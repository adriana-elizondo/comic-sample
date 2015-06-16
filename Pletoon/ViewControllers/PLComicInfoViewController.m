//
//  PLComicInfoViewController.m
//  Pletoon
//
//  Created by Adriana Elizondo on 6/13/15.
//  Copyright (c) 2015 Adriana. All rights reserved.
//

#import "PLComicInfoViewController.h"

@interface PLComicInfoViewController (){
    NSArray *categories;
}

@end

@implementation PLComicInfoViewController
@synthesize comic;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self displayComicInfo];
    
    //Show comic categories
    categories = [[NSArray alloc] initWithArray:[comic.categories array]];
    
    self.categoriesTableView.tableFooterView = [[UIView alloc] init];
    [self.categoriesTableView reloadData];
}

#pragma mark - Display comic information
-(void)displayComicInfo{
    UIImage *image = [UIImage imageWithData:comic.squareImage];
    [self.comicImage setImage:image];
    
    //Add border to image
    self.comicImage.layer.borderWidth = 1.0f;
    self.comicImage.layer.borderColor=[UIColor blackColor].CGColor;
    
    self.comicTitle.text = comic.title;
    self.comicDescription.text = comic.comicDescription;
    self.rating.text = [NSString stringWithFormat:@"%@", comic.rating];
    self.principalCategory.text = comic.principalCategory;
    
    //Artist info
    UIImage *avatar = [UIImage imageWithData:comic.artist.avatar];
    [self.artistAvatar setImage:avatar];
    self.artistName.text = comic.artist.name;
    self.artistEmail.text = comic.artist.email;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableview datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return categories.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"categoryCell";
    PLCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Categories *category = [categories objectAtIndex:indexPath.row];
    cell.categoryName.text = category.title;
    cell.categoryName.textColor = [self colorWithHexString:category.backgroundColor];
    UIImage *categoryImage = [UIImage imageNamed:category.title];
    [cell.categoryImage setImage:categoryImage];
    
    return cell;
}

#pragma mark - Get category color
-(UIColor *)colorWithHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

#pragma mark - Return
- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
