//
//  File.swift
//  InfiiteScrollView
//
//  Created by Eunjin Song on 2023/06/11.
//

import Foundation
import UIKit
import SnapKit

class CollectionViewCell: UICollectionViewCell {
    static let identifier = "CollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    func commonInit() {
        setUI()
    }
    
    func setUI(){
        backgroundColor = .systemGroupedBackground
        
        addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}
