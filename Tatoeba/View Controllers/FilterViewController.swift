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
    
    @IBOutlet weak var tableView: UITableView!
    
    private var selectedSetting: TatoebaUserDefaultsKey?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = indexPath.row == 0 ? "From Language" : "To Language"
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
