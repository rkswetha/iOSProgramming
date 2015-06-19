//
//  DisplayLocationDetails.h
//  DayOutApp
//
//  Created by Swetha RK on 11/8/14.
//  Copyright (c) 2014 Swetha RK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface DisplayLocationDetails : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *placeImage;
@property (weak, nonatomic) IBOutlet UILabel *selectedPlaceName;
@property (weak, nonatomic) IBOutlet UILabel *selectedPlaceExpense;
@property (weak, nonatomic) IBOutlet UILabel *selectedPlaceTemp;
@property (weak, nonatomic) IBOutlet UILabel *selectedPlaceWind;
//@property (weak, nonatomic) IBOutlet UIButton *ViewMap;
@property (weak, nonatomic) IBOutlet UILabel *selectedPlaceHumidity;
@property (weak, nonatomic) IBOutlet UILabel *selectedPlaceMaxMinTemp;
//@property (weak, nonatomic) IBOutlet UIButton *viewMapButton;

// Below property are set from the previous view controller (DisplaySearchedPlaces.m)
@property (nonatomic, strong) NSString *fromLocationText; // From location entered at the first screen
@property (nonatomic, strong) NSString *selectedPlaceNameText; // Place selected from the list of search results table.
@property (nonatomic, strong) NSString *selectedPlaceExpenseText; // Expense or budget of the selected place name
@property (nonatomic, strong) NSString *selectedPlaceAddress; // Address of selected place on which weather and map would work.
@property (nonatomic, strong) NSString *selectedPlaceTempText; // Temperature of the selected place
@property (nonatomic, strong) UIImage *placeImageFile;
@property (nonatomic, strong) NSString *selectedPlaceLatText; // Latitude of the selected place
@property (nonatomic, strong) NSString *selectedPlaceLongText; // Longitude of the selected place


@end
