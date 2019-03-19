//
//  QuizLevelsCollectionViewController.swift
//  FactsFever
//
//  Created by Shree Bhagwat on 16/02/19.
//  Copyright © 2019 Development. All rights reserved.
//

import UIKit
import PCLBlurEffectAlert



class QuizLevelsCollectionViewController: UICollectionViewController {
    
    var lastLevelwon = 1
    var higestLevelWon = 1
    @IBOutlet weak var levelNumberLabelOutlet: UILabel!
    
    let margin : CGFloat = 10
    let cellsPerRow = 2
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let collectinView = collectionView, let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {return}
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        collectinView.contentInsetAdjustmentBehavior = .always
        
     
        print("HigestLevelWon \(higestLevelWon)")
       
        
        self.collectionView.backgroundColor = .clear
        let imageView =  UIImageView(frame: UIScreen.main.bounds)
        imageView.image = UIImage(named: "QuizStart")
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(imageView, at: 0)
        
    
    }
    override func viewWillLayoutSubviews() {
        guard let collectionView = collectionView, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + flowLayout.minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        flowLayout.itemSize =  CGSize(width: itemWidth, height: itemWidth)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewDidAppear(true)
        let defaults = UserDefaults.standard
        
        higestLevelWon = defaults.integer(forKey: "higestLevelWon")
        defaults.synchronize()
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
   
    }
    
 

   

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 11
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "quizLevelCell", for: indexPath)
            as? QuizLevelCollectionViewCell
        cell!.quizLevelLabelOutlet.text = "\(indexPath.row)"

        if (indexPath.row  <= higestLevelWon){
            cell?.quizLevelLabelOverview.alpha = 0
        }else{
            cell?.quizLevelLabelOverview.alpha = 0.7
        }
        
    
        return cell!
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.row <= higestLevelWon){
            let cell = collectionView.cellForItem(at: indexPath)
            NavigateToQuizLevel(quizLevel: indexPath.row)
        }else{
            collectionView.deselectItem(at: indexPath, animated: false)
        }
    }
    
    func sendToQuizLevel(quizLevel : Int){
        let VC = QuizGameViewController()
        VC.selectedGameLevel = quizLevel
        present(VC, animated: true, completion: nil)

    }
    
    func NavigateToQuizLevel(quizLevel: Int){
        let VC = QuizGameViewController()
        VC.selectedGameLevel = quizLevel
        navigationController?.pushViewController(VC, animated: true)
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
//        UIView.animate(withDuration: 0.5) {
//            if let cell = collectionView.cellForItem(at: indexPath) as? QuizLevelCollectionViewCell {
//                cell.quizLevelLabelOutlet.transform = .init(scaleX: 0.95, y: 0.95)
//                cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
//            }
//        }
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
//        UIView.animate(withDuration: 0.5) {
//            if let cell = collectionView.cellForItem(at: indexPath) as? QuizLevelCollectionViewCell {
//                cell.quizLevelLabelOutlet.transform = .identity
//                cell.contentView.backgroundColor = .clear
//            }
//        }
//    }

    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }
}
