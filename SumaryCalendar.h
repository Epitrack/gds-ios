#import <JSONModel/JSONModel.h>

@interface SumaryCalendar : JSONModel

@property (nonatomic, assign) int day;
@property (nonatomic, assign) int month;
@property (nonatomic, assign) int year;
@property (nonatomic, assign) int noSymptomAmount;
@property (nonatomic, assign) int symptomAmount;

@end
