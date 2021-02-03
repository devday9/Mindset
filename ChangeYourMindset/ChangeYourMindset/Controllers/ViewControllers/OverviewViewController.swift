//
//  OverviewViewController.swift
//  ChangeYourMindset
//
//  Created by Deven Day on 10/29/20.
//

import UIKit
import CloudKit
import BLTNBoard

class OverviewViewController: UIViewController {
    
    //MARK: - Properties
    var quotes: [Quote] = []
    
    private lazy var boardManager: BLTNItemManager = {
        
        let item = BLTNPageItem(title: "Challenge Rules")
        item.descriptionText =  "Read 10 pages a day \n\n Drink 1 gallon of water \n\n 45 minute workout \n\n 15 minutes of prayer or medidation \n\n Follow a diet & no cheat meals \n\n No alchol or drugs \n\n Take a daily progress pic"
        
        item.appearance.titleTextColor = .darkGray
        item.appearance.descriptionTextColor = .black
        
        return BLTNItemManager(rootItem: item)
    }()
    
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var quoteTextLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    //MARK: - Properties
    var viewsLaidOut = false
    var randomQuote: Quote?
        
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchQuote()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if viewsLaidOut == false {
            setupViews()
            viewsLaidOut = true
        }
    }
    
    //MARK: - Actions
    @IBAction func rulesButtonTapped(_ sender: Any) {
        presentBulletinBoard()
    }
    @IBAction func clearAllDataButtonTapped(_ sender: Any) {
        //        clearAllData(Day, completion: <#T##(Result<Bool, MindsetError>) -> Void#>)
    }
    
    //MARK: - Helper Functions
    func setupViews() {
        self.view.backgroundColor = .systemRed
        collectionView.backgroundColor = .systemRed
        collectionView.isScrollEnabled = false
        collectionView.collectionViewLayout = configureCollectionViewLayout()
//        collectionView.addAccentBorderThin()
        collectionView.layer.cornerRadius = 20
    }
    
    func updateViews() {
        guard let randomQuote = randomQuote else { return }
        quoteTextLabel.text = """
            "\(randomQuote.text)"
            """
        authorLabel.text = "- \(randomQuote.author)"
    }
    
    func fetchQuote() {
        RandomQuoteController.shared.fetchQuote { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let quote):
                    self.randomQuote = quote
                    self.updateViews()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
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
    
    func presentBulletinBoard() {
        boardManager.showBulletin(above: self)
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
                let dayNotInFuture = day.dayNumber <= currentChallenge.daysSinceStartDate
        
                print("\(day) \(dayNotInFuture) \(currentChallenge.daysSinceStartDate) \(currentChallenge.startDate)")
        
        cell.dayLabel.text = String(day.dayNumber)
                        cell.isUserInteractionEnabled = dayNotInFuture
                        cell.dayLabel.textColor = dayNotInFuture ? .white : .darkGray
        
        return cell
    }
}//END OF EXTENSION

