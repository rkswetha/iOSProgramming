//
//  DisplayLocationDetails.m
//  DayOutApp
//
//  Created by Swetha RK on 11/8/14.
//  Copyright (c) 2014 Swetha RK. All rights reserved.
//

#import <CoreLocation/CLLocationManagerDelegate.h>
#import "DisplayLocationDetails.h"

@interface DisplayLocationDetails ()

@end

@implementation DisplayLocationDetails
CLLocationCoordinate2D sourceCoordinate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = _selectedPlaceNameText;
    
    NSLog(@"fromLocationText %@",_fromLocationText);
    NSLog(@"selectedPlaceNameText %@",_selectedPlaceNameText);
    NSLog(@"selectedPlaceExpenseText %@",_selectedPlaceExpenseText);
    NSLog(@"selectedPlaceAddress %@",_selectedPlaceAddress);

    
    NSString *weatherURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@", _selectedPlaceAddress];
    NSString *newweatherURL =[weatherURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",newweatherURL);
    NSURL *url = [NSURL URLWithString:newweatherURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         NSLog(@"response arrived : %@",data);
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *greeting = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:NULL];
             NSLog(@"%@",greeting);
             NSLog(@"%@",[greeting objectForKey:@"base"]);
             NSLog(@"%@",[greeting objectForKey:@"name"]);
             NSLog(@"%@",[greeting objectForKey:@"weather"]);
             NSString *weather = [greeting objectForKey:@"weather"];
             NSLog(@"%@",weather);
             
             NSDictionary *main = [greeting objectForKey:@"main"];
             NSLog(@"%@",main);
             NSLog(@"%@",[main objectForKey:@"humidity"]);
             
             NSDictionary *coord = [greeting objectForKey:@"coord"];
             NSDictionary *wind = [greeting objectForKey:@"wind"];
             
             
             self.placeImage.backgroundColor = [UIColor blackColor];
             self.placeImage.clipsToBounds = YES;
             self.placeImage.image = _placeImageFile;
             
             self.selectedPlaceName.text = _selectedPlaceNameText;
             self.selectedPlaceExpense.text = [@"$" stringByAppendingString:_selectedPlaceExpenseText];
             
             // First convert Kelvin value toFahr and then append the resulting string value with '/'
             NSString *tempMax = [ [self convertKelvinToFarenheit:[[main objectForKey:@"temp_max"]stringValue]] stringByAppendingString:@"/"];
             NSString *displayMaxMinTemp = [ tempMax stringByAppendingString:[self convertKelvinToFarenheit:[[main objectForKey:@"temp_min"]stringValue]] ];
             
             
             //NSString *tempMax = [ [[main objectForKey:@"temp_max"]stringValue] stringByAppendingString:@"/"];
             //NSString *displayMaxMinTemp = [ tempMax stringByAppendingString:[ [main objectForKey:@"temp_min"]stringValue] ];
             
             NSLog(@"min max %@", displayMaxMinTemp);
             
             NSString *latitude = [ [[coord objectForKey:@"lat"]stringValue] stringByAppendingString:@"/"];
             NSString *longitude = [ [[coord objectForKey:@"lon"]stringValue] stringByAppendingString:@"/"];
             
             NSLog(@"latitude - %@", latitude);
             NSLog(@"longitude - %@", longitude);

             NSString* tempStr = [[main objectForKey:@"temp"]stringValue];
             NSString* tempDouble = [self convertKelvinToFarenheit:tempStr];
             
             NSLog(@"tempStr value:%@ ,tempDouble value:%@ ", tempStr, tempDouble);
             
             self.selectedPlaceMaxMinTemp.text =
                        [displayMaxMinTemp stringByAppendingString:@" F"];
             self.selectedPlaceTemp.text = [ [self convertKelvinToFarenheit:[[main objectForKey:@"temp"]stringValue]] stringByAppendingString:@" F"];
             self.selectedPlaceHumidity.text =
                        [ [[main objectForKey:@"humidity"]stringValue] stringByAppendingString:@"%"];

             self.selectedPlaceWind.text = [ [[wind objectForKey:@"speed"]stringValue] stringByAppendingString:@"mph"];
             
         }
     }];
    
}

- (NSString*)convertKelvinToFarenheit:(NSString*)tempStr {
    
    double tempValue = [tempStr doubleValue];
    double celsiusValue = tempValue - 273.15;
    
    double fahrDouble = (celsiusValue * 9.0) / 5.0 + 32;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setUsesSignificantDigits: YES];
    numberFormatter.maximumSignificantDigits = 100;
    [numberFormatter setGroupingSeparator:@""];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
     NSString* fahrString = [numberFormatter stringFromNumber:@(fahrDouble)];

    NSLog(@"Kelvin value: %@ ,Fahr value: %@ ", tempStr, fahrString);
    
    return fahrString;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)viewMapButtonPressed:(id)sender {
    NSLog(@"viewMapButton:");
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:_fromLocationText completionHandler:^(NSArray *placemarks, NSError *error) {
   
        //Error checking
        if(error)
        {
            NSLog(@"Geocode failed with error:%@", error);
            return;
        }
    
        
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        sourceCoordinate = placemark.location.coordinate;
        NSLog(@" fromLocation lat:%f, long:%f", sourceCoordinate.latitude, sourceCoordinate.longitude);
        
    CLLocationCoordinate2D sourceCoords = CLLocationCoordinate2DMake(sourceCoordinate.latitude, sourceCoordinate.longitude);
    MKPlacemark *sourcePlacemark = [[MKPlacemark alloc] initWithCoordinate:sourceCoords addressDictionary:nil];
    MKMapItem *source = [[MKMapItem alloc] initWithPlacemark:sourcePlacemark];
    source.name= _fromLocationText;
    source.phoneNumber = @"+1-111-1111-111";
    source.url = [NSURL URLWithString:@"http://www.testme.com/"];
    
    // Make the destination
    NSString *latstring = self.selectedPlaceLatText;
    NSString *lonstring = self.selectedPlaceLongText ;
    
    double latdouble = [self convertNSStringToDouble:latstring];
    double longdouble = [self convertNSStringToDouble:lonstring];
    
    NSLog(@"latdouble %f ", latdouble);
    NSLog(@"longdouble %f ", longdouble);
    
    CLLocationCoordinate2D destinationCoords = CLLocationCoordinate2DMake(latdouble, longdouble);
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoords addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    destination.name= _selectedPlaceNameText;
    destination.phoneNumber = @"+1-222-2222-222";
    destination.url = [NSURL URLWithString:@"http://www.testme.com/"];
    
    NSArray *mapItem = @[source, destination];
    
    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
    
    [MKMapItem openMapsWithItems:mapItem launchOptions:launchOptions];

    }];

}

- (double)convertNSStringToDouble:(NSString*)strValue {
    
    double doubleVal;
    NSString * newString = [strValue substringWithRange:NSMakeRange(0, 1)];
    NSLog(@"newString %@ ", newString);
    
    if([newString isEqualToString:@"-"])
    {
        NSString *cutstring = [strValue substringFromIndex:0];
        NSLog(@"cut lat: %@", cutstring);
        
        doubleVal = [cutstring doubleValue];
        NSLog(@"doubleVal: %f", doubleVal);
    }
    else
    {
        doubleVal = [strValue doubleValue];
        NSLog(@"doubleVal else part: %f", doubleVal);
    }
    
    return doubleVal;
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    NSLog(@"prepareForSegue: %@", segue.identifier);

}


@end
