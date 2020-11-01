//
//  OverviewViewController.swift
//  ChangeYourMindset
//
//  Created by Deven Day on 10/29/20.
//

import UIKit

class OverviewViewController: UIViewController {
    
    private let itemsPerRow: CGFloat = 8
    private let sectionInsets = UIEdgeInsets(top: 8.0, left: 15.0, bottom: 10.0, right: 15.0)
    
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Properties
    var viewsLaidOut = false
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if viewsLaidOut == false {
            setupViews()
            viewsLaidOut = true
        }
    }
    
    //MARK: - Actions
    @IBAction func clearAllDataButtonTapped(_ sender: Any) {
        clearAllData()
    }
    
    //MARK: - Helper Functions
    func setupViews() {
        self.view.backgroundColor = .systemRed
        collectionView.backgroundColor = .systemRed
    }
    
    func clearAllData() {
        
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDayVC" {
            guard let indexArray = collectionView.indexPathsForSelectedItems,
                  let destination = segue.destination as? DayViewController
                  else { return }
            let indexPath = indexArray[0]
            destination.day = DayController.shared.days[indexPath.row]
        }
    }
}//END OF CLASS

//MARK: - Extensions
extension OverviewViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DayController.shared.days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as? DayCollectionViewCell else { return UICollectionViewCell() }
        cell.dayLabel.text = String(DayController.shared.days[indexPath.row].dayNumber)
        cell.dayLabel.textColor = .white
        
        return cell
    }
}//END OF EXTENSION

extension OverviewViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem - 8)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}//END OF EXTENSION

