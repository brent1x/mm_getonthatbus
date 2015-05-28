//
//  DetailsViewController.m
//  GetOnThatBus
//
//  Created by Brent Dady on 5/27/15.
//  Copyright (c) 2015 Brent Dady. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *routesLabel;
@property (weak, nonatomic) IBOutlet UILabel *transfersLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    for (NSDictionary *dict in self.busArray) {
        NSString *titleCheck = [dict objectForKey:@"cta_stop_name"];

        if ([self.mkPointAnnotation.title isEqualToString:titleCheck]) {
            self.navigationItem.title = self.mkPointAnnotation.title;
            self.routesLabel.text = [dict objectForKey:@"routes"];
            if ([[dict objectForKey:@"inter_modal"] length] > 0) {
                self.transfersLabel.text = [dict objectForKey:@"inter_modal"];
            } else {
                self.transfersLabel.hidden = true;
            }

            CLGeocoder *geocoder = [CLGeocoder new];
            CLLocation *location = [[CLLocation alloc] initWithLatitude:self.mkPointAnnotation.coordinate.latitude longitude:self.mkPointAnnotation.coordinate.longitude];

            [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
                CLPlacemark *placemark = [placemarks lastObject];
                self.addressLabel.text = [NSString stringWithFormat:@"%@, %@", placemark.thoroughfare, placemark.subThoroughfare];
            }];
        }
    }

}


@end
