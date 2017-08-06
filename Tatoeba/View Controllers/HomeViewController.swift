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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row % 2 {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContributionCell") as? ContributionCell else {
                return UITableViewCell()
            }
            
            let url = URL(string: "https://tatoeba.org/img/profiles_128/668a84cb40b678a3b1616849c378b74c.png?1499510593")!
            let title = "Trang added a sentence"
            let date = Date()
            let content = "Hello world"
            
            let contribution = Contribution(profileImageURL: url, title: title, date: date, content: content)
            
            cell.contribution = contribution
            
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
