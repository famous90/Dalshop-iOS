//
//  BeaconDataController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 3. 19..
//
//
//#import "AppDelegate.h"

#import "BeaconDataController.h"
#import "Beacon.h"

@interface BeaconDataController ()

//@property (nonatomic, weak) AppDelegate *appDelegate;

@end

@implementation BeaconDataController

- (void)initForTest{
    
    Beacon *beacon1 = [[Beacon alloc] init];
    
    NSDate *today = [NSDate date];
    
    beacon1.beaconId = @"BCC6A5A8-26D7-4A6B-8F3E-6BB3984546E4";
    beacon1.shopId = [NSNumber numberWithInteger:9090];
    beacon1.shopName = @"Gyuyoung's Home";
    beacon1.latitude = [NSNumber numberWithFloat:37.52435];
    beacon1.longitude = [NSNumber numberWithFloat:126.9553];
    beacon1.lastScanTime = [today dateByAddingTimeInterval:-604800.0];
    
    [self addObjectWithObject:beacon1];
}

- (NSArray *)scannableBeaconList
{
    NSDate *now = [NSDate date];
    NSDate *canScanLastTime = [now dateByAddingTimeInterval:(-1)*BEACON_COOL_TIME];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"lastScanTime < %@", canScanLastTime];
    NSArray *dataSet = [[NSArray alloc] initWithArray:self.masterData];
    return [dataSet filteredArrayUsingPredicate:resultPredicate];
}

- (Beacon *)didScanBeaconWithBeaconId:(NSString *)beaconId
{
    for (int i=0; i<[self.masterData count]; i++) {
        Beacon *theBeacon = (Beacon *)[self.masterData objectAtIndex:i];
        if ([theBeacon.beaconId isEqualToString:beaconId]) {
            NSDate *now = [NSDate date];
            NSLog(@"%@",theBeacon.lastScanTime);
            theBeacon.lastScanTime = now;
            NSLog(@"%@",theBeacon.lastScanTime);
            [self didCheckInBeacon:theBeacon];
            return theBeacon;
        }
    }
    return nil;
}

- (void)didCheckInBeacon:(Beacon *)beacon
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"BeaconList" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"beaconId LIKE[c] %@", beacon.beaconId];
    [request setPredicate:predicate];
    NSManagedObject *matches = nil;

    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    if ([objects count]) {
        matches = [objects objectAtIndex:0];
        
        [matches setValue:beacon.lastScanTime forKey:@"lastScanTime"];
    }
    
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }

    NSLog(@"beacon scanned");
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"BeaconList"];
    NSMutableArray *beaconList = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    for(NSManagedObject *beaconInList in beaconList){
        NSLog(@"after checkin, beacon in core data %@ last detect time %@", [beaconInList valueForKey:@"beaconId"], [beaconInList valueForKey:@"lastScanTime"]);
    }
}

#pragma mark - 
#pragma mark core data
- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
