//
//  SentenceViewController.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/6/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import Contacts
import CoreSpotlight
import MobileCoreServices
import UIKit

class SentenceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var sentence: Sentence!
    
    private var wasPresentedModally = false
    
    // MARK: - Types
    
    private enum SentenceCellType {
        case sentence(Sentence)
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.accessibilityLabel = TatoebaLocalizer.localize("Generic_Back")
        titleLabel.text = TatoebaLocalizer.localize("Sentence_Title")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        
        if #available(iOS 9.0, *) {
            let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
            attributes.contentDescription = sentence.text
            attributes.contentURL = URL(string: "https://tatoeba.org/sentences/show/\(sentence.id)")
            attributes.identifier = "\(sentence.id)"
            attributes.title = TatoebaLocalizer.localize("Sentence_Title")
            
            let item = CSSearchableItem(uniqueIdentifier: "org.tatoeba.Tatoeba.\(sentence.id)", domainIdentifier: "sentences", attributeSet: attributes)
            CSSearchableIndex.default().indexSearchableItems([item])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isBeingPresented {
            backButton.setImage(#imageLiteral(resourceName: "Close"), for: .normal)
            wasPresentedModally = true
        }
    }
    
    // MARK: - Private Methods
    
    private func cell(for indexPath: IndexPath) -> SentenceCellType {
        switch indexPath.row {
        case 0:
            return .sentence(sentence)
        default:
            return .sentence(sentence.translations?[indexPath.row - 1] ?? sentence)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func backButton(_ sender: Any) {
        if wasPresentedModally {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sentence?.translations?.count ?? 0 + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cell(for: indexPath) {
        case .sentence(let sentence):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SentenceCell.identifier) as? SentenceCell else {
                break
            }
            
            cell.sentence = sentence
            return cell
        }
        
        return UITableViewCell()
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch cell(for: indexPath) {
        case .sentence(let sentence):
            let maximumWidth = view.frame.size.width - SentenceCell.horizontalSpacing
            return sentence.text.height(forMaxWidth: maximumWidth, withFont: .systemFont(ofSize: 16)) + SentenceCell.verticalSpacing
        }
    }
}
