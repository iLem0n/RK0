//
//  Scan_ViewModel.swift
//  FridgeWatchTests
//
//  Created by iLem0n on 07.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import XCTest

@testable import FridgeWatch
@testable import RxSwift

class Scan_ViewModelTest: XCTestCase {

    var viewModel: NewScan_ViewModel?
    
    override func setUp() {
        viewModel = NewScan_ViewModel()
    }

    override func tearDown() {
        viewModel?.resetScanData()
    }

    func testAmountChanges() {
        guard let viewModel = viewModel else { XCTFail(); return }
        guard let subjectValue = try? viewModel.amountSubject.value() else { XCTFail(); return }
//
//
//
    }
}
