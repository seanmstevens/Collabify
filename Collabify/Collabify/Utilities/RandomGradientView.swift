//
//  RandomGradientView.swift
//  Spotify-Collab-Playlist-App
//
//  Created by Sean Stevens on 4/23/22.
//

import UIKit

@IBDesignable
class RandomGradientView: UIView {
    override static var layerClass: AnyClass { return CAGradientLayer.self }
    var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        gradientLayer.colors = [UIColor.blue.cgColor, UIColor.red.cgColor]
    }
}

private extension RandomGradientView {
    func configure() {
        let random = UIColor.random().cgColor
        let random2 = UIColor.random().cgColor
        gradientLayer.colors = [random, random2]
        
        let randomAngle = Float.random(in: 0...360)
        let points = calculatePoints(angle: randomAngle)
        
        gradientLayer.startPoint = points.start
        gradientLayer.endPoint = points.end
    }
    
    func calculatePoints(angle: Float = 0) -> (start: CGPoint, end: CGPoint) {
        let alpha: Float = angle / 360
        let startPointX = powf(
            sinf(2 * Float.pi * ((alpha + 0.75) / 2)),
            2
        )
        let startPointY = powf(
            sinf(2 * Float.pi * ((alpha + 0) / 2)),
            2
        )
        let endPointX = powf(
            sinf(2 * Float.pi * ((alpha + 0.25) / 2)),
            2
        )
        let endPointY = powf(
            sinf(2 * Float.pi * ((alpha + 0.5) / 2)),
            2
        )
        
        return (start: CGPoint(x: CGFloat(endPointX), y: CGFloat(endPointY)),
                end: CGPoint(x: CGFloat(startPointX), y: CGFloat(startPointY)))
    }
}

extension UIColor {
    static func random() -> UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
