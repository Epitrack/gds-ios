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

+ (NSString *)getCodeofPerfil: (NSString *) perfil{
    if ([perfil isEqualToString:NSLocalizedString(@"sign_up_details.perfil_athlete", @"")]) {
        return @"atleta_delegacao";
    }else if ([perfil isEqualToString:NSLocalizedString(@"sign_up_details.perfil_worker", @"")]){
        return @"trabalhador_voluntario";
    }else{
        return @"fa_espectador";
    }
}

@end
