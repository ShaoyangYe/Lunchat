//
//  PageTitleView.swift
//  Lunchat
//
//  Created by 杨昱程 on 16/9/19.
//  Copyright © 2019 MobileTeam. All rights reserved.
//
import MapKit

import CoreLocation
import UIKit
// 定义协议
protocol PageTitleViewDelegate : class{
    func pageTitleView(titleView : PageTitleView, selectedIndex index:Int)
    func mapview(titleView : PageTitleView, ifmap map:Bool)
}
// 定义常量
private let kScrollLLineH : CGFloat = 2
private let kNormalColor : (CGFloat,CGFloat,CGFloat) = (85,85,85)
private let kSelectColor : (CGFloat,CGFloat,CGFloat) = (255,126,0)

class PageTitleView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    private var currentIndex : Int = 0
    private var titles : [String]
    weak var delegate : PageTitleViewDelegate?
    private lazy var titleLabels : [UILabel] = [UILabel]()
    
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop =  false
        scrollView.bounces = false
        return scrollView
    }()
    private lazy var scrolllLine : UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    init(frame: CGRect, titles:[String]) {
        self.titles = titles
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PageTitleView{
    private func setupUI(){
        // add UIScrollView
        addSubview(scrollView)
        scrollView.frame  = bounds
        // add title's label
        setupTitleLabels()
        // set BottomLine
        setupBottomLineAndSccroolline()
    }
    private func setupTitleLabels(){
        let labelW : CGFloat = (frame.width - 50) / CGFloat(titles.count)
        let labelH : CGFloat = frame.height - kScrollLLineH
        let labelY : CGFloat = 0
        for (index,title) in titles.enumerated(){
            // 1. creat UIlabell
            let label = UILabel()
            // 2. set Label attribute
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = UIColor.darkGray
            label.textAlignment = .center
            // 3.set label frame
            let labelX : CGFloat = labelW * CGFloat(index)
            label.frame  = CGRect(x: labelX, y:labelY,  width: labelW, height: labelH)
            // 4. add labels to scrolllView
            scrollView.addSubview(label)
            titleLabels.append(label)
            // 5. add gustures
            label.isUserInteractionEnabled = true
            let tapGes =  UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(tapGes:)))
            label.addGestureRecognizer(tapGes)
        }
        let size = CGSize(width: 40, height: 40)
        let btn = UIButton()
        btn.setImage(UIImage(named: "btnTravel"), for: .normal)
        btn.setImage(UIImage(named: "btnTravel"), for: .highlighted)
        let point =  CGPoint(x: frame.width-45, y: 0)
        btn.frame = CGRect(origin: point, size: size)
        btn.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)//        btn.sizeToFit()
        scrollView.addSubview(btn)
    }
    private func setupBottomLineAndSccroolline(){
        //1.添加底线
        let bottemline = UIView()
        bottemline.backgroundColor = UIColor.lightGray
        let lineH:CGFloat = 0.5
        bottemline.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottemline)
        //2 添加scrollLine
        // add first scrollLine
        guard let firstLabel = titleLabels.first else {return}
        firstLabel.textColor = UIColor.orange
        
        scrollView.addSubview(scrolllLine)
        scrolllLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLLineH, width: firstLabel.frame.width, height: kScrollLLineH)
    }
    // 地图按键
    @objc func buttonClick(){
//        let mapview:MKMapView=MKMapView.init(frame:CGRect.init(x: 0, y: 0, width: 300, height: 300))
        delegate?.mapview(titleView: self, ifmap: true)
        //3.切换文字的颜色
        titleLabels[0].textColor = UIColor.darkGray
        titleLabels[1].textColor = UIColor.darkGray
        scrolllLine.backgroundColor = UIColor.white
        
    }
}

extension PageTitleView{
    @objc  private func titleLabelClick(tapGes : UITapGestureRecognizer){
        //1.获取当前Label
        guard let currentLabel = tapGes.view as? UILabel else { return }
        //2.获取之前的Label
        let oldLabel = titleLabels[currentIndex]
        //3.切换文字的颜色
        oldLabel.textColor = UIColor.darkGray
        currentLabel.textColor = UIColor.orange
        //4.保存最新label下标
        currentIndex = currentLabel.tag
        
        // 5.滚条位置变化
        let scrollLineX = CGFloat(currentIndex) * scrolllLine.frame.width
        
        UIView.animate(withDuration: 0.15) {
            self.scrolllLine.frame.origin.x = scrollLineX
        }
        
        // 6.通知代理
        delegate?.pageTitleView(titleView: self, selectedIndex: currentIndex)
    }

}



// 对外暴露的方法
extension PageTitleView{
    func setTitleWithProgress(progress : CGFloat, sourceIndex : Int, targetIndex : Int){
        //1.取出sourceLabell/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        //2.处理滑块的逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrolllLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        //3.颜色改变
        sourceLabel.textColor = UIColor.gray
        targetLabel.textColor = UIColor.orange
        
        scrolllLine.backgroundColor = UIColor.orange
    }
}
