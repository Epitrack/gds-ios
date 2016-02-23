#import <JSONModel/JSONModel.h>

@interface SumaryLocation : JSONModel

@property (nonatomic, assign) int diarreica;
@property (nonatomic, assign) int exantematica;
@property (nonatomic, assign) int respiratoria;
@property (nonatomic, assign) NSString * state;
@property (nonatomic, assign) NSString * city;
@property (nonatomic, assign) NSString * formattedAddress;
@property (nonatomic, assign) int totalSurvey;
@property (nonatomic, assign) int totalNoSymptom;
@property (nonatomic, assign) int totalSymptom;

@end
