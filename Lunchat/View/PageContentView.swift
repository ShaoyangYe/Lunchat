//
//  PageContentView.swift
//  Lunchat
//
//  Created by Yucheng Yang on 19/9/19.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

protocol PageContentViewDelegate: class {
    func pageContentView(contentView : PageContentView, progress : CGFloat, sourceIndex : Int, targeIndex : Int)
}

private let ContentCellID = "ContentCellID"

class PageContentView: UIView {
    //定义属性
    var childVcs  : [UIViewController]
    private weak var parentViewController : UIViewController?
    private var startOffsetX : CGFloat = 0
    weak var delegate : PageContentViewDelegate?
    //懒加载z属性
    private lazy var collctionView : UICollectionView = { [weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.scrollsToTop = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        
        return collectionView
        }()
    init(frame: CGRect , childVcs : [UIViewController], parentViewController : UIViewController?) {
        self.childVcs =  childVcs
        self.parentViewController =  parentViewController
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PageContentView{
    private func setupUI(){
        for childVc in childVcs{
            parentViewController?.addChild(childVc)
        }
        addSubview(collctionView)
        collctionView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        
    }
}

extension PageContentView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        print(childVcs.count)
        return childVcs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        //        print(cell.contentView.bounds)
        //        print(cell.frame)
        cell.contentView.addSubview(childVc.view)
        return cell
    }
}
// 遵守UICollectionViewDelegate
extension PageContentView : UICollectionViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffsetX = scrollView.contentOffset.x
        //        print(scrollView.contentOffset.x)
        print(scrollView.contentSize)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 1.定义获取需要的数据
        var progess : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex: Int = 0
        
        //2.判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX{ //左滑
            //1.计算progess
            progess = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            //2.计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            //3.计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count{
                targetIndex = childVcs.count - 1
            }
            // 4.如何完全划过去
            if currentOffsetX - startOffsetX == scrollViewW{
                progess = 1
                targetIndex = sourceIndex
            }
        }else{//右滑
            // 1.计算progress
            progess = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            //2.计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            //3.计算sourceTarget
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count{
                sourceIndex = childVcs.count - 1
            }
            
        }
        //        print(scrollView.contentOffset.y)
        // 3.将progress/sourceIndex/targetIndex传递给titleView
        delegate?.pageContentView(contentView: self, progress: progess, sourceIndex: sourceIndex, targeIndex: targetIndex)
    }
}

//对外暴露方法
extension PageContentView{
    func setCurrentIndex(currentIndex : Int){
        let offsetX = CGFloat(currentIndex) * collctionView.frame.width
        collctionView.setContentOffset(CGPoint(x: offsetX, y:0), animated: false)
    }
}

extension PageContentView{
    func setMap(){
        let mapview:MKMapView=MKMapView.init(frame:CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 120))
        mapview.tag = 99
        self.collctionView.addSubview(mapview)
        let btn = UIButton()
        btn.tag = 100
        btn.setImage(UIImage(named: "ic_backspace_white_18dp"), for: .normal)
        btn.setImage(UIImage(named: "ic_backspace_white_18dp"), for: .highlighted)
        btn.frame = CGRect(x:0, y: 0, width: 50, height: 50)
        btn.addTarget(self, action: #selector(removeButtonClick), for: .touchUpInside)//        btn.sizeToFit()
        self.collctionView.addSubview(btn)
    }
    @objc func removeButtonClick(){
        self.collctionView.viewWithTag(99)?.removeFromSuperview()
        self.collctionView.viewWithTag(100)?.removeFromSuperview()
    }
}

