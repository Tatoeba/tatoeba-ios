//
//  SettingsViewController.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/6/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Constants
    
    private let items: [[SettingsItem]] = [
        [
            .cell(.supportTatoeba)
        ],
        [
            .header("TERMS AND USAGE"),
            .cell(.termsOfUse),
            .cell(.sendAnonymousUsageData),
            .footer("Allow Tatoeba to collect anonymous information about how you use the app to make the app better.")
        ]
    ]
    
    // MARK: - Properties
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = TatoebaLocalizer.localize("Settings_Title")
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Private Methods
    
    private func item(for indexPath: IndexPath) -> SettingsItem {
        let cellModels = items[indexPath.section].filter {
            switch $0 {
            case .cell(_):
                return true
            default:
                return false
            }
        }
        
        return cellModels[indexPath.row]
    }
    
    // MARK: - IBActions
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].filter({
            switch $0 {
            case .cell(_):
                return true
            default:
                return false
            }
        }).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.identifier, for: indexPath) as? SettingCell else {
            return UITableViewCell()
        }
        
        switch item(for: indexPath) {
        case .cell(let model):
            cell.model = model
        default:
            return UITableViewCell()
        }
        
        // Get number of cells in the section
        let numberOfCellsInSection = items[indexPath.section].filter({
            switch $0 {
            case .cell(_):
                return true
            default:
                return false
            }
        }).count
        
        // Set up cell separators
        switch (numberOfCellsInSection, indexPath.row) {
        case (1, 0):
            cell.position = .alone
        case (numberOfCellsInSection, 0):
            cell.position = .top
        case (numberOfCellsInSection, 1 ..< numberOfCellsInSection - 1):
            cell.position = .middle
        case (numberOfCellsInSection, numberOfCellsInSection - 1):
            cell.position = .bottom
        default:
            break
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SettingCell.height
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let item = items[section].first else {
            return nil
        }
        
        switch item {
        case .header(let text):
            return text
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let item = items[section].last else {
            return nil
        }
        
        switch item {
        case .footer(let text):
            return text
        default:
            return nil
        }
    }
}
