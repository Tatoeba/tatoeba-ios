//
//  LibrariesViewController.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/12/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import UIKit

class LibrariesViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Constants
    
    private var libraries = Library.loadAllLibraries()
    
    // MARK: - Properties
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var selectedLibrary: Library?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.accessibilityLabel = TatoebaLocalizer.localize("Generic_Back")
        titleLabel.text = TatoebaLocalizer.localize("Settings_Open_Source_Header")
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let library = selectedLibrary, let libraryController = segue.destination as? LibraryViewController {
            libraryController.library = library
            selectedLibrary = nil
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libraries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.accessibilityTraits = UIAccessibilityTraitButton
        cell.textLabel?.text = libraries[indexPath.row].name
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedLibrary = libraries[indexPath.row]
        performSegue(withIdentifier: "librarySegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
