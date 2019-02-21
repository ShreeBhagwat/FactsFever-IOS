//
//  SliderMenuTableViewController.swift
//  FactsFever
//
//  Created by Shree Bhagwat on 15/02/19.
//  Copyright © 2019 Development. All rights reserved.
//

import UIKit

enum MenuType: Int {
    case Categories
    case Animals
    case Country
    case Food
    case History
    case Human
    case Interesting
    case Knowledge
    case Language
    case LifeHack
    case Love
    case Movies
    case Science
    case Space
    case Sports
    case Trees
    case Weird
    case Other
    
}

class SliderMenuTableViewController: UITableViewController {
    
    var didTappedMenuType: ((MenuType) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

            }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 18
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row) else {return}
        if indexPath.row == 0{
            tableView.deselectRow(at: indexPath, animated: false)
        }else {
            dismiss(animated: true){ [weak self] in
                print("Dissmissing Menu With \(menuType)")
                self?.didTappedMenuType?(menuType)
        }
        
        }
    }

    
}
