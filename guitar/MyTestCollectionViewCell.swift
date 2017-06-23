//
//  MyTestCollectionViewCell.swift
//  guitar
//
//  Created by lazycal on 2017/5/25.
//  Copyright © 2017年 lazycal. All rights reserved.
//

import UIKit

@IBDesignable class MyTestCollectionViewCell: UICollectionViewCell {
    let width = UIScreen.main.bounds.size.width//获取屏幕宽
    let button = UIButton()
    var titleLabel:UILabel?//title
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        //titleLabel = UILabel(frame: CGRectMake(5, 5, (width-40)/2, 50))
        //self .addSubview(titleLabel!)
        

    }

}
