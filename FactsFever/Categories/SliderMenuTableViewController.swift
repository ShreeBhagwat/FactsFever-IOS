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
    case Animal
    case Country
    case Food
    case History
    case Human
    case Interesting
    case Game
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
    
    var categoriesImage = [#imageLiteral(resourceName: "categories"),#imageLiteral(resourceName: "animal"),#imageLiteral(resourceName: "countries"),#imageLiteral(resourceName: "food"),#imageLiteral(resourceName: "history"),#imageLiteral(resourceName: "human"),#imageLiteral(resourceName: "Interesting"),#imageLiteral(resourceName: "game2"),#imageLiteral(resourceName: "language"),#imageLiteral(resourceName: "hacks"),#imageLiteral(resourceName: "Love"),#imageLiteral(resourceName: "Movies"),#imageLiteral(resourceName: "science"),#imageLiteral(resourceName: "space"),#imageLiteral(resourceName: "sports"),#imageLiteral(resourceName: "trees"),#imageLiteral(resourceName: "weird"),#imageLiteral(resourceName: "Others")]
    var categories = ["Categories","Animal","Country","Food","History","Human","Interesting","Game","Language","LifeHack","Love","Movies","Science","Space","Sports","Trees","Weird","Other",]
    var didTappedMenuType: ((MenuType) -> Void)?
    
    let cellReuseIdentifies = "CategoriesCell"
    
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
        return categories.count
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CategoriesTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifies, for: indexPath) as! CategoriesTableViewCell
        cell.categoriesLabelOutlet.text = categories[indexPath.row]
        cell.setUpLayout()
        if indexPath.row == 0 {
            cell.backgroundColor = #colorLiteral(red: 0.01342590339, green: 0.06923117489, blue: 0.1467640102, alpha: 1)
        }else{
            cell.backgroundColor = #colorLiteral(red: 0.01342590339, green: 0.06923117489, blue: 0.1467640102, alpha: 1)
        }
        cell.categoriesImageView.image = categoriesImage[indexPath.row]

        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row) else {return}
        
        
        if indexPath.row == 0{
            tableView.deselectRow(at: indexPath, animated: false)
            
        }else {
            dismiss(animated: true){ [weak self] in
                print("Dissmissing Menu With \(indexPath.row)")
                
                self?.didTappedMenuType?(menuType)
        }
        
        }
       
    }

    
}
