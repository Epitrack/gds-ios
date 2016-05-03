//
//  QuestionRequester.swift
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 5/3/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

import UIKit


class QuestionRequester {
    

    func getQuestion() -> Question {
        let question = Question()
        question.question = "Qual tipo de micro-organismo é responsável pela dengue?"
        
        let answer1 = QuestionAnswer()
        answer1.isCorrect = true
        answer1.answer = "Vírus"
        let answer2 = QuestionAnswer()
        answer2.answer = "Bactéria"
        let answer3 = QuestionAnswer()
        answer3.answer = "Fungo"
        
        question.answers = [answer1, answer2, answer3]
        
        return question
    }
}
