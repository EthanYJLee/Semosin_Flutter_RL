//
//  GeocodingService.swift
//  administrator
//
//  Created by 권순형 on 2023/03/24.
//

import Foundation
import MapKit
import CoreLocation

protocol GeocodingServiceProtocol {
    func getAddress(result : String? , errorState : Bool)
    func getLatLon(result : [String:CLLocationDegrees]? , errorState : Bool)
}

class GeocodingService {
    
    var delegate: GeocodingServiceProtocol!
    
    func getAddress(_ lat: CLLocationDegrees, _ lon: CLLocationDegrees) {
        let addrLoc = CLLocation(latitude: lat, longitude: lon)
        var errorState = false
        var result : String?
        
        CLGeocoder().reverseGeocodeLocation(addrLoc, completionHandler: {place, error in
            if error != nil{
                errorState = true
            }else{
                let pm = place?.first
                // pm 빈건지 아닌지 나누는방법은 생각해보기
                result = "\(pm!.country!) \(pm!.locality!) \(pm!.thoroughfare!)"
            }
            
            DispatchQueue.main.async {
                self.delegate.getAddress(result: result
                                         , errorState: errorState)
            }
        })
    }
    
    func getLatLon(_ address: String){
        var result : [String:CLLocationDegrees] = [:]
        var errorState = false
        
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            if error != nil{
                errorState = true
            }else{
                errorState = false
                var location: CLLocation?
                
                if let placemarks = placemarks, placemarks.count > 0 {
                    location = placemarks.first?.location
                }

                if let location = location {
                    let coordinate = location.coordinate
                    result = [
                        "lat" : coordinate.latitude,
                        "lon" : coordinate.longitude
                    ]
                } else {
                    result = [:]
                }
            }
            
            DispatchQueue.main.async {
                self.delegate.getLatLon(result: result, errorState: errorState)
            }
        }
    }
    
    
}
