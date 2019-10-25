//
//  HomeViewController.swift
//  Lunchat
//
//  Created by Yucheng Yang on 2019/9/11.
//  Copyright © 2019 MobileTeam. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AVFoundation

private  let  kTitleViewH : CGFloat = 40
private  let insets = UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
protocol searchDelegate: class {
    func transmitString(context: String)
}
@objc protocol  getDataDelegate{
    func getData()
}

class HomeViewController: UIViewController,AVAudioPlayerDelegate {
    var player: AVAudioPlayer?
    
    //    @IBOutlet weak var searchBar: UISearchBar!
    weak var delegate : searchDelegate?
    weak var delegate2 : searchDelegate?
    weak var delegate3 : getDataDelegate?
    var recipentId: String?
    var locationManager: CLLocationManager?
    var notification: UIBarButtonItem?
    var mapview: MKMapView!
    var apointmentData = [
        ["title":"Do you like music?","theme":"Architecture","location":"Union House Ground 1","participant":"3","MaxParticipant":"5","time":"11:00","collected": "true","latitude":"-37.791915927734375","longitude":"144.96056159442693"],
        ["title":"What's your favorite movie?","theme":"Movie","location":"Union House","participant":"3","MaxParticipant":"4","time":"12:00","collected": "false","latitude":"-37.793915927734375","longitude":"144.96056159442693"],
        ["title":"Do you like art?","theme":"Art","location":"Union House","participant":"3","MaxParticipant":"3","time":"16:40","collected": "false","latitude":"-37.795915927734375","longitude":"144.96056159442693"],
        ["title":"Go to Gym?","theme":"Sport","location":"Union House","participant":"1","MaxParticipant":"2","time":"10:50","collected": "false","latitude":"-37.797915927734375","longitude":"144.96056159442693"],
        ["title":"Do you like music?","theme":"Architecture","location":"Union House Ground 1","participant":"3","MaxParticipant":"5","time":"11:00","collected": "true","latitude":"-37.796915927734375","longitude":"144.96056159442693"],
        ["title":"Do you like music?","theme":"Architecture","location":"Union House Ground 1","participant":"3","MaxParticipant":"5","time":"11:00","collected": "true","latitude":"-37.795815927734375","longitude":"144.96056159442693"],
        ["title":"Do you like music?","theme":"Architecture","location":"Union House Ground 1","participant":"3","MaxParticipant":"5","time":"11:00","collected": "true","latitude":"-37.795315927734375","longitude":"144.96056159442693"]]
    var apointmentData2 = [[String:String]]()
    
    
    var mateData = [
        ["name":"Tom Marshall","sex":"male","icon":"no-user-image-square","department":"Master of Bussiness"],
        ["name":"Pena Valdez","sex":"female","icon":"no-user-image-square","department":"Master of Computer Science"],
        ["name":"Jessica","sex":"female","icon":"no-user-image-square","department":"Master of teaching"],
        ["name":"JIM","sex":"male","icon":"no-user-image-square","department":"Master of Information system"]]
    
    
    private  lazy var pageTitleView : PageTitleView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: 44, width: 414, height: kTitleViewH)
        let  titles   = ["Lunch Chat","Mate"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        
        titleView.delegate = self
        //        titleView.backgroundColor = UIColor.purple
        return titleView
        }()
    private lazy var searchBar: UISearchBar = {[weak self] in
        
        
        let Frame = CGRect(x: 0, y:0, width: UIScreen.main.bounds.size.width, height: 44)
        let bar = UISearchBar.init(frame: Frame)
        return bar
        }()
    private lazy var pageContentView : PageContentView =  {
        let contentH = UIScreen.main.bounds.size.height  - 80 -  kTitleViewH
        let contentFrame = CGRect(x: 0, y: 84 , width: UIScreen.main.bounds.size.width, height: self.view.bounds.height-84)
        var childVcs = [UIViewController]()
        //        for _ in 0..<2{
        //            let vc = UIViewController()
        //            vc.view.backgroundColor = UIColor.red
        //            childVcs.append(vc)
        //        }
        
        let vc = RecommendViewController()
        //        vc.view.backgroundColor = UIColor.red
        
        vc.dataSource = self.apointmentData
        childVcs.append(vc)
        
        let vc1 = MateViewController()
        //        vc1.view.backgroundColor = UIColor.blue
        vc1.dataSource = mateData
        vc1.delegate = self
        childVcs.append(vc1)
        
        let contentView = PageContentView(frame: contentFrame, childVcs: childVcs,  parentViewController: self)
        contentView.delegate = self
        return contentView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.init()
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "image_openNotice"), landscapeImagePhone: UIImage(named: "image_openNotice"), style: .plain, target: .none, action: .none)
        //
        UIApplication.shared.applicationSupportsShakeToEdit = true
        view.addSubview(searchBar)
        view.addSubview(pageTitleView)
        view.addSubview(pageContentView)
        print(view.safeAreaLayoutGuide.layoutFrame)
        self.delegate = pageContentView.childVcs[0] as? searchDelegate
        self.delegate2 = pageContentView.childVcs[1] as? searchDelegate
        self.delegate3 = pageContentView.childVcs[0] as? getDataDelegate
        searchBar.delegate  = self
        pageContentView.backgroundColor = UIColor.purple
        //        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        //        view.addGestureRecognizer(tap)
        //        var di = [Dictionary<String,Any>]()
        self.hideKeyboardWhenTappedAround()
    }
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        print("开始摇动")
        //开始动画
        /// 设置音效
        let path1 = Bundle.main.path(forResource: "rock", ofType:"mp3")
        let data1 = NSData(contentsOfFile: path1!)
        self.player = try? AVAudioPlayer(data: data1! as Data)
        self.player?.delegate = self
        self.player?.updateMeters()//更新数据
        self.player?.prepareToPlay()//准备数据
        self.player?.play()
        self.delegate3?.getData()
    }
    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        print("取消摇动")
    }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        print("摇动结束")
        
        /// 设置音效
        let path = Bundle.main.path(forResource: "rock_end", ofType:"mp3")
        let data = NSData(contentsOfFile: path!)
        self.player = try? AVAudioPlayer(data: data! as Data)
        self.player?.delegate = self
        self.player?.updateMeters()//更新数据
        self.player?.prepareToPlay()//准备数据
        self.player?.play()
    }
    //    @objc func dismissKeyboard() {
    //        //Causes the view (or one of its embedded text fields) to resign the first responder status.
    //        view.endEditing(true)
    //    }
}
extension HomeViewController{
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
// 遵守PageTitleviewDelegate协议
extension HomeViewController : PageTitleViewDelegate {
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int) {
        pageContentView.setCurrentIndex(currentIndex: index)
    }
    func mapview(titleView: PageTitleView, ifmap map: Bool) {
        self.setMap()
    }
}
// 遵守PageContentViewDelegate协议
extension HomeViewController : PageContentViewDelegate{
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targeIndex: Int) {
        //        pageTitleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, tagertIndex: targeIndex)
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targeIndex)
    }
}
extension HomeViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.transmitString(context: searchText)
        delegate2?.transmitString(context: searchText)
        print(delegate.debugDescription)
        if  searchText.count == 0{
            searchBar.resignFirstResponder()
            self.searchBar.showsCancelButton = false
        }
        
    }
    //    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    //        searchBar.resignFirstResponder()
    //        self.searchBar.showsCancelButton = false
    //    }
    //    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    //        self.searchBar.showsCancelButton = true
    //
    //    }
}

extension HomeViewController : CLLocationManagerDelegate,MKMapViewDelegate{
    
    func setMap(){
        let mapview:MKMapView=MKMapView.init(frame:CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 120))
        mapview.tag = 199
        //        view.addSubview(mapview)
        
        //        let mapview = MKMapView(frame:self.view.frame)
        view.addSubview(mapview)
        mapview.delegate = self
        mapview.mapType = MKMapType.standard
        let latDelta = 0.01
        let longDelta = 0.01
        //        let locationManager:CLLocationManager = CLLocationManager()
        //        locationManager.delegate = self
        //        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //
        //        locationManager.requestAlwaysAuthorization()
        //        locationManager.startUpdatingLocation()
        //        locationManager.requestWhenInUseAuthorization()
        //
        //        print(locationManager.location?.coordinate)
        
        
        if locationManager == nil {
            
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        }
        
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager?.startUpdatingLocation()
        } else if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager?.requestAlwaysAuthorization()
        } else if CLLocationManager.authorizationStatus() == .denied {
            print("User denied location permissions.")
        }
        
        
        for i in 1...self.apointmentData.count{
            let objectAnnotation = MKPointAnnotation()
            let latitude = (self.apointmentData[i-1]["latitude"]! as NSString).doubleValue
            let longitude = (self.apointmentData[i-1]["longitude"]! as NSString).doubleValue
            objectAnnotation.coordinate = CLLocation(latitude: latitude,
                                                     longitude: longitude).coordinate
            objectAnnotation.title = self.apointmentData[i-1]["title"]
            //设置点击大头针之后显示的描述
            objectAnnotation.subtitle = self.apointmentData[i-1]["location"]
            mapview.addAnnotation(objectAnnotation)
        }
        let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let center:CLLocation = CLLocation(latitude: -37.796915927734375, longitude: 144.96056159442693)
        let currentRegion:MKCoordinateRegion = MKCoordinateRegion(center: center.coordinate,
                                                                  span: currentLocationSpan)
        
        
        mapview.setRegion(currentRegion, animated: true)
        mapview.userTrackingMode = .follow
        mapview.userLocation.title  = "My position"
        
        
        let btn = UIButton()
        btn.tag = 1000
        btn.setImage(UIImage(named: "ic_backspace_white_18dp"), for: .normal)
        btn.setImage(UIImage(named: "ic_backspace_white_18dp"), for: .highlighted)
        btn.frame = CGRect(x:0, y: 0, width: 50, height: 50)
        btn.addTarget(self, action: #selector(removeButtonClick), for: .touchUpInside)//        btn.sizeToFit()
        view.addSubview(btn)
    }
    @objc func removeButtonClick(){
        view.viewWithTag(199)?.removeFromSuperview()
        view.viewWithTag(1000)?.removeFromSuperview()
        
    }
    //    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation)
    //        -> MKAnnotationView? {
    //        if annotation is MKUserLocation {
    //            return nil
    //        }
    //
    //        let reuserId = "pin"
    //        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuserId)
    //            as? MKPinAnnotationView
    //        if pinView == nil {
    //            //创建一个大头针视图
    //            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuserId)
    //            pinView?.canShowCallout = true
    //            pinView?.animatesDrop = true
    //            //设置大头针颜色
    //            pinView?.pinTintColor = UIColor.red
    //            //设置大头针点击注释视图的右侧按钮样式
    ////            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    //        }else{
    //            pinView?.annotation = annotation
    //        }
    //
    //        return pinView
    //    }
    
}

extension HomeViewController:HomeViewDelegate2{
    func forward(uid:String){
        self.recipentId = uid
        performSegue(withIdentifier: "1234", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationViewController = segue.destination as? MateProfileViewController {
            destinationViewController.userId = self.recipentId!
        }
    }
}
