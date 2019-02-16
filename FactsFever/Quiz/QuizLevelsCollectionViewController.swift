//
//  QuizLevelsCollectionViewController.swift
//  FactsFever
//
//  Created by Shree Bhagwat on 16/02/19.
//  Copyright © 2019 Development. All rights reserved.
//

import UIKit



class QuizLevelsCollectionViewController: UICollectionViewController {

    @IBOutlet weak var levelNumberLabelOutlet: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

    
       

        // Do any additional setup after loading the view.
    }

   

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 50
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "quizLevelCell", for: indexPath) as? QuizLevelCollectionViewCell
    cell?.quizLevelLabelOutlet.text = "\(indexPath.row)"
        
    
        return cell!
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
