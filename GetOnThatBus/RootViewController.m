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
@property NSMutableArray *annotationArray;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.busStopDictionary = [NSMutableDictionary new];
    self.busStopArray = [NSMutableArray new];
    self.annotationArray = [NSMutableArray new];

    NSURL *url = [NSURL URLWithString:@"https://s3.amazonaws.com/mobile-makers-lib/bus.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        self.busStopDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.busStopArray = [self.busStopDictionary objectForKey:@"row"];
        for (NSDictionary *dictionary in self.busStopArray) {
            [self loadBusStopDictionary:dictionary];
        }
        MKCoordinateRegion region = [self regionForAnnotations:self.annotationArray];
        [self.mapView setRegion:region animated:YES];
    }];


}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    return nil;
}

- (void)loadBusStopDictionary:(NSDictionary *)busDictionary{
    double latitude = [[busDictionary objectForKey:@"latitude"] doubleValue];
    double longitude = [[busDictionary objectForKey:@"longitude" ] doubleValue];
    if (longitude > 0) {
        longitude = longitude * -1;
    }
    MKPointAnnotation *pointAnnotation = [MKPointAnnotation new];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    pointAnnotation.title = [busDictionary objectForKey: @"cta_stop_name"];
    pointAnnotation.subtitle = [busDictionary objectForKey:@"routes"];
    [self.annotationArray addObject:pointAnnotation];
    [self.mapView addAnnotation:pointAnnotation];
}

- (MKCoordinateRegion)regionForAnnotations:(NSArray *)annotations {
    double minimumLatitude = 90.0f, maximumLatitude = -90.0f;
    double minimumLongitude = 180.0f, maximumLongitude = -180.0f;

    for (id<MKAnnotation>annotation in annotations) {
        if ( annotation.coordinate.latitude  < minimumLatitude ) minimumLatitude = annotation.coordinate.latitude;
        if ( annotation.coordinate.latitude  > maximumLatitude ) maximumLatitude = annotation.coordinate.latitude;
        if ( annotation.coordinate.longitude < minimumLongitude ) minimumLongitude = annotation.coordinate.longitude;
        if ( annotation.coordinate.longitude > maximumLongitude ) maximumLongitude = annotation.coordinate.longitude;
    }

    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(((minimumLatitude + maximumLatitude)/2.0), ((minimumLongitude + maximumLongitude)/2.0));
    MKCoordinateSpan span = MKCoordinateSpanMake((maximumLatitude - minimumLatitude), (maximumLongitude - minimumLongitude));
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    return region;
}

@end
