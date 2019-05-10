//
//  QuestionCoordinator.swift
//
//  RK01
//
//  Created by iLem0n on 10.05.19.
//Copyright © 2019 Peter Christian Glade. All rights reserved.

import UIKit

final class QuestionCoordinator: BaseCoordinator, QuestionCoordinatorType {
    private let router: RouterType
    private let factory: QuestionModuleFactoryType

    var logout: (() -> Void)?

    func toPresent() -> UIViewController? {
        return router.toPresent()
    }

    //  INIT
    init(router: RouterType, factory: QuestionModuleFactoryType) {
        self.router = router
        self.factory = factory

        super.init()
    }
    
    override func start() {
        self.start(questionID: "1")
    }

    func start(questionID: String) {
        self.showAskQuestion(questionID: questionID)
    }
    
    private func showAskQuestion(questionID: String) {
        let model = QuestionViewModel(questionID: questionID)
        let module = factory.makeQuestionModule(viewModel: model)
        
        self.router.setRootModule(module)
    }
}
