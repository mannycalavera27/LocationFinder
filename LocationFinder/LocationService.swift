//
//  LocationService.swift
//  LocationFinder
//
//  Created by Tiziano Cialfi on 16/03/23.
//

import Foundation

class LocationService: ObservableObject {
    
    struct LocationInfo {
        let placeName: String
        let state: String
        let longitude: Double
        let latitude: Double
    }
    
    let baseURL = "https://api.zippopotam.us"

    @Published var locationInfo: LocationInfo?
    @Published var countries: [Country] = []
    @Published var errorString: String?
    
    // MARK: - Init
    
    init() {
        loadCountries()
    }
    
    // MARK: -Private
    
    private func loadCountries() {
        guard let url = Bundle.main.url(forResource: "Countries", withExtension: "json") else {
            fatalError("Failed to locate Countries.json in the bundle")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load Countries.json from the bundle")
        }
        
        do {
            countries = try JSONDecoder().decode([Country].self, from: data)
            countries.insert(Country.none, at: 0)
        } catch {
            fatalError("Failed to decode Countries.json from data")
        }
    }
    
    // MARK: - Public
    
    @MainActor
    public func fetchLocation(for countryCode: String, postalCode: String) async {
        guard let urlString = (baseURL + "/" + countryCode + "/" + postalCode)
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
        let url = URL(string: urlString) else {
            errorString = "Invalide code entered."
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let location = try JSONDecoder().decode(Location.self, from: data)
            if let place = location.places.first {
                locationInfo = LocationInfo(
                    placeName: place.placeName,
                    state: place.state,
                    longitude: Double(place.longitude) ?? 0,
                    latitude: Double(place.latitude) ?? 0
                )
                let range = -180.0...180.0
                if !(range.contains(locationInfo!.latitude) &&
                     (range.contains(locationInfo!.longitude))) {
                    errorString = "Invalid map coordinates"
                }
            }
        } catch {
            errorString = "Could not decode returned result."
        }
    }
    
    public func reset() {
        locationInfo = nil
        errorString = nil
    }
}
