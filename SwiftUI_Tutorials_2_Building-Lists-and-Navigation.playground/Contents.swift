//: A UIKit based Playground for presenting user interface
  
import UIKit
import SwiftUI
import PlaygroundSupport
import CoreLocation
import MapKit

//Model
// Landmark.swift
public struct Landmark: Hashable, Codable, Identifiable {
    public var id: Int
    public var name: String
    fileprivate var imageName: String
    fileprivate var coordinates: Coordinates
    public var state: String
    public var park: String
    public var category: Category
    
    public var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }
    
    public func image(forSize size: Int) -> Image {
        ImageStore.shared.image(name: imageName, size: size)
    }
    
    public enum Category: String, CaseIterable, Codable, Hashable {
        case featured = "Featured"
        case lakes = "Lakes"
        case rivers = "Rivers"
    }
}

public struct Coordinates: Hashable, Codable {
    public var latitude: Double
    public var longitude: Double
}

//View
// CircleImage.swift
public struct CircleImage: View {
    public var image: Image
    
    public var body: some View {
        image
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
    }
}

public struct MapView: UIViewRepresentable {
    public var coordinate: CLLocationCoordinate2D
    
    public func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    public func updateUIView(_ view: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
    }
}

// LandmarkDetail.swift
public struct LandmarkDetail: View {
    public var landmark: Landmark
    
    public var body: some View {
        VStack {
            MapView(coordinate: landmark.locationCoordinate)
                .frame(height: 300)
            
            CircleImage(image: landmark.image(forSize: 250))
                .offset(x: 0, y: -130)
                .padding(.bottom, -130)
            
            VStack(alignment: .leading) {
                Text(landmark.name)
                    .font(.title)
                
                HStack(alignment: .top) {
                    Text(landmark.park)
                        .font(.subheadline)
                    Spacer()
                    Text(landmark.state)
                        .font(.subheadline)
                }
                }
                .padding()
            
            Spacer()
            }
            .navigationBarTitle(Text(verbatim: landmark.name), displayMode: .inline)
    }
}


// Data
// Data.swift
public let landmarkData: [Landmark] = load("landmarkData.json")

public func load<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

public final class ImageStore {
    fileprivate typealias _ImageDictionary = [String: [Int: CGImage]]
    fileprivate var images: _ImageDictionary = [:]
    
    fileprivate static var originalSize = 250
    fileprivate static var scale = 2
    
    public static var shared = ImageStore()
    
    public func image(name: String, size: Int) -> Image {
        let index = _guaranteeInitialImage(name: name)
        
        let sizedImage = images.values[index][size]
            ?? _sizeImage(images.values[index][ImageStore.originalSize]!, to: size * ImageStore.scale)
        images.values[index][size] = sizedImage
        
        return Image(sizedImage, scale: Length(ImageStore.scale), label: Text(verbatim: name))
    }
    
    fileprivate func _guaranteeInitialImage(name: String) -> _ImageDictionary.Index {
        if let index = images.index(forKey: name) { return index }
        
        guard
            let url = Bundle.main.url(forResource: name, withExtension: "png"),
            let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
            else {
                fatalError("Couldn't load image \(name).jpg from main bundle.")
        }
        
        images[name] = [ImageStore.originalSize: image]
        return images.index(forKey: name)!
    }
    
    fileprivate func _sizeImage(_ image: CGImage, to size: Int) -> CGImage {
        let cgSize = CGSize(width: size, height: size)
        let renderer = UIGraphicsImageRenderer(size: cgSize)
        let sizedImage = renderer.image {
            (context) in
            UIImage(cgImage: image).draw(in: CGRect(origin: .zero, size: cgSize))
        }
        if let returnImage = sizedImage.cgImage {
            return returnImage
        }
        else {
            fatalError("Couldn't resize that image.")
        }
    }
}

//Interface
public struct LandmarkList: View {
    public init() {}
    public var body: some View {
        NavigationView {
            List(landmarkData) { landmark in
                NavigationButton(destination: LandmarkDetail(landmark: landmark)) {
                    LandmarkRow(landmark: landmark)
                }
                }
                .navigationBarTitle(Text("Landmarks"), displayMode: .large)
        }
    }
}

public struct LandmarkRow: View {
    public var landmark: Landmark
    
    public var body: some View {
        HStack {
            landmark.image(forSize: 50)
            Text(verbatim: landmark.name)
            Spacer()
        }
    }
}

let landmarkList = LandmarkList()
PlaygroundPage.current.liveView = UIHostingController(rootView: landmarkList)



