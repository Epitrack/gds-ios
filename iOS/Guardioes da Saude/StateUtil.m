//
//  StateUtil.m
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 1/3/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

#import "StateUtil.h"

@implementation StateUtil

+ (NSString *) getStateByUf: (NSString *) uf{
        
    NSString *stateDiscription;
    
    if ([uf isEqualToString:@"AC"]) {
        stateDiscription = @"Acre";
    } else if ([uf isEqualToString:@"AL"]) {
        stateDiscription = @"Alagoas";
    } else if ([uf isEqualToString:@"AP"]) {
        stateDiscription = @"Amapá";
    } else if ([uf isEqualToString:@"AM"]) {
        stateDiscription = @"Amazonas";
    } else if ([uf isEqualToString:@"BA"]) {
        stateDiscription = @"Bahia";
    } else if ([uf isEqualToString:@"CE"]) {
        stateDiscription = @"Ceará";
    } else if ([uf isEqualToString:@"DF"]) {
        stateDiscription = @"Distrito Federal";
    } else if ([uf isEqualToString:@"ES"]) {
        stateDiscription = @"Espirito Santo";
    } else if ([uf isEqualToString:@"GO"]) {
        stateDiscription = @"Goiás";
    } else if ([uf isEqualToString:@"MA"]) {
        stateDiscription = @"Maranhão";
    } else if ([uf isEqualToString:@"MT"]) {
        stateDiscription = @"Mato Grosso";
    } else if ([uf isEqualToString:@"MS"]) {
        stateDiscription = @"Mato Grosso do Sul";
    } else if ([uf isEqualToString:@"MG"]) {
        stateDiscription = @"Minas Gerais";
    } else if ([uf isEqualToString:@"PR"]) {
        stateDiscription = @"Paraná";
    } else if ([uf isEqualToString:@"PB"]) {
        stateDiscription = @"Paraiba";
    } else if ([uf isEqualToString:@"PA"]) {
        stateDiscription = @"Pará";
    } else if ([uf isEqualToString:@"PE"]) {
        stateDiscription = @"Pernambuco";
    } else if ([uf isEqualToString:@"PI"]) {
        stateDiscription = @"Piauí";
    } else if ([uf isEqualToString:@"RJ"]) {
        stateDiscription = @"Rio de Janeiro";
    } else if ([uf isEqualToString:@"RN"]) {
        stateDiscription = @"Rio Grande do Norte";
    } else if ([uf isEqualToString:@"RS"]) {
        stateDiscription = @"Rio Grande do Sul";
    } else if ([uf isEqualToString:@"RO"]) {
        stateDiscription = @"Rondônia";
    } else if ([uf isEqualToString:@"RR"]) {
        stateDiscription = @"Roraima";
    } else if ([uf isEqualToString:@"SC"]) {
        stateDiscription = @"Santa Catarina";
    } else if ([uf isEqualToString:@"SE"]) {
        stateDiscription = @"Sergipe";
    } else if ([uf isEqualToString:@"SP"]) {
        stateDiscription = @"São Paulo";
    } else if ([uf isEqualToString:@"TO"]) {
        stateDiscription = @"Tocantins";
    }
    
    return stateDiscription;
}

@end
