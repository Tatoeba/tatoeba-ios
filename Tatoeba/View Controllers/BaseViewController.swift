//
//  BaseViewController.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/13/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import Fuji
import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let name: String
        
        if self is HomeViewController {
            name = "Home"
        } else if self is SettingsViewController {
            name = "Settings"
        } else if self is LibrariesViewController {
            name = "Libraries"
        } else if self is LibraryViewController {
            name = "Library"
        } else if self is SentenceViewController {
            name = "Sentence"
        } else if self is FilterViewController {
            name = "Filter"
        } else if self is ChoiceViewController {
            name = "Choice"
        } else {
            name = "Unknown"
        }
        
        let event = FujiEvent(type: .contentView(page: name))
        Fuji.shared.send(event: event)
    }
}
