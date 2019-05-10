//
//  QuestionViewModel.swift
//
//  RK01
//
//  Created by iLem0n on 10.05.19.
//  Copyright © 2019 Peter Christian Glade. All rights reserved.

import Foundation
import RxSwift
import Freddy

final class QuestionViewModel: NSObject, QuestionViewModelType {
    let message = PublishSubject<Message>()
    
    lazy var question: Observable<Question?> = self.questionSubject.asObservable()
    private let questionSubject = BehaviorSubject<Question?>(value: nil)
    
    init(questionID: String) {
        guard let json = try? JSON(data: try! Data(resource: R.file.liste_fragenJson)),
            let questions = try? json.getArray(at: "questions")
        else { fatalError("IUnable to find Question  with ID: \(questionID)") }
        
        let question = questions.map({ Question(json: $0) }).filter({ try! $0.id == questionID })[0]
        questionSubject.onNext(question)
    }
}
