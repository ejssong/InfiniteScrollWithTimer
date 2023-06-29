//
//  InfiniteScrollView.swift
//  InfiiteScrollView
//
//  Created by Eunjin Song on 2023/06/11.
//

import Foundation
import UIKit
import SnapKit

class InfiniteScrollView: UIView {
    
    var timer: Timer?
    
    let contentView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 100, height: 100)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        
        return collectionView
    }()
    
    var images: [String] = ["ryan1", "ryan2"]
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl(frame: .zero)
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .gray
        pageControl.backgroundStyle = .minimal
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override func draw(_ rect: CGRect) {
        collectionView.setContentOffset(.init(x: 100, y: collectionView.contentOffset.y), animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        setUI()
        setConstraint()
        activateTimer()
    }
    
    func setUI() {
        addSubview(contentView)
        [collectionView, pageControl].forEach(contentView.addSubview(_:))
        collectionView.delegate = self
        collectionView.dataSource = self
        
        images.insert(images[images.count - 1], at: 0)
        images.append(images[1])
        pageControl.numberOfPages = images.count - 2
    }
    
    func setConstraint() {
        contentView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints{
            $0.top.centerX.equalToSuperview()
            $0.size.equalTo(100)
        }
        
        pageControl.snp.makeConstraints{
            $0.top.equalTo(collectionView.snp.bottom).offset(10)
            $0.centerX.bottom.equalToSuperview()
        }
    }
}

extension InfiniteScrollView : UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        invalidateTimer()
        activateTimer()
        
        // 4 1 2 3 4 1
        if scrollView.contentOffset.x == 0 { // 첫번째(4)가 보이면 4번째 index의 4로 이동시키기
            scrollView.setContentOffset(.init(x: CGFloat( 100 * (images.count - 2)), y: scrollView.contentOffset.y), animated: false)
        }
        else if scrollView.contentOffset.x == CGFloat(100 * (images.count - 1)) { //마지막 1이 보이면 1번째 index의 1로 이동
            scrollView.setContentOffset(.init(x: 100, y: scrollView.contentOffset.y), animated: false)
        }
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX) - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 100, height: 100)
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        cell.imageView.image = UIImage(named: images[indexPath.row])
        return cell
    }
    
    func invalidateTimer() {
        timer?.invalidate()
    }
    
    func activateTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(timerCallBack), userInfo: nil, repeats: true)
    }
    
    @objc private func timerCallBack() {
        let visibleItem = collectionView.indexPathsForVisibleItems[0].item
        let nextItem = visibleItem + 1
        let initialPosterCounts = images.count - 2

        collectionView.scrollToItem(at: IndexPath(item: nextItem, section: 0), at: .centeredHorizontally, animated: true)


        if visibleItem == initialPosterCounts {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
        pageControl.currentPage = visibleItem % initialPosterCounts
    }
}
