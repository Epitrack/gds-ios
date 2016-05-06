//
//  QuestionRequester.swift
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 5/3/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

import UIKit


class QuestionRequester: Requester {
    

    func getQuestion(onStart: (()-> Void), onSuccess: (([Question]) -> Void), onError: ((NSError) -> Void)) {
        
        doGet(getUrl()+"/game/questions/?lang=pt_BR", header: nil, parameter: nil, start: onStart, error: {operation, error in
                onError(error)
            }, success: {operation, response in
                var questions: [Question] = []
                
                let dicResponse = response as! Dictionary<String, AnyObject>
                let jQuestions = dicResponse["questions"] as! [Dictionary<String, AnyObject>]
                for jQuestion in jQuestions {
                    let question = Question()
                    question.question = jQuestion["title"] as? String
                    let jAlternatives = jQuestion["alternatives"] as! [Dictionary<String, AnyObject>]
                    for jAlternative in jAlternatives{
                        let alternative = QuestionAnswer()
                        alternative.answer = jAlternative["option"] as? String
                        alternative.isCorrect = jAlternative["correct"] as! Bool
                        question.alternatives.append(alternative)
                    }
                    
                    questions.append(question)
                }
                
                onSuccess(questions)
        })
    }
}
