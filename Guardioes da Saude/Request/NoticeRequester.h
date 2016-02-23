//
//  NoticeRequester.h
//  Guardioes da Saude
//
//  Created by Miqueias Lopes on 30/11/15.
//  Copyright © 2015 epitrack. All rights reserved.
//

#import "Requester.h"
#import "User.h"

@interface NoticeRequester : Requester

- (void) getNotices: (User *) user
            onStart: (Start) onStart
            onError: (Error) onError
          onSuccess: (Success) onSuccess;

@end
