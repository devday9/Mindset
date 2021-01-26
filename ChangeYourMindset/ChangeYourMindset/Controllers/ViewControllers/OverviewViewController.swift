//
//  OverviewViewController.swift
//  ChangeYourMindset
//
//  Created by Deven Day on 10/29/20.
//

import UIKit
import CloudKit

class OverviewViewController: UIViewController {
    
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
        //        clearAllData(Day, completion: <#T##(Result<Bool, MindsetError>) -> Void#>)
    }
    
    //MARK: - Helper Functions
    func setupViews() {
        self.view.backgroundColor = .systemRed
        collectionView.backgroundColor = .systemRed
        collectionView.isScrollEnabled = false
        collectionView.collectionViewLayout = configureCollectionViewLayout()
    }
    
    func configureCollectionViewLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.1))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 7)
        group.interItemSpacing = .fixed(1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 1
        section.contentInsets = .init(top: 1,
                                      leading: 1,
                                      bottom: 0,
                                      trailing: 1)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    // THIS BELONGS ON A MODEL CONTROLLER FOR OVERVIEWVC?
    //        func clearAllData(_ days: Day, completion: @escaping (Result<Bool, MindsetError>) -> Void) {
    //
    //            let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [days.recordID])
    //
    //            operation.savePolicy = .changedKeys
    //            operation.qualityOfService = .userInteractive
    //            operation.modifyRecordsCompletionBlock = { ( _, recordIDs, error) in
    //
    //                if let error = error {
    //                    return completion(.failure(.ckError(error)))
    //                }
    //
    //                guard let recordIDs = recordIDs else { return completion(.failure(.couldNotUnwrap))}
    //                print("\(recordIDs) were removed successfully")
    //                completion(.success(true))
    //            }
    //
    //            privateDB.add(operation)
    //        }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDayVC" {
            guard let indexArray = collectionView.indexPathsForSelectedItems,
                  let destination = segue.destination as? DayViewController,
                  let days = ChallengeController.shared.currentChallenge?.days
            else {
                return
            }
            
            let indexPath = indexArray[0]
            destination.day = days[indexPath.row]
        }
    }
}//END OF CLASS

//MARK: - Extensions
extension OverviewViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let days = ChallengeController.shared.currentChallenge?.days {
            return days.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as? DayCollectionViewCell,
              let currentChallenge = ChallengeController.shared.currentChallenge
        else {
            return UICollectionViewCell()
        }
        let days = currentChallenge.days
        let day = days[indexPath.row]
        //        let dayNotInFuture = day.dayNumber <= currentChallenge.daysSinceStartDate
        
        //        print("\(day) \(dayNotInFuture) \(currentChallenge.daysSinceStartDate) \(currentChallenge.startDate)")
        
        cell.dayLabel.text = String(day.dayNumber)
        //        cell.isUserInteractionEnabled = dayNotInFuture
        //        cell.dayLabel.textColor = dayNotInFuture ? .white : .darkGray
        
        return cell
    }
}//END OF EXTENSION

