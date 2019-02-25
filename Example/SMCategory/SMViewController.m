//
//  SMViewController.m
//  SMCategory
//
//  Created by simon on 02/24/2019.
//  Copyright (c) 2019 simon. All rights reserved.
//

#import "SMViewController.h"
#import "NSArray+SMRange.h"

@interface SMViewController ()

@end

@implementation SMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@1, @2, nil];
    id re = [array instanceAtIndex:2];
    NSLog(@"--%@",re);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
