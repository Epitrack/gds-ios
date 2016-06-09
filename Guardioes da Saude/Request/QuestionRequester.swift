//
//  QuestionRequester.swift
//  Guardioes da Saude
//
//  Created by Douglas Queiroz on 5/3/16.
//  Copyright © 2016 epitrack. All rights reserved.
//

import UIKit


class QuestionRequester: Requester {
    

    func getQuestion(currentLanguage: String, onStart: (()-> Void), onSuccess: (([Question]) -> Void), onError: ((NSError?) -> Void)) {
        
        doGet(getUrl()+"/game/questions/", header: nil, parameter: ["lang": currentLanguage], start: onStart, error: {operation, error in
                onError(error)
            }, success: {operation, response in
                if response.count == 0 {
                    onError(nil)
                }else{
                    var questions: [Question] = []
                    
//                    let dicResponse = response as! Dictionary<String, AnyObject>
                    let jQuestions = response as! [Dictionary<String, AnyObject>]
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
                }
        })
    }
    
    func getRanking(onStart: (() -> Void), onSuccess: (([RankingItem]) -> Void), onError: ((NSError) -> Void)) {
        doGet(getUrl()+"/game/ranking/",
              header: nil,
              parameter: nil,
              start: onStart,
              error: {operation, error in
            onError(error)
        }, success: {operation, response in
            let jRankingArr = response as! [Dictionary<String, AnyObject>]
            var rankings: [RankingItem] = []
            
            for jRanking in jRankingArr{
                let ranking = RankingItem()
                ranking.country = jRanking["country"] as? String
                ranking.position = jRanking["position"] as? Int
                ranking.flagUrl = jRanking["flagUrl"] as? String
                
                rankings.append(ranking)
            }
            
            onSuccess(rankings)
        })
    }
}
