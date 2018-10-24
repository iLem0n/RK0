//
//  Settings_ViewModel.swift
//
//  FridgeWatch
//
//  Created by iLem0n on 18.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import Foundation
import RxSwift
import RxDataSources

enum SettingsIdentifier: DynamicCellSettingIdentifier {
    case feedbackSupport
    case info
    
    var title: String {
        switch self {
        case .feedbackSupport:  return "Feedback / Support"
        case .info:             return "Info"
        }
    }
}

final class Settings_ViewModel: NSObject, Settings_ViewModelType {
    let message = PublishSubject<Message>()
    private let disposeBag = DisposeBag()
    
    lazy var sections: Observable<[Settings_SectionModel]> = self.sectionsSubject.asObservable()
    private let sectionsSubject = BehaviorSubject<[Settings_SectionModel]>(value: [])
        
    var tableDataSource: RxTableViewSectionedReloadDataSource<Settings_SectionModel>!
    
    override init() {
        super.init()
        sectionsSubject.onNext([
            Settings_SectionModel(
                header: "About",
                items: [
                    DefaultCellSetting(identifier: SettingsIdentifier.feedbackSupport, title: SettingsIdentifier.feedbackSupport.title),
                    DefaultCellSetting(identifier: SettingsIdentifier.info, title: SettingsIdentifier.info.title)
                ],
                footer: "")
            ])
    }
    
    
    func item(at indexPath: IndexPath) -> Settings_SectionModel.Item? {
        guard let sections = try? self.sectionsSubject.value(),
            indexPath.section < sections.count,
            indexPath.row < sections[indexPath.section].items.count
            else { return nil }
        
        return sections[indexPath.section].items[indexPath.row]
    }
}
