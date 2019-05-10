//
//  Question.swift
//  RK01
//
//  Created by iLem0n on 10.05.19.
//  Copyright © 2019 Peter Christian Glade. All rights reserved.
//

import Foundation
import Freddy

struct Question {
    let id: String
    let anwserType: AnswerKind
    let abbruch: Bool
    let ifYes: String?
    let ifNo: String?
    let frage: String
    
    init(json: JSON) {
        self.id = try! json.getString(at: "id")
        self.anwserType = AnswerKind(rawValue: try! json.getString(at: "answerType"))!
        self.abbruch = try! json.getBool(at: "abbruch")
        self.ifNo = try? json.getString(at: "ifNo")
        self.ifYes = try? json.getString(at: "ifYes")
        self.frage = try! json.getString(at: "frage")
    }
}
