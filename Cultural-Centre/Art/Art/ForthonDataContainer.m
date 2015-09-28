//
//  ForthonDataContainer.m
//  Login
//
//  Created by Liu fushan on 15/5/18.
//  Copyright (c) 2015年 culturalCenter. All rights reserved.
//

#import "ForthonDataContainer.h"


@implementation ForthonDataContainer



+ (instancetype)sharedStore
{

    
    // Do I need to create a sharedStore?
    
    static dispatch_once_t onceToken;
    static ForthonDataContainer *sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[ForthonDataContainer alloc] init];
    });
    
    return sSharedInstance;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSMutableArray *)videosDic
{
    if (!_videosDic) {
        
        _videosDic = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 6; i++) {
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [_videosDic addObject:array];
        }
        NSLog(@"count: %lu", _videosDic.count);
    }
    return _videosDic;
}

- (NSMutableDictionary *)artDescriptionDic {

    if (!_artDescriptionDic) {

        _artDescriptionDic = [NSMutableDictionary new];
    }

    return _artDescriptionDic;
}

- (NSMutableArray *)artListDic
{
    if (!_artListDic) {

        _artListDic = [[NSMutableArray alloc] init];
        for (int i = 0; i < 6; i++) {
            NSArray *array = [[NSArray alloc] init];
            [_artListDic addObject:array];
        }
        NSLog(@"count: %lu", _artListDic.count);
    }
    return _artListDic;
}

- (NSMutableArray *)artTradeListDic {

    if (!_artTradeListDic) {

        _artTradeListDic = [[NSMutableArray alloc] init];
        for (int i = 0; i < 6; i++) {
            NSArray *array = [[NSArray alloc] init];
            [_artTradeListDic addObject:array];
        }
        NSLog(@"count: %lu", _artTradeListDic.count);
    }
    return _artTradeListDic;
}

//- (NSMutableArray *)pagesDic
//{
//    if (!_pagesDic) {
//
//        _pagesDic = [[NSMutableArray alloc] init];
//        for (int i = 0; i < 9; i++) {
//            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//            [_pagesDic addObject:dic];
//        }
//
//    }
//    return _pagesDic;
//}

//- (NSMutableDictionary *)artDescriptionDic
//{
//    if (!_artDescriptionDic) {
//        _artDescriptionDic = [[NSMutableDictionary alloc] init];
//    }
//    return _artDescriptionDic;
//}


- (NSMutableDictionary *)commentsDic
{
    if (!_commentsDic) {
        _commentsDic = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *videoComments = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *artComments = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *pageComments = [[NSMutableDictionary alloc] init];
        
        [_commentsDic setObject:videoComments forKey:@"videosComments"];
        [_commentsDic setObject:artComments forKey:@"artsComments"];
        [_commentsDic setObject:pageComments forKey:@"pagesComments"];
        
        
    }
   
    return _commentsDic;
    
}

- (NSMutableDictionary *)skimsDic
{
    if (!_skimsDic) {
        _skimsDic = [[NSMutableDictionary alloc] init];
        NSMutableArray *commentTop = [[NSMutableArray alloc] init];
        NSMutableArray *skimTop = [[NSMutableArray alloc] init];
        NSMutableArray *newTop = [[NSMutableArray alloc] init];
        
        _skimsDic[@"commentTop"] = commentTop;
        _skimsDic[@"skimTop"] = skimTop;
        _skimsDic[@"newTop"] = newTop;
        //初始化skimsDic
        NSLog(@"初始化SkimsDic");
    }
    
    return _skimsDic;
}

- (NSMutableDictionary *)searchResultDic
{
    if (!_searchResultDic) {
        _searchResultDic = [[NSMutableDictionary alloc] init];
        NSMutableArray *pageArray = [[NSMutableArray alloc] init];
        NSMutableArray *artArray = [[NSMutableArray alloc] init];
        NSMutableArray *userArray = [[NSMutableArray alloc] init];
        NSMutableArray *videoArray = [[NSMutableArray alloc] init];
        
        [_searchResultDic setObject:pageArray forKey:@"page"];
        [_searchResultDic setObject:artArray forKey:@"art"];
        [_searchResultDic setObject:userArray forKey:@"user"];
        [_searchResultDic setObject:videoArray forKey:@"video"];
        
    }
    return _searchResultDic;
}


- (NSMutableArray *)authorArtGroup
{
    if (!_authorArtGroup) {
        _authorArtGroup = [[NSMutableArray alloc] init];
    }
    return _authorArtGroup;
    
}


//- (NSMutableArray *)myAttention {
//    
//    if (!_myAttention) {
//        _myAttention = [[NSMutableArray alloc] init];
//    }
//    
//    return _myAttention;
//}


//- (NSMutableArray *)myComments {
//    
//    if (!_myComments) {
//        _myComments = [NSMutableArray alloc]
//    }
//}









@end
