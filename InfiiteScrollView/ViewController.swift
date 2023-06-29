//
//  ViewController.swift
//  InfiiteScrollView
//
//  Created by Eunjin Song on 2023/06/11.
//

import UIKit

class ViewController: UIViewController {
    
    var infinite : InfiniteScrollView = {
        let view = InfiniteScrollView()
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(infinite)
        infinite.snp.makeConstraints{
            $0.width.equalTo(100)
            $0.center.equalToSuperview()
        }
    }


}

