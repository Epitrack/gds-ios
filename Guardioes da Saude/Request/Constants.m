#import "Constants.h"

NSString * const Url = @"https://api.guardioesdasaude.org";

@implementation Constants

+ (NSArray *) getGenders{
    return @[@"Masculino", @"Feminino"];
}

+ (NSArray *) getRaces{
    return @[@"Branco", @"Preto", @"Pardo", @"Amarelo", @"Indigena"];
}

@end
