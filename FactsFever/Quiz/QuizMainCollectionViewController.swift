//
//  QuizMainCollectionViewController.swift
//  FactsFever
//
//  Created by Shree Bhagwat on 16/02/19.
//  Copyright © 2019 Development. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class QuizMainCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }



    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

    

}
