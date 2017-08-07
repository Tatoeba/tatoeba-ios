//
//  HomeViewController.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/5/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Constants
    
    private let sentenceSegueIdentifier = "sentenceSegue"
    
    // MARK: - Properties
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var contributions = [Contribution]()
    private var sentences = [Sentence]()
    
    private var isSearching: Bool {
        return !(searchBar.text?.isEmpty ?? true)
    }
    
    private var selectedContribution: Contribution?
    
    // MARK: - Types
    
    private enum HomeCell {
        case contribution(Contribution), separator, sentence(Sentence)
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
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
        if isSearching {
            return .sentence(sentences[indexPath.section])
        } else {
            return indexPath.row % 2 == 0 ? .contribution(contributions[indexPath.row / 2]) : .separator
        }
    }
    
    // MARK: - UISearchBarDelegate Methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        SentencesRequest(query: searchText).start { sentences in
            guard let sentences = sentences else {
                return
            }
            
            self.sentences = sentences
            self.tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearching ? sentences.count : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return 1
        } else {
            return contributions.count == 0 ? 0 : contributions.count * 2 - 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cell(for: indexPath) {
        case .contribution(let contribution):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ContributionCell.identifier) as? ContributionCell else {
                break
            }
            
            cell.contribution = contribution
            return cell
        case .sentence(let sentence):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SentenceCell.identifier) as? SentenceCell else {
                break
            }
            
            cell.sentence = sentence
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
        case .sentence(_):
            tableView.deselectRow(at: indexPath, animated: true)
        case .separator:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch cell(for: indexPath) {
        case .contribution(let contribution):
            let maximumWidth = view.frame.size.width - ContributionCell.horizontalSpacing
            return contribution.text.height(forMaxWidth: maximumWidth, withFont: .systemFont(ofSize: 16)) + ContributionCell.verticalSpacing
        case .sentence(let sentence):
            let maximumWidth = view.frame.size.width - SentenceCell.horizontalSpacing
            return sentence.text.height(forMaxWidth: maximumWidth, withFont: .systemFont(ofSize: 16)) + SentenceCell.verticalSpacing
        case .separator:
            return 20
        }
    }
}
