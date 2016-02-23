#import <JSONModel/JSONModel.h>

@interface SumaryGraph : JSONModel

@property (nonatomic, assign) int month;
@property (nonatomic, assign) int year;
@property (nonatomic, assign) int count;
@property (nonatomic, assign) float percent;

@end
