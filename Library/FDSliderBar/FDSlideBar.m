//
//  FDSlideBar.m
//  FDSlideBarDemo
//
//  Created by fergusding on 15/6/4.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import "FDSlideBar.h"
#import "FDSlideBarItem.h"

#define DEVICE_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define DEFAULT_SLIDER_COLOR RGB(0,160,240)
#define SLIDER_VIEW_HEIGHT 2
#define SLIDER_VIEW_WIDTH kSizeFrom750(60)

@interface FDSlideBar () <FDSlideBarItemDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSMutableArray *itemIconsArray;
@property (strong, nonatomic) UIView *sliderView;

@property (strong, nonatomic) FDSlideBarItem *selectedItem;
@property (strong, nonatomic) FDSlideBarItemSelectedCallback callback;
Assign BOOL isHaveIcons;

@end

@implementation FDSlideBar

#pragma mark - Lifecircle

- (instancetype)init {
    CGRect frame = CGRectMake(0, 20, DEVICE_WIDTH, 46);
    self.backgroundColor = COLOR_White;
    
    return [self initWithFrame:frame];
   
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_White;
        _items = [NSMutableArray array];
        _itemIconsArray = [NSMutableArray array];
        [self initScrollView];
        [self initSliderView];
        [self initLineView];
    }
    return self;
}

#pragma - mark Custom Accessors
-(void)initLineView{
    UIView *lineView = [[UIView alloc]initWithFrame:RECT(0, self.height - kLineHeight, screen_width, kLineHeight)];
    lineView.backgroundColor = separaterColor;
    [self addSubview:lineView];
}
- (void)setItemsTitle:(NSArray *)itemsTitle {
    _itemsTitle = itemsTitle;
    [self setupItems];
}
-(void)setItemsIcons:(NSArray *)itemsIcons
{
    _itemsIcons = itemsIcons;
}
-(void)setItemsSelectedIcons:(NSArray *)itemsSelectedIcons
{
    _itemsSelectedIcons = itemsSelectedIcons;
    _isHaveIcons = YES;
}
- (void)setItemColor:(UIColor *)itemColor {
    for (FDSlideBarItem *item in _items) {
        [item setItemTitleColor:itemColor];
    }
}

- (void)setItemSelectedColor:(UIColor *)itemSelectedColor {
    for (FDSlideBarItem *item in _items) {
        [item setItemSelectedTitleColor:itemSelectedColor];
    }
}

- (void)setSliderColor:(UIColor *)sliderColor {
    _sliderColor = sliderColor;
    self.sliderView.backgroundColor = _sliderColor;
}

- (void)setSelectedItem:(FDSlideBarItem *)selectedItem {
    _selectedItem.selected = NO;
    _selectedItem = selectedItem;
    if (self.isHaveIcons) {
        for (int i=0; i<self.itemIconsArray.count; i++) {
            UIButton *btn = self.itemIconsArray[i];
            if (i==selectedItem.tag) {
                btn.selected = YES;
            }else
                btn.selected = NO;
        }
    }
}


#pragma - mark Private

- (void)initScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    [self addSubview:_scrollView];
}

- (void)initSliderView {
    _sliderView = [[UIView alloc] init];
    _sliderColor = DEFAULT_SLIDER_COLOR;
    _sliderView.backgroundColor = _sliderColor;
    [_scrollView addSubview:_sliderView];
}

- (void)setupItems {
    CGFloat itemX = 0;
    [_items makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    [_items removeAllObjects];
   
    CGFloat allWidth = 0;
    for (NSString *title in _itemsTitle) {
        // Init the current item's frame
        allWidth += [FDSlideBarItem widthForTitle:title];
    }
    
    BOOL averageWidth = NO;
    float expand = 0;
    if (allWidth > 0 && allWidth < CGRectGetWidth(_scrollView.frame)) {
        averageWidth = YES;
        expand = (CGRectGetWidth(_scrollView.frame) - allWidth) / _itemsTitle.count;
    }
    
    for (int i=0; i<_itemsTitle.count;i++) {
        NSString *title = _itemsTitle[i];
        FDSlideBarItem *item = [[FDSlideBarItem alloc] init];
        item.delegate = self;
        
        // Init the current item's frame
        CGFloat itemW = [FDSlideBarItem widthForTitle:title];
        if (averageWidth) {
            itemW += expand;
        }
        item.frame = CGRectMake(itemX, 0, itemW, CGRectGetHeight(_scrollView.frame));
        if (self.isHaveIcons) {
            [item setItemTitle:title icon:YES];
        }else{
            [item setItemTitle:title icon:NO];
        }
        item.tag = i;
        [_items addObject:item];
        
        [_scrollView addSubview:item];
        
        if(self.isHaveIcons){
            UIButton *imageV = InitObject(UIButton);
            imageV.frame = RECT(kSizeFrom750(80), (_scrollView.height -kSizeFrom750(34))/2, kSizeFrom750(40), kSizeFrom750(34));
            [imageV.imageView setContentMode:UIViewContentModeScaleAspectFit];
            [imageV setImage:IMAGEBYENAME(self.itemsIcons[i]) forState:UIControlStateNormal];
            [imageV setImage:IMAGEBYENAME(self.itemsSelectedIcons[i]) forState:UIControlStateSelected];
            [item addSubview:imageV];
            [_itemIconsArray addObject:imageV];
        }
        // Caculate the origin.x of the next item
        itemX = CGRectGetMaxX(item.frame);
    }
    
    // Cculate the scrollView 's contentSize by all the items
    _scrollView.contentSize = CGSizeMake(itemX, CGRectGetHeight(_scrollView.frame));
    
    // Set the default selected item, the first item
    FDSlideBarItem *firstItem = [self.items firstObject];
    firstItem.selected = YES;
    _selectedItem = firstItem;
    UIButton *firstBtn = [self.itemIconsArray firstObject];
    firstBtn.selected = YES;
    // Set the frame of sliderView by the selected item
    _sliderView.frame = CGRectMake(self.selectedItem.left+(_selectedItem.width - SLIDER_VIEW_WIDTH)/2, self.frame.size.height - SLIDER_VIEW_HEIGHT, SLIDER_VIEW_WIDTH, SLIDER_VIEW_HEIGHT);
}

- (void)scrollToVisibleItem:(FDSlideBarItem *)item {
    NSInteger selectedItemIndex = [self.items indexOfObject:_selectedItem];
    NSInteger visibleItemIndex = [self.items indexOfObject:item];
    
    // If the selected item is same to the item to be visible, nothing to do
    if (selectedItemIndex == visibleItemIndex) {
        return;
    }
    
    CGPoint offset = _scrollView.contentOffset;
    
    // If the item to be visible is in the screen, nothing to do
    if (CGRectGetMinX(item.frame) >= offset.x && CGRectGetMaxX(item.frame) <= (offset.x + CGRectGetWidth(_scrollView.frame))) {
        return;
    }
    
    // Update the scrollView's contentOffset according to different situation
    if (selectedItemIndex < visibleItemIndex) {
        // The item to be visible is on the right of the selected item and the selected item is out of screeen by the left, also the opposite case, set the offset respectively
        if (CGRectGetMaxX(_selectedItem.frame) < offset.x) {
            offset.x = CGRectGetMinX(item.frame);
        } else {
            offset.x = CGRectGetMaxX(item.frame) - CGRectGetWidth(_scrollView.frame);
        }
    } else {
        // The item to be visible is on the left of the selected item and the selected item is out of screeen by the right, also the opposite case, set the offset respectively
        if (CGRectGetMinX(_selectedItem.frame) > (offset.x + CGRectGetWidth(_scrollView.frame))) {
            offset.x = CGRectGetMaxX(item.frame) - CGRectGetWidth(_scrollView.frame);
        } else {
            offset.x = CGRectGetMinX(item.frame);
        }
    }
    _scrollView.contentOffset = offset;
}
//添加移动效果
- (void)addAnimationWithSelectedItem:(FDSlideBarItem *)item {
    // Caculate the distance of translation
    CGFloat dx = CGRectGetMidX(item.frame) - CGRectGetMidX(_selectedItem.frame);
    
    // Add the animation about translation
    CABasicAnimation *positionAnimation = [CABasicAnimation animation];
    positionAnimation.keyPath = @"position.x";
    positionAnimation.fromValue = @(_sliderView.layer.position.x);
    positionAnimation.toValue = @(_sliderView.layer.position.x + dx);
    
    // Add the animation about size
    CABasicAnimation *boundsAnimation = [CABasicAnimation animation];
    boundsAnimation.keyPath = @"bounds.size.width";
    boundsAnimation.fromValue = @(CGRectGetWidth(_sliderView.layer.bounds));
    boundsAnimation.toValue = @(CGRectGetWidth(_sliderView.frame));
    
    // Combine all the animations to a group
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[positionAnimation, boundsAnimation];
    animationGroup.duration = 0.2;
    [_sliderView.layer addAnimation:animationGroup forKey:@"basic"];
    
    // Keep the state after animating
    _sliderView.layer.position = CGPointMake(_sliderView.layer.position.x + dx, _sliderView.layer.position.y);
    CGRect rect = _sliderView.layer.bounds;
    rect.size.width = _sliderView.width;
    _sliderView.layer.bounds = rect;
}

#pragma mark - Public

- (void)slideBarItemSelectedCallback:(FDSlideBarItemSelectedCallback)callback {
    _callback = callback;
}

- (void)selectSlideBarItemAtIndex:(NSUInteger)index {
    FDSlideBarItem *item = [self.items objectAtIndex:index];
    if (item == _selectedItem) {
        return;
    }
    if (self.isHaveIcons) {
        for (int i=0; i<self.itemIconsArray.count; i++) {
            UIButton *btn = self.itemIconsArray[i];
            if (i==index) {
                btn.selected = YES;
            }else
                btn.selected = NO;
        }
    }
   
    item.selected = YES;
    [self scrollToVisibleItem:item];
    [self addAnimationWithSelectedItem:item];
    self.selectedItem = item;
}

#pragma mark - FDSlideBarItemDelegate

- (void)slideBarItemSelected:(FDSlideBarItem *)item {
    if (item == _selectedItem) {
        return;
    }
    
    [self scrollToVisibleItem:item];
    [self addAnimationWithSelectedItem:item];
    self.selectedItem = item;
    _callback([self.items indexOfObject:item]);
}

@end
