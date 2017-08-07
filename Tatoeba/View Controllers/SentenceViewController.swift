//
//  SentenceViewController.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/6/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import UIKit

class SentenceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var sentence: Sentence?
    
    // MARK: - Types
    
    private enum SentenceCellType {
        case sentence(Sentence), separator
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    // MARK: - IBActions
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SentenceCell.identifier) as? SentenceCell else {
            return UITableViewCell()
        }
        
        cell.sentence = sentence
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let sentence = sentence else {
            return 0
        }
        
        let maximumWidth = view.frame.size.width - SentenceCell.horizontalSpacing
        return sentence.text.height(forMaxWidth: maximumWidth, withFont: .systemFont(ofSize: 16)) + SentenceCell.verticalSpacing
    }
}
