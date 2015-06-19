//
//  PlaceInfo.h
//  DayOutApp
//
//  Created by Swetha RK on 11/6/14.
//  Copyright (c) 2014 Swetha RK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PlaceInfo : NSObject
@property (nonatomic, copy) NSString *placeName;
@property (nonatomic, copy) NSString *fromLocation;
@property (nonatomic, copy) NSString *placeAddress;
@property (nonatomic, assign) int estimatedExpense;
@property (nonatomic, assign) double placeLatValue;
@property (nonatomic, assign) double placeLongValue;
@property (nonatomic, copy) UIImage *placeImage;
@end
