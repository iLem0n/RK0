//
//  LicenseCell.swift
//  FridgeWatch
//
//  Created by iLem0n on 21.10.18.
//  Copyright © 2018 Peter Christian Glade. All rights reserved.
//

import UIKit

final class LicenseCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var linkLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var licenseTextLabel: UILabel!
    
    func configureFor(license: Licenses.License) {
        self.titleLabel.text = license.title
        self.linkLabel.text = license.link
        self.typeLabel.text = license.type
        self.licenseTextLabel.text = license.licenseText
        
        if license.title == "realm-cocoa" {
            log.debug(license.licenseText)
        }
    }
}
