//
//  HomeViewController.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/5/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Constants
    
    private let sentenceSegueIdentifier = "sentenceSegue"
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    private var contributions = [Contribution]()
    private var selectedContribution: Contribution?
    
    // MARK: - Types
    
    private enum HomeCell {
        case contribution(Contribution), separator
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        ContributionsRequest().start { contributions in
            guard let contributions = contributions else {
                return
            }
            
            self.contributions = contributions.filter({ $0.type == "sentence" })
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sentenceController = segue.destination as? SentenceViewController {
            guard let contribution = selectedContribution, let sentence = Sentence(contribution: contribution) else {
                return
            }
            
            sentenceController.sentence = sentence
            selectedContribution = nil
        }
    }
    
    // MARK: - Private Methods
    
    private func cell(for indexPath: IndexPath) -> HomeCell {
        return indexPath.row % 2 == 0 ? .contribution(contributions[indexPath.row / 2]) : .separator
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contributions.count == 0 ? 0 : contributions.count * 2 - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cell(for: indexPath) {
        case .contribution(let contribution):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ContributionCell.identifier) as? ContributionCell else {
                break
            }
            
            cell.contribution = contribution
            return cell
        case .separator:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SeparatorCell.identifier) as? SeparatorCell else {
                break
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch cell(for: indexPath) {
        case .contribution(let contribution):
            tableView.deselectRow(at: indexPath, animated: true)
            
            selectedContribution = contribution
            performSegue(withIdentifier: sentenceSegueIdentifier, sender: nil)
        case .separator:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch cell(for: indexPath) {
        case .contribution(let contribution):
            let maximumWidth = view.frame.size.width - ContributionCell.horizontalSpacing
            return contribution.text.height(forMaxWidth: maximumWidth, withFont: .systemFont(ofSize: 16)) + ContributionCell.verticalSpacing
        case .separator:
            return 20
        }
    }
}
