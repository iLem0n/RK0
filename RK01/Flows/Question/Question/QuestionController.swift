//
//  QuestionController.swift
//
//  RK01
//
//  Created by iLem0n on 10.05.19.
//  Copyright © 2019 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa
import SwiftMessages

final class QuestionController: UIViewController, QuestionView {
    
    var viewModel: QuestionViewModelType?
    let disposeBag = DisposeBag()
    
    var onAnswerProvided: ((AnswerType) -> Void)?
    
    @IBOutlet var yesButton: UIButton!
    @IBOutlet var noButton: UIButton!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        linkViewModel()
    }
    
    private func linkViewModel() {
        guard let viewModel = viewModel else { fatalError("ViewModel not set.") }
        
        //  Messages
        viewModel.message
            .subscribe{
                guard let next = $0.element else { return }
                DispatchQueue.main.async {
                    SwiftMessages.show {
                        let view = MessageView.viewFromNib(layout: MessageView.Layout.messageView)
                        view.configureTheme(next.type)
                        view.configureContent(title: next.title, body: next.message)
                        view.button?.isHidden = true
                        return view
                    }
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.question.filter({ $0 != nil }).map({ $0! }).map({ $0.frage }).bind(to: descriptionTextView.rx.text).disposed(by: disposeBag)
    }
}
