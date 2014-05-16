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
    Beacon *beacon2 = [[Beacon alloc] init];
    Beacon *beacon3 = [[Beacon alloc] init];
    Beacon *beacon4 = [[Beacon alloc] init];
    
    NSDate *today = [NSDate date];
    
    beacon1.beaconId = @"BCC6A5A8-26D7-4A6B-8F3E-6BB3984546E4";
    beacon1.shopId = [NSNumber numberWithInteger:1];
    beacon1.shopName = @"Tankers";
    beacon1.latitude = [NSNumber numberWithFloat:37.478262];
    beacon1.longitude = [NSNumber numberWithFloat:126.954193];
    beacon1.lastScanTime = [today dateByAddingTimeInterval:-604800.0];
    
    beacon2.beaconId = @"00283D84-F86F-4568-A249-4FC60B15B57E";
    beacon2.shopId = [NSNumber numberWithInteger:2];
    beacon2.shopName = @"UNIQLO 서울대입구역점";
    beacon2.latitude = [NSNumber numberWithFloat:37.478262];
    beacon2.longitude = [NSNumber numberWithFloat:126.954193];
    beacon2.lastScanTime = [today dateByAddingTimeInterval:-85400.0];
    
    beacon3.beaconId = @"D40AF3EB-7EC3-4B8D-A235-C9846F35D04B";
    beacon3.shopId = [NSNumber numberWithInteger:3];
    beacon3.shopName = @"Olive YOUNG 낙성대역점";
    beacon3.latitude = [NSNumber numberWithFloat:37.478262];
    beacon3.longitude = [NSNumber numberWithFloat:126.954193];
    beacon3.lastScanTime = [today dateByAddingTimeInterval:-1209600.0];
    
    beacon4.beaconId = @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0";
    beacon4.shopId = [NSNumber numberWithInteger:4];
    beacon4.shopName = @"Hwang Mac";
    beacon4.latitude = [NSNumber numberWithFloat:37.478262];
    beacon4.longitude = [NSNumber numberWithFloat:126.954193];
    beacon4.lastScanTime = [today dateByAddingTimeInterval:-1209600.0];
    
    [self addObjectWithObject:beacon1];
    [self addObjectWithObject:beacon2];
    [self addObjectWithObject:beacon3];
    [self addObjectWithObject:beacon4];
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
            theBeacon.lastScanTime = now;
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
    
//    NSLog(@"did check beacon %d", [objects count]);
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
