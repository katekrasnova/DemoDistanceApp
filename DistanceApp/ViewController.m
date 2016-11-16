//
//  ViewController.m
//  DistanceApp
//
//  Created by Екатерина Краснова on 12.12.15.
//  Copyright © 2015 Kate Krasnova. All rights reserved.
//

#import "ViewController.h"
#import "DistanceGetter/DGDistanceRequest.h"

@interface ViewController ()

@property (nonatomic) DGDistanceRequest *req;

@property (weak, nonatomic) IBOutlet UITextField *startLocation;

@property (weak, nonatomic) IBOutlet UITextField *endLocationA;
@property (weak, nonatomic) IBOutlet UILabel *distanceA;

@property (weak, nonatomic) IBOutlet UITextField *endLocationB;
@property (weak, nonatomic) IBOutlet UILabel *distanceB;

@property (weak, nonatomic) IBOutlet UITextField *endLocationC;
@property (weak, nonatomic) IBOutlet UILabel *distanceC;

@property (weak, nonatomic) IBOutlet UIButton *calculateButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *unitController;

@end

@implementation ViewController

- (IBAction)calculateButtonTapped:(id)sender {
    self.calculateButton.enabled = NO;
    
    self.req = [DGDistanceRequest alloc];
    
    NSString *start = self.startLocation.text;
    NSString *destA = self.endLocationA.text;
    NSString *destB = self.endLocationB.text;
    NSString *destC = self.endLocationC.text;
    NSArray *dests = @[destA, destB, destC];
    
    self.req = [self.req initWithLocationDescriptions:dests sourceDescription:start];
    
    __weak ViewController *weakSelf = self;
    
    self.req.callback = ^void(NSArray *responses) {
        ViewController *strongSelf = weakSelf;
        if (!strongSelf) return;
        
        NSNull *badResult = [NSNull null];
        for (int i = 0; i < 3; ++i) {
            if (responses[i] != badResult) {
                double num;
                //= ([responses[0] floatValue]/1000.0);
                if (strongSelf.unitController.selectedSegmentIndex == 0) {
                    num = ([responses[i] floatValue]);
                }
                else if (strongSelf.unitController.selectedSegmentIndex == 1) {
                    num = ([responses[i] floatValue]/1000.0);
                }
                else {
                    num = ([responses[i] floatValue]/1609);
                }
                NSString *x = [NSString stringWithFormat:@"%.2f", num];
                NSUInteger indexRes = [responses indexOfObject:responses[i]];
                if (indexRes == 0) {
                    strongSelf.distanceA.text = x;
                }
                else if (indexRes == 1) {
                    strongSelf.distanceB.text = x;
                }
                else {
                    strongSelf.distanceC.text = x;
                }
            }
            else {
                    strongSelf.distanceA.text = @"Error";
                    strongSelf.distanceB.text = @"Error";
                    strongSelf.distanceC.text = @"Error";
            }
        }
        
        strongSelf.req = nil;
        strongSelf.calculateButton.enabled = YES;
    };
    
    [self.req start];
    
}


@end
