//
//  LibraryViewController.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/12/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import UIKit

class LibraryViewController: BaseViewController {
    
    // MARK: - Variables
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var library: Library!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.accessibilityLabel = TatoebaLocalizer.localize("Generic_Back")
        titleLabel.text = library.name
        
        textView.text = library.license
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    // MARK: - IBActions
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
