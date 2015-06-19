//
//  DisplaySearchedPlaces.m
//  DayOutApp
//
//  Created by Swetha RK on 11/5/14.
//  Copyright (c) 2014 Swetha RK. All rights reserved.
//

#import "DisplaySearchedPlaces.h"
#import "DisplayLocationDetails.h"
#import "PlaceInfo.h"

@interface DisplaySearchedPlaces ()

@end

@implementation DisplaySearchedPlaces

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%u", (unsigned int)[self.placesArray count]);

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"%s", "numberOfRowsInSection");
    NSLog(@"%u", (unsigned int)[self.placesArray count]);
    return [self.placesArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    // Configure the cell...
    NSLog(@"%s", "cellForRowAtIndexPath");
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceListEntry"];
    
    PlaceInfo *entry = (self.placesArray)[indexPath.row];
    cell.textLabel.text = entry.placeName;
    NSString *displaySubTitle = @"approx Expense: $";
    NSString *expenseValueStr = [@(entry.estimatedExpense) stringValue];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.text = [displaySubTitle stringByAppendingString:expenseValueStr];
    
    UIView *myView = [[UIView alloc] init];
    myView.backgroundColor = [UIColor redColor];
    cell.backgroundView = myView;
    
    return cell;
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSLog(@"prepareForSegue: %@", segue.identifier);
    
    if([segue.identifier isEqualToString:@"displayPlaceDetails"])
    {
        NSLog(@"Testing segue- displayPlaceDetails");

        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        PlaceInfo *placeToSend = [self.placesArray objectAtIndex:path.row];
        DisplayLocationDetails *details = [segue destinationViewController];
     
        details.fromLocationText = placeToSend.fromLocation;
        details.selectedPlaceNameText = placeToSend.placeName;
        details.selectedPlaceExpenseText = [@(placeToSend.estimatedExpense) stringValue];
        details.placeImageFile = placeToSend.placeImage;
        details.selectedPlaceAddress = placeToSend.placeAddress;
        details.selectedPlaceTempText = @"50"; // Dummy temperature value
        
        NSNumber *myLatDouble = [NSNumber numberWithDouble:placeToSend.placeLatValue];
        NSNumber *myLongDouble = [NSNumber numberWithDouble:placeToSend.placeLongValue];

        details.selectedPlaceLatText = [myLatDouble stringValue];
        details.selectedPlaceLongText = [myLongDouble stringValue];
        
        NSLog(@"details.selectedPlaceLatText: %@", details.selectedPlaceLatText);
        NSLog(@"details.selectedPlaceLongText: %@", details.selectedPlaceLongText);

        
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


@end
