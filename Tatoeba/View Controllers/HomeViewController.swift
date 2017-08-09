//
//  HomeViewController.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/5/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import Reachability
import UIKit

class HomeViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Constants
    
    private let maximumTranslationsShown = 4
    private let sentenceSegueIdentifier = "sentenceSegue"
    private let separatorHeight: CGFloat = 20
    
    // MARK: - Properties
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var offlineView: UIView!
    @IBOutlet weak var offlineImageView: UIImageView!
    @IBOutlet weak var offlineLabel: UILabel!
    
    private let refreshControl = UIRefreshControl()
    
    private var contributions = [Contribution]()
    private var sentences = [HomeSentence]()
    
    private var isSearching: Bool {
        return !(searchBar.text?.isEmpty ?? true)
    }
    
    private var reachability: Reachability?
    private var selectedSentence: Sentence?
    
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
        
        startReachability()
        
        searchBar.delegate = self
        searchBar.placeholder = TatoebaLocalizer.localize("Home_Search_Placeholder")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        refresh()
        
        offlineImageView.tintColor = UIColor(white: 9 / 16, alpha: 1)
        offlineLabel.textColor = UIColor(white: 9 / 16, alpha: 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sentenceController = segue.destination as? SentenceViewController {
            guard let sentence = selectedSentence else {
                return
            }
            
            sentenceController.sentence = sentence
            selectedSentence = nil
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
    
    private func refresh() {
        guard reachability?.isReachable == true else {
            return
        }
        
        if isSearching {
            guard let searchText = searchBar.text else {
                return
            }
            
            SentencesRequest(query: searchText).start { [weak self] sentences in
                guard let strongSelf = self else {
                    return
                }
                
                guard let sentences = sentences else {
                    strongSelf.offlineView.isHidden = false
                    strongSelf.startReachability()
                    return
                }
                
                // If a sentence has <= 4 translations, just show all of them immediately
                strongSelf.sentences = sentences.map({ HomeSentence(sentence: $0, showing: $0.translations?.count ?? 0 <= strongSelf.maximumTranslationsShown) })
                strongSelf.tableView.reloadData()
                
                strongSelf.offlineView.isHidden = true
                strongSelf.refreshControl.endRefreshing()
            }
        } else {
            ContributionsRequest().start { [weak self] contributions in
                guard let strongSelf = self else {
                    return
                }
                
                guard let contributions = contributions else {
                    strongSelf.offlineView.isHidden = false
                    strongSelf.startReachability()
                    return
                }
                
                strongSelf.contributions = contributions.filter({ $0.type == "sentence" })
                strongSelf.tableView.reloadData()
                
                strongSelf.offlineView.isHidden = true
                strongSelf.refreshControl.endRefreshing()
            }
        }
    }
    
    private func startReachability() {
        reachability?.stopNotifier()
        reachability = nil
        
        reachability = Reachability()
        
        guard let reachability = reachability else {
            return
        }
        
        reachability.whenReachable = { [weak self] reachability in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.offlineView.isHidden = true
            }
        }
        
        reachability.whenUnreachable = { [weak self] reachability in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.offlineView.isHidden = false
                strongSelf.refresh()
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Error: couldn't start reachability")
        }
    }
    
    // MARK: - IBActions
    
    func refreshControlPulled(_ sender: Any) {
        refresh()
    }
    
    // MARK: - UISearchBarDelegate Methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        refresh()
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
            
            selectedSentence = Sentence(contribution: contribution)
            performSegue(withIdentifier: sentenceSegueIdentifier, sender: nil)
        case .sentence(let sentence):
            tableView.deselectRow(at: indexPath, animated: true)
            
            selectedSentence = sentence
            performSegue(withIdentifier: sentenceSegueIdentifier, sender: nil)
        case .showMore:
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.beginUpdates()
            
            sentences[indexPath.section].showing = true
            
            let range = maximumTranslationsShown ... sentences[indexPath.section].translationsCount
            let indexPaths = range.map({ IndexPath(row: $0, section: indexPath.section) })
            
            tableView.deleteRows(at: [indexPath], with: .top)
            tableView.insertRows(at: indexPaths, with: .top)
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
