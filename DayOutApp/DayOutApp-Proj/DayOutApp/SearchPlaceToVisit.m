//
//  SearchPlaceToVisit.m
//  DayOutApp
//
//  Created by Swetha RK on 11/7/14.
//  Copyright (c) 2014 Swetha RK. All rights reserved.
//

#import "SearchPlaceToVisit.h"
#import "DisplaySearchedPlaces.h"
#import <Parse/Parse.h>
#import "PlaceInfo.h"

@interface SearchPlaceToVisit ()

// Static array of places search result
-(NSMutableArray*) _searchResults;

@end


@implementation SearchPlaceToVisit

BOOL status = YES;

// static array initialization
-(NSMutableArray*) _searchResults
{
    static NSMutableArray* theArray = nil;
    if (theArray == nil)
    {
        theArray = [[NSMutableArray alloc] init];
    }
    return theArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Testing SearchPlaceToVisit:viewDidLoad");
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"Testing SearchPlaceToVisit:viewDidAppear");
    
    status = YES; // reset status var

    unsigned long count = [self._searchResults count];
    NSLog(@"Testing SearchPlaceToVisit:viewDidAppear %ld", count);
    if(count != 0 )
    {
        NSLog(@"Testing SearchPlaceToVisit:viewDidAppear-remove");
        [self._searchResults removeAllObjects];
    }
    
}

// Method not used for now.
-(void)searchParseDB:(NSString *)locationInput budget:(NSNumber*)budget{
  
    NSLog(@"Testing searchParseDB");

    PFQuery *query = [PFQuery queryWithClassName:@"SFAttraction"];
    int budgetNum = [budget intValue];
    [query whereKey:@"perdayExpenses" lessThan:@(budgetNum)];
    //NSArray *placeEntryArray = [query findObjects];

    [query findObjectsInBackgroundWithBlock:^(NSArray *placeEntryArray, NSError *error) {
   
        unsigned long count = [placeEntryArray count];
        
        for(int i = 0; i < count; i++)
        {
            int budgetFromParse = [[placeEntryArray[i] objectForKey:@"perdayExpenses"] intValue];
            NSString *placeNameFromParse = placeEntryArray[i][@"placeName"];
            NSString *placeAddressFromParse = placeEntryArray[i][@"placeAddress"];
        
            NSLog(@"budgetFromParse %d", budgetFromParse);
            NSLog(@"placeNameFromParse %@", placeNameFromParse);
            
            NSLog(@"===============");
            
            PlaceInfo *entry = [[PlaceInfo alloc]init] ;
            entry.placeName = placeNameFromParse;
            entry.placeAddress = placeAddressFromParse;
            entry.estimatedExpense =budgetFromParse;

            [[self _searchResults] addObject:entry];
            
            NSLog(@" Length of _searchResults array %u", (unsigned int)[[self _searchResults] count]);
        }
        
    }];
    
    NSLog(@"Testing searchParseDB end");
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
   
    NSLog(@"shouldPerformSegueWithIdentifier: %@", identifier);
    
    NSString *fromLocationStr = [[ self currentPlace] text];
    NSString *budgetStr = [[ self userBudget] text];
    
    if([fromLocationStr isEqualToString:@""] || [budgetStr isEqualToString:@""])
    {
        NSLog(@"Error: No input entered on Search");
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter your input " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil ];
        [alert show];

        status = NO;
        
        return NO;
    }
    else
    {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:fromLocationStr completionHandler:^(NSArray *placemarks, NSError *error) {
            
            //Error checking
            if(error)
            {
                NSLog(@"Geocode failed with error for location %@:%@", fromLocationStr, error);
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid location input " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil ];
                
                [alert show];
                
                status = NO;
                
                return;
            }
            status = YES;
        }];
        
        NSLog(@"shouldPerformSegueWithIdentifier: return status %id", status);
        return status;
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSLog(@"prepareForSegue: %@", segue.identifier);
    if([segue.identifier isEqualToString:@"searchSegue"])
    {
        NSLog(@"Testing searchSegue");
        
        NSString *fromLocationStr = [[ self currentPlace] text];
        NSString *budgetStr = [[ self userBudget] text];
        NSNumber *budgetNum = @([budgetStr intValue]);
        
        NSLog(@"currentLocationStr: %@", fromLocationStr);
        NSLog(@"budgetNum: %@", budgetNum);
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:fromLocationStr completionHandler:^(NSArray *placemarks, NSError *error) {
            
            //Error checking
            if(error)
            {
                NSLog(@"Geocode failed with error:%@", error);
                return;
            }
            
            
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            CLLocationCoordinate2D sourceCoordinate;
            sourceCoordinate = placemark.location.coordinate;
            NSLog(@" fromLocation lat:%f, long:%f", sourceCoordinate.latitude, sourceCoordinate.longitude);
            
            PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:sourceCoordinate.latitude longitude:sourceCoordinate.longitude];
            
            PFQuery *query = [PFQuery queryWithClassName:@"SFAttraction"];
            int budgetNum1 = [budgetNum intValue]; // convert NSNumber to int type
        
            [query whereKey:@"perdayExpenses" lessThanOrEqualTo:@(budgetNum1)];
            [query whereKey:@"placeGeoPoint" nearGeoPoint:point withinMiles:200];
             query.limit = 15;
            [query findObjectsInBackgroundWithBlock:^(NSArray *placeEntryArray, NSError *error) {
            
            unsigned long count = [placeEntryArray count];
            
            for(int i = 0; i < count; i++)
            {
                NSString *placeNameFromParse = placeEntryArray[i][@"placeName"];
                NSString *placeAddressFromParse = placeEntryArray[i][@"placeAddress"];
                PFGeoPoint *placeGeoPt = placeEntryArray[i][@"placeGeoPoint"];
                int budgetFromParse = [[placeEntryArray[i] objectForKey:@"perdayExpenses"] intValue];
                
                NSLog(@"budgetFromParse %d", budgetFromParse);
                NSLog(@"placeNameFromParse %@", placeNameFromParse);
                NSLog(@"placeAddressFromParse %@", placeAddressFromParse);
                
                NSLog(@"=============== %d", i);
                
                PlaceInfo *entry = [[PlaceInfo alloc]init] ;
                // store the location entered by the user in the searchResult list entry too.
                entry.fromLocation = [[ self currentPlace] text];
                entry.placeName = placeNameFromParse;
                entry.estimatedExpense =budgetFromParse;
                entry.placeAddress=placeAddressFromParse;
                entry.placeLatValue = placeGeoPt.latitude;
                entry.placeLongValue = placeGeoPt.longitude;
                
                
                PFFile *imageFile = [placeEntryArray[i] objectForKey:@"placeImage"];
                [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error) {
                        UIImage *image = [UIImage imageWithData:data];
                        entry.placeImage = image;
                        
                        NSLog(@"===============testingimage %d", i);
                        NSLog(@"===============testingimage %@", entry);
                        
                        [[self _searchResults] addObject:entry];
                    
                        if ( i == count-1)
                            dispatch_async(dispatch_get_main_queue(), ^{
                            
                                DisplaySearchedPlaces *tableCtrlr = [segue destinationViewController];
                                tableCtrlr.placesArray = [self _searchResults];
                                [tableCtrlr.tableView reloadData];
                        });
                    }
                }];
            }
            
            NSLog(@" Length of _searchResults array000 %u", (unsigned int)[[self _searchResults] count]);
            
        }];
            
     }]; // end of geocoder:completeHandler
        
    } // end of if segue.identifier
}


@end
