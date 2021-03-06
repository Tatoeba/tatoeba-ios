//
//  HomeViewController.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/5/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import Reachability
import StoreKit
import UIKit

class HomeViewController: BaseViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Constants
    
    private let maximumTranslationsShown = 4
    private let sentenceSegueIdentifier = "sentenceSegue"
    private let separatorHeight: CGFloat = 20
    
    // MARK: - Properties
    
    @IBOutlet weak var navigationBar: UIView!
    @IBOutlet weak var navigationBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBarTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    private var contributions = [Contribution]()
    private var sentences = [HomeSentence]()
    
    private var isSearching: Bool {
        return !(searchBar.text?.isEmpty ?? true)
    }
    
    private var isRefreshing = false
    private var reachedBottom = false
    
    private var reachability: Reachability?
    private var selectedSentence: Sentence?
    
    // MARK: - Types
    
    private enum HomeCell {
        case contribution(Contribution), sentence(Sentence), showMore, loading
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
        
        settingsButton.accessibilityLabel = TatoebaLocalizer.localize("Settings_Title")
        filterButton.accessibilityLabel = TatoebaLocalizer.localize("Filter_Title")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        loadContent(refreshing: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let isFilterApplied = TatoebaUserDefaults.string(forKey: .fromLanguage) != nil || TatoebaUserDefaults.string(forKey: .toLanguage) != nil
        filterButton.setImage(isFilterApplied ? #imageLiteral(resourceName: "Filter Filled") : #imageLiteral(resourceName: "Filter"), for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        #if RELEASE
        // Prompt for a review if the user has used the app at least three times and they just searched for a sentence
        if #available(iOS 10.3, *), TatoebaUserDefaults.integer(forKey: .appLaunches) >= 3, selectedSentence != nil {
            SKStoreReviewController.requestReview()
        }
        #endif
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sentenceController = segue.destination as? SentenceViewController {
            guard let sentence = selectedSentence else {
                return
            }
            
            sentenceController.sentence = sentence
        }
    }
    
    // MARK: - Private Methods
    
    private func cell(for indexPath: IndexPath) -> HomeCell {
        if isSearching {
            if indexPath.section == tableView.numberOfSections - 1 {
                return .loading
            } else {
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
            }
        } else {
            if indexPath.section == tableView.numberOfSections - 1 {
                // The cell in the very last section should be the loading cell
                return .loading
            } else {
                // Return contribution cell for this section
                return .contribution(contributions[indexPath.section])
            }
        }
    }
    
    private func loadContent(refreshing: Bool) {
        guard !isRefreshing, !reachedBottom, reachability?.connection != .none else {
            return
        }
        
        if isSearching {
            guard let searchText = searchBar.text else {
                return
            }
            
            let offset = refreshing ? 0 : sentences.count
            let fromLanguage = TatoebaUserDefaults.string(forKey: .fromLanguage)
            
            isRefreshing = true
            
            SentencesRequest(query: searchText, offset: offset, fromLanguage: fromLanguage).start { [weak self] sentences in
                guard let strongSelf = self else {
                    return
                }
                
                guard let sentences = sentences else {
                    strongSelf.isRefreshing = false
                    strongSelf.startReachability()
                    return
                }
                
                // If a sentence has <= 4 translations, just show all of them immediately
                let newSentences = sentences.map({ HomeSentence(sentence: $0, showing: $0.translations?.count ?? 0 <= strongSelf.maximumTranslationsShown) })
                
                if refreshing {
                    strongSelf.sentences = newSentences
                } else {
                    strongSelf.sentences.append(contentsOf: newSentences)
                }
                
                strongSelf.tableView.reloadData()
                
                if refreshing {
                    strongSelf.refreshControl.endRefreshing()
                }
                
                strongSelf.isRefreshing = false
                
                if sentences.count < 10 {
                    strongSelf.reachedBottom = true
                }
            }
        } else {
            isRefreshing = true
            
            ContributionsRequest().start { [weak self] contributions in
                guard let strongSelf = self else {
                    return
                }
                
                guard let contributions = contributions else {
                    strongSelf.isRefreshing = false
                    strongSelf.startReachability()
                    return
                }
                
                strongSelf.contributions = contributions.filter({ $0.type == "sentence" })
                strongSelf.tableView.reloadData()
                strongSelf.refreshControl.endRefreshing()
                
                strongSelf.isRefreshing = false
                
                if contributions.count < 10 {
                    strongSelf.reachedBottom = true
                }
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
        
        reachability.whenUnreachable = { [weak self] reachability in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.loadContent(refreshing: true)
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Error: couldn't start reachability")
        }
    }
    
    private func transition(searching: Bool) {
        // Don't transition between states if there is text in the search bar
        guard searching || !isSearching else {
            return
        }
        
        navigationBarHeightConstraint.constant = searching ? 64 : 111
        searchBarTrailingConstraint.constant = searching ? 32 : 0
        view.setNeedsLayout()
        
        UIView.animate(withDuration: 0.25) { 
            self.view.layoutIfNeeded()
            
            self.settingsButton.alpha = searching ? 0 : 1
            self.logoImage.alpha = searching ? 0 : 1
            self.filterButton.alpha = searching ? 1 : 0
        }
    }
    
    // MARK: - IBActions
    
    @objc func refreshControlPulled(_ sender: Any) {
        loadContent(refreshing: true)
    }
    
    // MARK: - UISearchBarDelegate Methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadContent(refreshing: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        reachedBottom = false
        transition(searching: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        reachedBottom = false
        transition(searching: false)
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Add one for the loading cell at the bottom (allows infinite scrolling)
        return (isSearching ? sentences.count : contributions.count) + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            if section == tableView.numberOfSections - 1 {
                // This would be the loading cell
                return 1
            } else {
                let sentence = sentences[section]
                
                if sentence.showing {
                    // Show n + 1 cells (add one cell for the original sentence)
                    return sentence.translationsCount + 1
                } else {
                    // Show the original sentence and its first few translations
                    return maximumTranslationsShown + 1
                }
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
        case .loading:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.identifier) as? LoadingCell else {
                break
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch self.cell(for: indexPath) {
        case .loading:
            loadContent(refreshing: false)
        default:
            break
        }
    }
    
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
        case .loading:
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
        case .showMore:
            return ShowMoreCell.height
        case .loading:
            return LoadingCell.height
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? .leastNormalMagnitude : separatorHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}
