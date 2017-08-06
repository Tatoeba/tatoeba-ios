//
//  HomeViewController.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/5/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var contributions = [Contribution]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        TatoebaRequest(endpoint: "/contributions").start { json in
            guard let contributions = json?.array else {
                return
            }
            
            for contributionJson in contributions {
                let contribution = Contribution(json: contributionJson)
                
                if contribution.type == "sentence" {
                    self.contributions.append(contribution)
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contributions.count == 0 ? 0 : contributions.count * 2 - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row % 2 {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContributionCell") as? ContributionCell else {
                return UITableViewCell()
            }
            
            cell.contribution = contributions[indexPath.row / 2]
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SeparatorCell") as? SeparatorCell else {
                return UITableViewCell()
            }
            
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row % 2 {
        case 0:
            let boundingRect = ("Hello world" as NSString).boundingRect(with: CGSize(width: view.frame.size.width - 32, height: .greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
            return boundingRect.size.height + 96
        case 1:
            return 20
        default:
            return 0
        }
    }
}
