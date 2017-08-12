//
//  FilterViewController.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/11/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Constants
    
    private let languages = Language.loadAllLanguages()
    
    // MARK: - Variables
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var selectedSetting: TatoebaUserDefaultsKey?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeButton.accessibilityLabel = TatoebaLocalizer.localize("Generic_Close")
        titleLabel.text = TatoebaLocalizer.localize("Filter_Title")
        clearButton.accessibilityLabel = TatoebaLocalizer.localize("Filter_Clear_Button")
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // This makes detail values appear correctly when tapping close on the choice controller
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let choiceController = segue.destination as? ChoiceViewController {
            guard let setting = selectedSetting else {
                return
            }
            
            choiceController.setting = setting
            choiceController.values = languages.map({ Choice(id: $0.id, name: $0.name) })
            choiceController.title = TatoebaLocalizer.localize("Filter_Language_Title")
            
            selectedSetting = nil
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        TatoebaUserDefaults.removeObject(forKey: .fromLanguage)
        TatoebaUserDefaults.removeObject(forKey: .toLanguage)
        
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return TatoebaLocalizer.localize("Filter_Choose_Languages")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = TatoebaLocalizer.localize(indexPath.row == 0 ? "Filter_Source_Language" : "Filter_Target_Language")
        cell.accessoryType = .disclosureIndicator
        
        if let id = TatoebaUserDefaults.string(forKey: indexPath.row == 0 ? .fromLanguage : .toLanguage) {
            cell.detailTextLabel?.text = languages.first(where: { $0.id == id })?.name
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedSetting = indexPath.row == 0 ? .fromLanguage : .toLanguage
        performSegue(withIdentifier: "choiceSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
