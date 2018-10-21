//
//  CellFactory.swift
//  FoodWatch
//
//  Created by Peter Christian Glade on 29.04.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit

final class CellFactory {
    static func prepare(tableView: UITableView) {
        tableView.register(R.nib.defaultCell(), forCellReuseIdentifier: R.reuseIdentifier.defaultCell.identifier)
        tableView.register(R.nib.detailedCell(), forCellReuseIdentifier: R.reuseIdentifier.detailedCell.identifier)
        tableView.register(R.nib.booleanCell(), forCellReuseIdentifier: R.reuseIdentifier.booleanCell.identifier)
        tableView.register(R.nib.textCell(), forCellReuseIdentifier: R.reuseIdentifier.textCell.identifier)
        tableView.register(R.nib.valueStepperCell(), forCellReuseIdentifier: R.reuseIdentifier.valueStepperCell.identifier)
        tableView.register(R.nib.textStepperCell(), forCellReuseIdentifier: R.reuseIdentifier.textStepperCell.identifier)
        tableView.register(R.nib.suggestionTextCell(), forCellReuseIdentifier: R.reuseIdentifier.suggestionTextCell.identifier)
        tableView.register(R.nib.datePickerCell(), forCellReuseIdentifier: R.reuseIdentifier.datePickerCell.identifier)
    }
    
    static func makeCell(for tableView: UITableView, setting: DynamicCellSettingType, at indexPath: IndexPath) -> UITableViewCell {
        
        switch setting {
        case let setting where setting is DefaultCellSetting:
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: R.reuseIdentifier.defaultCell.identifier) as? DefaultCellController
            else { fatalError("Unable to dequeue Cell.") }
            
            cell.configure(with: setting as! DefaultCellSetting)
            return cell
        case let setting where setting is DetailedCellSetting:
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: R.reuseIdentifier.detailedCell.identifier) as? DetailedCellController
            else { fatalError("Unable to dequeue Cell.") }
            
            cell.configure(with: setting as! DetailedCellSetting)
            return cell
            
        case let setting where setting is BooleanCellSetting:
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: R.reuseIdentifier.booleanCell.identifier) as? BooleanCellController
            else { fatalError("Unable to dequeue Cell.") }
            
            cell.configure(with: setting as! BooleanCellSetting)
            return cell
            
        case let setting where setting is TextCellSetting:
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: R.reuseIdentifier.textCell.identifier) as? TextCellController
            else { fatalError("Unable to dequeue Cell.") }
            
            cell.configure(with: setting as! TextCellSetting)
            
            return cell
            
        case let setting where setting is ValueStepperCellSetting:
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: R.reuseIdentifier.valueStepperCell.identifier) as? ValueStepperCellController
            else { fatalError("Unable to dequeue Cell.") }
            
            cell.configure(with: setting as! ValueStepperCellSetting)
            
            return cell
        case let setting where setting is TextStepperCellSetting:
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: R.reuseIdentifier.textStepperCell.identifier) as? TextStepperCellController
                else { fatalError("Unable to dequeue Cell.") }
            
            cell.configure(with: setting as! TextStepperCellSetting)
            
            return cell
        case let setting where setting is SuggestionTextCellSetting:
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: R.reuseIdentifier.suggestionTextCell.identifier) as? SuggestionTextCellController
            else { fatalError("Unable to dequeue Cell.") }
            
            cell.configure(with: setting as! SuggestionTextCellSetting)
            
            return cell
        case let setting where setting is DatePickerCellSetting:
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: R.reuseIdentifier.datePickerCell.identifier) as? DatePickerCellController
            else { fatalError("Unable to dequeue Cell.") }
            
            cell.configure(with: setting as! DatePickerCellSetting)
            
            return cell
        default:
            let message = "Unhandled Settings Cell Type."
            log.error(message)
            fatalError(message)
        }
    }
}
