//
//  ChoiceViewController.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/11/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import UIKit

struct Choice {
    let id: String
    let name: String
}

class ChoiceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Variables
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var setting: TatoebaUserDefaultsKey?
    
    var values = [Choice]() {
        didSet {
            var sortedValues = [String: [Choice]]()
            var letters = [String]()
            
            for value in values {
                guard let firstCharacter = value.name.characters.first else {
                    continue
                }
                
                let firstLetter = String(firstCharacter)
                
                if !letters.contains(firstLetter) {
                    letters.append(firstLetter)
                }
                
                if let _ = sortedValues[firstLetter] {
                    sortedValues[firstLetter]?.append(value)
                } else {
                    sortedValues[firstLetter] = [value]
                }
            }
            
            self.letters = letters
            self.sortedValues = sortedValues
        }
    }
    
    private var letters = [String]()
    private var sortedValues = [String: [Choice]]()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeButton.accessibilityLabel = TatoebaLocalizer.localize("Generic_Close")
        titleLabel.text = title
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - IBActions
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return letters.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rows = sortedValues[letters[section]]?.count else {
            fatalError("Error determining number of rows in choice controller")
        }
        
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let value = sortedValues[letters[indexPath.section]]?[indexPath.row] else {
            fatalError("Error determining value for cell in choice controller")
        }
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = value.name
        
        if let setting = setting, TatoebaUserDefaults.string(forKey: setting) == value.id {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return letters[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return letters
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        for cell in tableView.visibleCells {
            cell.accessoryType = .none
        }
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        if let setting = setting, let value = sortedValues[letters[indexPath.section]]?[indexPath.row] {
            TatoebaUserDefaults.set(value.id, forKey: setting)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
