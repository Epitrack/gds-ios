//
//  Question.swift
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 5/3/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

import UIKit

class Question: NSObject {
    var id: String?
    var question: String?
    var alternatives: [QuestionAnswer] = []
}
