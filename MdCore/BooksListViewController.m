//
//  ViewController.m
//  MdCore
//
//  Created by Jid Hatami on 9/23/16.
//  Copyright © 2016 Jid Hatami. All rights reserved.
//

#import "BooksListViewController.h"
#import "BookItemUICollectionViewCell.h"
#import "AppManager.h"

#import "EPubViewController.h"

@interface BooksListViewController ()<UIToolbarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching, UICollectionViewDelegateFlowLayout, RDContainerDelegate>{
    NSArray* bookList;
    
    NSInteger numberOfCellsPerSection;
    CGFloat cellSpacing;
    AppManager* appMngr;
@private NSMutableArray* m_sdkErrorMessages;
}

@end

@implementation BooksListViewController

- (BOOL)container:(RDContainer *)container handleSdkError:(NSString *)message isSevereEpubError:(BOOL)isSevereEpubError {
    
    NSLog(@"READIUM SDK: %@\n", message);
    
    if (isSevereEpubError == YES)
        [m_sdkErrorMessages addObject:message];
    
    // never throws an exception
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    appMngr = [AppManager SharedInstance];
    numberOfCellsPerSection = 1;
    cellSpacing = 1;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self calculateCellSizeAndSpacingForCollectionView:_bookListCollectionView];
    
    //Load it now ,
    bookList = [appMngr getBookLists];
    NSLog(@"Booklist:%ld", bookList.count);
    [_bookListCollectionView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar{
    return UIBarPositionTopAttached;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if(bookList==nil || bookList.count <= 0 ) return 0;
    return 1;
    /*
    NSInteger count = bookList.count / numberOfCellsPerSection;
    if( (bookList.count % numberOfCellsPerSection) > 0){
        count ++;
    }
    return count;
     */
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(bookList==nil || bookList.count <= 0 ) return 0;
    return bookList.count;
    /*
    if(bookList.count <= numberOfCellsPerSection) return bookList.count;
    
    NSInteger count = bookList.count - (section *numberOfCellsPerSection);
    if(count >= numberOfCellsPerSection) return numberOfCellsPerSection;
    else if(count < 0) return 0;
    else return count;
     */
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BookItemUICollectionViewCell *cell = [_bookListCollectionView dequeueReusableCellWithReuseIdentifier:@"BookItemUICollectionViewCell" forIndexPath:indexPath];
    
    
    NSInteger cellIndex = ((indexPath.section *numberOfCellsPerSection) + indexPath.row);
    //NSLog(@"numberOfCellsPerSection:%ld row:%ld  section:%ld  cellIndex:%ld",numberOfCellsPerSection, indexPath.row, indexPath.section, cellIndex);
    [cell.nameLabel setText:[appMngr getBookTitleByBookPath:[bookList objectAtIndex:cellIndex] ViewController:self]];

    //UIImage* image = [appMngr getBookFirstPageSnapshotByBookPath:[bookList objectAtIndex:cellIndex] ViewController:self];
    //NSLog(@"%f %f", image.size.width, image.size.height);
    return cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self calculateCellSizeAndSpacingForCollectionView:collectionView];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    RDContainer *m_container = [[RDContainer alloc] initWithDelegate:self path:[bookList objectAtIndex:indexPath.row] ];
    RDPackage *m_package = m_container.firstPackage;
    
    //[self popErrorMessage];
    if(m_package == nil) return;
    RDSpineItem *spineItem = [m_package.spineItems objectAtIndex:0];
    if(spineItem == nil) return;
    
    //EPubViewController *c = [[EPubViewController alloc] initWithContainer:m_container package:m_package spineItem:spineItem cfi:nil];
    EPubViewController *c = [[EPubViewController alloc] initWithContainer:m_container package:m_package spineItem:spineItem cfi:nil CompletionHandler:^(UIImage *image, NSString *msgToUI, NSError *error) {
        NSLog(@"Image:%f", image.size.width);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            BookItemUICollectionViewCell *cell = (BookItemUICollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:cell.frame];
            [imgV setImage:image];
            [cell addSubview:imgV];
        });
    }];
    
    [c.view setFrame:self.view.frame];
    [c loadView];
    
    //[self.navigationController pushViewController:c animated:YES];
}

-(CGSize) calculateCellSizeAndSpacingForCollectionView:(UICollectionView *)collectionView{
    numberOfCellsPerSection = 1;
    CGFloat cellWidth = 72.0f; //default cell width
    CGFloat cellHeight = 108.0f; //default cell height
    CGFloat edgeSpacing = 32.0f; //default edge spacing
    CGFloat cellWidthToHeightRatio = (202.0f/137.0f);
    //if iphone
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        cellWidth = 72; // Each cell width
    }
    //If ipad
    else {
        cellWidth = 137; // Each cell width
    }
    
    cellSpacing = (collectionView.bounds.size.width - (cellWidth*numberOfCellsPerSection) - (edgeSpacing* (numberOfCellsPerSection-1)) )/ (numberOfCellsPerSection-1); //Each cell to other spacing

    cellHeight = cellWidth * cellWidthToHeightRatio;
    
    //NSLog(@"pw:%f ph:%f  w:%f h:%f   cellWidth:%f  cellHeight:%f  spacing:%f  ,NoCell/Section:%ld", self.view.frame.size.width, self.view.frame.size.height, collectionView.bounds.size.width, collectionView.bounds.size.height, cellWidth, cellHeight, cellSpacing, numberOfCellsPerSection);
    
    return CGSizeMake(cellWidth, cellHeight);
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [_bookListCollectionView.collectionViewLayout invalidateLayout];
    [self calculateCellSizeAndSpacingForCollectionView:_bookListCollectionView];
    //[_bookListCollectionView reloadData];
}

@end
