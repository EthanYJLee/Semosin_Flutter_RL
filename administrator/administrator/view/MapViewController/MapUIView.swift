//
//  MapUIView.swift
//  administrator
//
//  Created by 권순형 on 2023/03/24.
//

import UIKit
import MapKit

class MapUIView: UIView {
    
    // ------------------------------------------------------------------------------------
    // front
    @IBOutlet weak var myMap: MKMapView!
    
    let myLoc = CLLocationManager()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    /// 날짜 : 2023.03.24
    /// 만든이 : 권순형
    /// 설명 : 전체 세팅
    func setup(){
        viewSetup()
        componentSetup()
    }
    
    /// 날짜 : 2023.03.24
    /// 만든이 : 권순형
    /// 설명 : 뷰 모양 세팅
    func viewSetup(){
        self.layer.cornerRadius = 10
        self.addBottomShadow()
    }
    
    /// 날짜 : 2023.03.24
    /// 만든이 : 권순형
    /// 설명 : 요소 세팅
    func componentSetup(){
        // map view 넣기
        let myMap = MKMapView(frame: bounds)
        myMap.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(myMap)
        self.myMap = myMap
        
        // GPS 설정하기
        myLoc.delegate = self
        myLoc.requestWhenInUseAuthorization() // 위치 권학 받아오기
        myLoc.startUpdatingLocation()
        self.myMap.showsUserLocation = true
    }
    // ------------------------------------------------------------------------------------
    
    
    // ------------------------------------------------------------------------------------
    // map 관련 func
    /// 날짜 : 2023.03.24
    /// 만든이 : 권순형
    /// 설명 : 주어진 경도 위도에 따라 지도 움직이기
    func mapMove(_ lat: CLLocationDegrees, _ lon: CLLocationDegrees){
        let pLoc = CLLocationCoordinate2DMake(lat, lon)
        
        // 배율
        let pSpan = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        
        // 좌표정보를 가운데에 맞추고 배율을 얼만큼 보여줄건지를 알려주는 것같다.
        let pRegion = MKCoordinateRegion(center: pLoc, span: pSpan)
        
        // 현재 지도를 좌표 정보로 보기
        myMap.setRegion(pRegion, animated: true)
    }
    
    /// 날짜 : 2023.03.24
    /// 만든이 : 권순형
    /// 섦명 : 경도 위도를 가지고 해당 위치에 핀 생성
    func setPoint(_ lat: CLLocationDegrees, _ lon: CLLocationDegrees){
        let pLoc = CLLocationCoordinate2DMake(lat, lon)
        let pin = MKPointAnnotation()
        
        pin.coordinate = pLoc
        
        myMap.addAnnotation(pin)
    }
    
    /// 날짜 : 2023.03.24
    /// 만든이 : 권순형
    /// 섦명 : 경도 위도로 주소를 반환해 주는 거
    func getAddress(_ lat: CLLocationDegrees, _ lon: CLLocationDegrees) {
        let geocodingService = GeocodingService()
        geocodingService.delegate = self
        geocodingService.getAddress(lat, lon)
    }
    // ------------------------------------------------------------------------------------
}

extension MapUIView: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLoc = locations.last
        mapMove(lastLoc!.coordinate.latitude, lastLoc!.coordinate.longitude)
        setPoint(lastLoc!.coordinate.latitude, lastLoc!.coordinate.longitude)
        myLoc.stopUpdatingLocation() // 좌표 받기 중지
    }
}

extension MapUIView: GeocodingServiceProtocol{
    // 주소 받아오기
    func getAddress(result: String?, errorState: Bool) {
        
    }
    
    // 경도 위도 받아오기
    func getLatLon(result: [String : CLLocationDegrees]?, errorState: Bool) {
        
    }
}
