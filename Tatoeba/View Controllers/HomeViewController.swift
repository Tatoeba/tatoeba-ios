//
//  HomeViewController.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/5/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var contributions = [Contribution]()
    
    private enum HomeCell {
        case contribution(Contribution), separator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        ContributionsRequest().start { contributions in
            guard let contributions = contributions else {
                return
            }
            
            self.contributions = contributions.filter({ $0.type == "sentence" })
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func cell(for indexPath: IndexPath) -> HomeCell {
        return indexPath.row % 2 == 0 ? .contribution(contributions[indexPath.row / 2]) : .separator
    }
    
    // MARK: UITableViewDataSource Methods
    
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
    
    // MARK: UITableViewDelegate Methods
    
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
