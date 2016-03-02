#import "Constants.h"

NSString * const Url = @"https://api.guardioesdasaude.org";
//NSString * const Url = @"https://rest.guardioesdasaude.org";

@implementation Constants

+ (NSArray *) getGenders{
    return @[@"Masculino", @"Feminino"];
}

+ (NSArray *) getRaces{
    return @[@"Branco", @"Preto", @"Pardo", @"Amarelo", @"Indigena"];
}

@end
