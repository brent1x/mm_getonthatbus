//
//  ViewController.m
//  GetOnThatBus
//
//  Created by Brent Dady on 5/27/15.
//  Copyright (c) 2015 Brent Dady. All rights reserved.
//

#import "RootViewController.h"
#import <MapKit/MapKit.h>

@interface RootViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property NSMutableDictionary *busStopDictionary;
@property NSMutableArray *busStopArray;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.busStopDictionary = [NSMutableDictionary new];
    self.busStopArray = [NSMutableArray new];

    NSURL *url = [NSURL URLWithString:@"https://s3.amazonaws.com/mobile-makers-lib/bus.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        self.busStopDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.busStopArray = [self.busStopDictionary objectForKey:@"row"];
        // NSLog(@"%@", self.busStopArray);

        for (NSDictionary *dictionary in self.busStopArray) {
            [self loadBusStopDictionary:dictionary];
        }
    }];
}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    return nil;
}

// Helper method
-(void)loadBusStopDictionary:(NSDictionary *)busDictionary
{
    double latitude = [[busDictionary objectForKey:@"latitude"] doubleValue];
    double longitude = [[busDictionary objectForKey:@"longitude" ] doubleValue];
    MKPointAnnotation *pointAnnotation = [MKPointAnnotation new];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    pointAnnotation.title = [busDictionary objectForKey: @"cta_stop_name"];
    pointAnnotation.subtitle = [busDictionary objectForKey:@"routes"];
    // NSLog(@"%@", pointAnnotation);

    [self.mapView addAnnotation:pointAnnotation];
}


@end
