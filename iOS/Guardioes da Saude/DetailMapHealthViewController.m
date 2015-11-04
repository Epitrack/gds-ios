//
//  DetailMapHealthViewController.m
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 30/10/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "DetailMapHealthViewController.h"
#import "AFNetworking/AFNetworking.h"
#import "DetailMap.h"
#import "MapHealthViewController.h"

@interface DetailMapHealthViewController () {
    
    DetailMap *detailMap;
}
@end

@implementation DetailMapHealthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    detailMap = [DetailMap getInstance];
    
    self.txtCity.text = detailMap.city;
    self.txtState.text = [self getStateDescription:detailMap.state];
    self.txtCountParticipation.text = detailMap.totalSurvey;
    self.txtPercentGood.text = detailMap.goodPercent;
    self.txtPercentBad.text = detailMap.badPercent;
    self.txtCountGood.text = detailMap.totalNoSymptom;
    self.txtCountBad.text = detailMap.totalWithSymptom;
    self.progressViewDiarreica.progress = ([detailMap.diarreica doubleValue] / 100);
    self.progressViewExantematica.progress = ([detailMap.exantemaica doubleValue] / 100);
    self.progessViewRespiratoria.progress = ([detailMap.respiratoria doubleValue] / 100);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(id) getStateDescription:(NSString *) uf {
    
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
        stateDiscription = @"Pará";
    } else if ([uf isEqualToString:@"PB"]) {
        stateDiscription = @"Paraiba";
    } else if ([uf isEqualToString:@"PA"]) {
        stateDiscription = @"Paraná";
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