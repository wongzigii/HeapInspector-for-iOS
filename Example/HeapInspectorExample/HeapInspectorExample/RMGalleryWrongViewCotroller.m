//
//  RMGalleryViewCotroller.m
//  HeapInspectorExample
//
//  Created by Christian Menschel on 12/11/14.
//  Copyright (c) 2014 tapwork. All rights reserved.
//

#import "RMGalleryWrongViewCotroller.h"
#import "RMGalleryCollectionViewCell.h"

static NSString *const kRMGalleryCollectionViewCellID = @"RMGalleryCollectionViewCellID";

@interface RMGalleryWrongViewCotroller () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSArray *dataSource;
@property (nonatomic) NSTimer *timer;

@end

@implementation RMGalleryWrongViewCotroller

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSource = @[@"IMG_0573.JPG", @"IMG_0594.JPG", @"IMG_0601.JPG", @"IMG_0635.JPG", @"IMG_0656.JPG"];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.collectionView registerClass:[RMGalleryCollectionViewCell class] forCellWithReuseIdentifier:kRMGalleryCollectionViewCellID];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    [self.view addSubview:self.collectionView];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [self.timer fire];
    
    // This will create a retain cycle
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification
                                                      object:nil queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      [self.timer invalidate];
                                                  }];
}

- (void)dealloc
{
    // this is wrong and dealloc will never get fired, because the timer created an retain cycle
    [self.timer invalidate];
}

#pragma mark - Timer

- (void)timerFired:(NSTimer *)timer
{
    CGRect rect = self.collectionView.bounds;
    rect.origin.x += rect.size.width;
    if (rect.origin.x >= self.collectionView.contentSize.width) {
        rect.origin.x = 0.0;
    }
    [self.collectionView scrollRectToVisible:rect animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.bounds.size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RMGalleryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRMGalleryCollectionViewCellID forIndexPath:indexPath];
    UIImage *image = [UIImage imageNamed:self.dataSource[indexPath.row]];
    cell.imageView.image = image;
    
    return cell;
}

@end

