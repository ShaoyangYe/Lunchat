import UIKit
import CoreLocation

class YTLoactionManager: CLLocationManager {
    
    //开始定位
    func startLoaction(delegate:CLLocationManagerDelegate?) {
        //查看定位服务是否可用
        if CLLocationManager.locationServicesEnabled(){
            //1.请求定位服务
            //a.设置info.plist
            //b.请求服务
            self.requestAlwaysAuthorization()
            
            //2.设置定位精度
            self.desiredAccuracy = kCLLocationAccuracyBest
            
            //3.设置刷新距离
            self.distanceFilter = 100
            
            //4.设置代理
            self.delegate = delegate
            
            //5.开始定位
            self.startUpdatingLocation()
            
    
        }else{
            
            print("定位服务不可用")
        }
    }
}
