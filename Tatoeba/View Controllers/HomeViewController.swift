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
    
    private let maximumTranslationsShown = 4
    private let sentenceSegueIdentifier = "sentenceSegue"
    private let separatorHeight: CGFloat = 20
    
    // MARK: - Properties
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var contributions = [Contribution]()
    private var sentences = [HomeSentence]()
    
    private var isSearching: Bool {
        return !(searchBar.text?.isEmpty ?? true)
    }
    
    private var selectedContribution: Contribution?
    
    // MARK: - Types
    
    private enum HomeCell {
        case contribution(Contribution), sentence(Sentence), showMore
    }
    
    private struct HomeSentence {
        let sentence: Sentence
        var showing: Bool
        
        var translationsCount: Int {
            return sentence.translations?.count ?? 0
        }
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
            let sentence = sentences[indexPath.section]
            
            guard let translations = sentence.sentence.translations else {
                return .sentence(sentence.sentence)
            }
            
            if sentence.showing {
                switch indexPath.row {
                case 0:
                    // Show the original sentence
                    return .sentence(sentence.sentence)
                default:
                    // Show a translation, subtract 1 to account for the original sentence at the top
                    return .sentence(translations[indexPath.row - 1])
                }
            } else {
                switch indexPath.row {
                case 0:
                    // Show the original sentence
                    return .sentence(sentence.sentence)
                case 1 ..< maximumTranslationsShown:
                    // Show the first three translations, subtract 1 to account for the original sentence at the top
                    return .sentence(translations[indexPath.row - 1])
                case maximumTranslationsShown:
                    // Show the "show more" button
                    return .showMore
                default:
                    // This should never happen
                    fatalError("There was an error calculating rows for a sentence that isn't showing")
                }
            }
        } else {
            // Return contribution cell for this section
            return .contribution(contributions[indexPath.section])
        }
    }
    
    // MARK: - UISearchBarDelegate Methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        SentencesRequest(query: searchText).start { sentences in
            guard let sentences = sentences else {
                return
            }
            
            // If a sentence has <= 4 translations, just show all of them immediately
            self.sentences = sentences.map({ HomeSentence(sentence: $0, showing: $0.translations?.count ?? 0 <= self.maximumTranslationsShown) })
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearching ? sentences.count : contributions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            let sentence = sentences[section]
            
            if sentence.showing {
                // Show n + 1 cells (add one cell for the original sentence)
                return sentence.translationsCount + 1
            } else {
                // Show the original sentence and its first few translations
                return maximumTranslationsShown + 1
            }
        } else {
            // There is always one contribution per section
            return 1
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
        case .showMore:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ShowMoreCell.identifier) as? ShowMoreCell else {
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
        case .showMore:
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.beginUpdates()
            
            sentences[indexPath.section].showing = true
            
            let range = maximumTranslationsShown ..< sentences[indexPath.section].translationsCount
            let indexPaths = range.map({ IndexPath(row: $0, section: indexPath.section) })
            
            tableView.insertRows(at: indexPaths, with: .automatic)
            tableView.endUpdates()
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
        case .showMore:
            return ShowMoreCell.height
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? .leastNormalMagnitude : separatorHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}
