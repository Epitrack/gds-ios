//
// Created by João Guilherme on 11/23/15.
// Copyright (c) 2015 epitrack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface MapPinAnnotation : MKPointAnnotation <MKAnnotation>
    @property(nonatomic, copy) NSString *isSymptom;
    @property(nonatomic, copy) NSString *survey_id;
@end