//: A UIKit based Playground for presenting user interface

import UIKit
import SwiftUI
import PlaygroundSupport
import MapKit

public struct MapView: UIViewRepresentable {
    public func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    public func updateUIView(_ view: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(
            latitude: 34.011286, longitude: -116.166868)
        let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
    }
}

public struct CircleImage: View {
    public var body: some View {
        Image(uiImage: UIImage(named: "turtlerock")!)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            MapView()
                .edgesIgnoringSafeArea(.top)
                .frame(height: 300)
            
            CircleImage()
                .offset(y: -130)
                .padding(.bottom, -130)
            
            VStack(alignment: .leading) {
                Text("Turtle Rock")
                    .font(.title)
                HStack(alignment: .top) {
                    Text("Joshua Tree National Park")
                        .font(.subheadline)
                    Spacer()
                    Text("California")
                        .font(.subheadline)
                }
                }
                .padding()
            
            Spacer()
        }
    }
}
let contentView = ContentView()
PlaygroundPage.current.liveView = UIHostingController(rootView: contentView)
