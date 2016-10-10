#import "Constants.h"



@implementation Constants

NSString *const kCurrentLanguage = @"current_language";

+ (NSArray *) getGenders{
    return @[NSLocalizedString(@"masculino", @""), NSLocalizedString(@"feminino", @"")];
}

+ (NSArray *) getRaces{
    return @[NSLocalizedString(@"branco", @""),
             NSLocalizedString(@"preto", @""),
             NSLocalizedString(@"pardo", @""),
             NSLocalizedString(@"amarelo", @""),
             NSLocalizedString(@"indigena", @"")];
}

+ (NSArray *)getPerfis{
    return @[NSLocalizedString(@"sign_up_details.perfil_athlete", @""),
             NSLocalizedString(@"sign_up_details.perfil_worker", @""),
             NSLocalizedString(@"sign_up_details.perfil_fan", @"")];
}

@end
