//
//  Info_ViewModel.swift
//
//  FridgeWatch
//
//  Created by iLem0n on 20.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.

import Foundation
import RxSwift
import RxDataSources

final class Info_ViewModel: NSObject, Info_ViewModelType {
    let message = PublishSubject<Message>()
    
    lazy var appVersion = self.appVersionSubject.asObservable()
    private let appVersionSubject = BehaviorSubject<String>(value: "--")
    
    lazy var sections: Observable<[Info_SectionModel]> = self.sectionsSubject.asObservable()
    private let sectionsSubject = BehaviorSubject<[Info_SectionModel]>(value: [Info_SectionModel(header: "", items: [], footer: "Fetching Licenses ...")])
    
    var tableDataSource: RxTableViewSectionedReloadDataSource<Info_SectionModel>!
    
    override init() {
        super.init()
        
        if let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String {
            appVersionSubject.onNext(appVersion)
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let strong = self else { return }
            let licenses = strong.encodeLicenseFile()
            strong.sectionsSubject.onNext(licenses.map({ Info_SectionModel(header: $0.title, items: [$0], footer: "") }))
        }
    }
    
    func encodeLicenseFile() -> [Licenses.License] {
        do {
            let data = try Data(resource: R.file.licensesJson)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            
            let licenses = try decoder.decode(Licenses.self, from: data)
            licenses.licences.forEach { $0.fetchLicenseText() }
            return licenses.licences
        } catch (let error) {
            log.error(error)
            return []
        }
    }
    
    func item(at indexPath: IndexPath) -> Info_SectionModel.Item? {
        guard let sections = try? self.sectionsSubject.value(),
            indexPath.section < sections.count,
            indexPath.row < sections[indexPath.section].items.count
            else { return nil }
        
        return sections[indexPath.section].items[indexPath.row]
    }
}
