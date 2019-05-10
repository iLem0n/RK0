//
//  ReadFotoView.swift
//
//  RK01
//
//  Created by iLem0n on 10.05.19.
//  Copyright © 2019 Peter Christian Glade. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

protocol ReadFotoView: BaseViewType {
    var viewModel: ReadFotoViewModelType? { get set }
}
