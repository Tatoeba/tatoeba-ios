//
//  SettingsViewController.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/6/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import SafariServices
import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Constants
    
    private let items: [[SettingsItem]] = [
        [
            .cell(.supportTatoeba)
        ],
        [
            .header(TatoebaLocalizer.localize("Settings_Terms_Header")),
            .cell(.termsOfUse),
            .cell(.sendAnonymousUsageData),
            .footer(TatoebaLocalizer.localize("Settings_Terms_Footer"))
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
    
    private func cell(for indexPath: IndexPath) -> SettingsCellModel {
        let models: [SettingsCellModel] = items[indexPath.section].filter({
            switch $0 {
            case .cell(_):
                return true
            default:
                return false
            }
        }).map({
            switch $0 {
            case .cell(let model):
                return model
            default:
                fatalError()
            }
        })
        
        return models[indexPath.row]
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
        let model = cell(for: indexPath)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: model.identifier, for: indexPath) as? SettingCell else {
            return UITableViewCell()
        }
        
        switch model.type {
        case .switch:
            cell.selectionStyle = .none
        default:
            break
        }
        
        cell.model = model
        
        // Get number of cells in the section
        let numberOfCellsInSection = self.tableView(tableView, numberOfRowsInSection: indexPath.section)
        
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
        
        switch cell(for: indexPath) {
        case SettingsCellModel.supportTatoeba:
            guard let url = URL(string: "https://tatoeba.org/eng/donate") else {
                return
            }
            
            UIApplication.shared.openURL(url)
        case SettingsCellModel.termsOfUse:
            guard let url = URL(string: "https://tatoeba.org/eng/terms_of_use") else {
                return
            }
            
            if #available(iOS 9.0, *) {
                let safariController = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                present(safariController, animated: true, completion: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = cell(for: indexPath)
        
        let horizontalSpacing: CGFloat
        let verticalSpacing: CGFloat = 24
        
        switch model.type {
        case .external, .push:
            horizontalSpacing = 116
        case .switch:
            horizontalSpacing = 141
        }
        
        return model.text.height(forMaxWidth: view.frame.size.width - horizontalSpacing, withFont: .systemFont(ofSize: 17)) + verticalSpacing
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let item = items[section].first else {
            return nil
        }
        
        switch item {
        case .header(let text):
            return text.uppercased(with: Locale.current)
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
