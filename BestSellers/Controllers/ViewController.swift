//
//  ViewController.swift
//  BestSellers
//
//  Created by DA MAC M1 157 on 2023/08/23.
//

import UIKit

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

class ViewController: UIViewController {
    
    //MARK: - Properties
    
    private let layout = CustomLayout()
    
    //Calculating the height and width of the cell
    var itemW: CGFloat {
        return screenWidth * 0.4
    }
    
    var itemH: CGFloat {
        return itemW * 1.45
    }
    
    // instanting collectioView
    private let collectionView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        collectionView.decelerationRate = .fast
        
//        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.scrollDirection = .horizontal
//        layout.minimumLineSpacing = 10.0
//        layout.minimumInteritemSpacing = 10.0
        
        return collectionView
    }()
        
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let indexPath = IndexPath(item: 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        layout.currentPage = indexPath.item
        layout.previousOffset = layout.updateOffset(collectionView)
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            transformCell(cell)
        }
        
    }
}

//MARK: - Setups

extension  ViewController {
    
    private func setupViews() {
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.backgroundColor = .cyan
        collectionView.collectionViewLayout = layout
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 50.0
        layout.minimumInteritemSpacing = 50.0
        layout.itemSize.width = itemW
        
        composeConstraints()
    }
    
    private func composeConstraints() {
        let composeCollectionViewConstraints = [
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: screenWidth),
        ]
        NSLayoutConstraint.activate(composeCollectionViewConstraints)
    }
}

//MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = .red
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == layout.currentPage {
            print("didSelectItemAt")
        } else {

            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            layout.currentPage = indexPath.item
            layout.previousOffset = layout.updateOffset(collectionView)
            setupCell()
        }
        
       
        
        
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemW, height: itemH)
    }
}

//MARK: - UIScrollViewDelegate
extension ViewController {
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("didEndscrolling")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            setupCell()
        }
    }
    
    private func setupCell() {
        let indexPath = IndexPath(item: layout.currentPage, section: 0)
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        transformCell(cell)
    }
    
    private func transformCell(_ cell: UICollectionViewCell, isEffect: Bool = true) {
        if !isEffect {
            cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            return
        }
        
        UIView.animate(withDuration: 0.2) {
            cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        
        for otherCell in collectionView.visibleCells {
            if otherCell != cell {
                UIView.animate(withDuration: 0.2) {
                    otherCell.transform = .identity
                }
            }
        }
    }
    
}
