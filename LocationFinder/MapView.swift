//
//  MapView.swift
//  LocationFinder
//
//  Created by Tiziano Cialfi on 16/03/23.
//

import SwiftUI
import MapKit

struct MapView: View {
    private let longitude: Double
    private let latitude: Double
    @State private var mapRegion: MKCoordinateRegion
    
    init(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
        
        mapRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 0.2,
                longitudeDelta: 0.2
            )
        )
    }
    
    var body: some View {
        Map(coordinateRegion: $mapRegion)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(longitude: 40.7484445, latitude: -73.9894536)
    }
}
