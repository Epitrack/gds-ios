#import "Constants.h"



@implementation Constants

+ (NSArray *) getGenders{
    return @[@"Masculino", @"Feminino"];
}

+ (NSArray *) getRaces{
    return @[@"Branco", @"Preto", @"Pardo", @"Amarelo", @"Indigena"];
}

+ (NSArray *)getPerfis{
    return @[NSLocalizedString(@"sign_up_details.perfil_athlete", @""),
             NSLocalizedString(@"sign_up_details.perfil_worker", @""),
             NSLocalizedString(@"sign_up_details.perfil_fan", @"")];
}

@end
