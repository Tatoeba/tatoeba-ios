//
//  ChoiceViewController.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/11/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import UIKit

class ChoiceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Variables
    
    @IBOutlet weak var tableView: UITableView!
    
    let letters: [String]
    let languages: [String: [Language]]
    
    // MARK: - View Life Cycle
    
    required init?(coder aDecoder: NSCoder) {
        let languageNames = Language.loadAllLanguages()
        
        var languages = [String: [Language]]()
        var letters = [String]()
        
        for language in languageNames {
            guard let firstCharacter = language.name.characters.first else {
                continue
            }
            
            let firstLetter = String(firstCharacter)
            
            if !letters.contains(firstLetter) {
                letters.append(firstLetter)
            }
            
            if let _ = languages[firstLetter] {
                languages[firstLetter]?.append(language)
            } else {
                languages[firstLetter] = [language]
            }
        }
        
        self.letters = letters
        self.languages = languages
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        guard let rows = languages[letters[section]]?.count else {
            fatalError("Error determining number of rows in choice controller")
        }
        
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let language = languages[letters[indexPath.section]]?[indexPath.row] else {
            fatalError("Error determining language for cell in choice controller")
        }
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = language.name
        
        if TatoebaUserDefaults.string(forKey: .fromLanguage) == language.id {
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
        
        if let language = languages[letters[indexPath.section]]?[indexPath.row] {
            TatoebaUserDefaults.set(language.id, forKey: .fromLanguage)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
