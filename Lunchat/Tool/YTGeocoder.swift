//
//  YTGeocoder.swift
//  Lunchat
//
//  Created by 杨昱程 on 22/9/19.
//  Copyright © 2019 MobileTeam. All rights reserved.
//
import UIKit
import CoreLocation

//class YTGeocoder: CLGeocoder {
//    
//    static let defaultGecoder = YTGeocoder()
//    
//    //1.将经纬度转换成地址
//    //注意:如果是类型方法，那么方法中的self指的是当前类。如果是变量型方法，那么方法中的self指的是当前对象
//    static func getAddress(coordinate:CLLocationCoordinate2D,finish:(NSDictionary?)->Void){
//        
//        //将地址(经纬度)反编码成为真正的地址
//        //参数1:经纬度对应的地址
//        //参数2:反编码成功后会自动指定的闭包
//        self.defaultGecoder.reverseGeocodeLocation(CLLocation.init(latitude: coordinate.latitude, longitude: coordinate.longitude)) { (placeMarkArray, error) in
//            
//            //拿到编码结果
//            let mark = placeMarkArray?.first
//            //返回结果
//            finish(mark.addressDictionary)
//          
//        }
//    }
//    
//    //2.将地址转换成经纬度
//    static func getcoordinate(address:String,finish:([CLLocationCoordinate2D])->Void){
//        
//        var retArray = [CLLocationCoordinate2D]()
//        
//        self.defaultGecoder.geocodeAddressString(address) { (placeMarkArray, error) in
//            
//            //1.遍历数组拿到每一个编码结果
//            for mark in placeMarkArray!{
//            
//                //获取到经纬度对应的地址
//                let coord = mark.location?.coordinate
//                //将经纬度存到数组中
//                retArray.append(coord!)
//            }
//            
//            //2.返回结果
//            finish(retArray)
//        }
//    }
//}
