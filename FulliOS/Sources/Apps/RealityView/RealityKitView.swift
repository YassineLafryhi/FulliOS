//
//  RealityKitView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 13/7/2024.
//

import RealityKit
import SwiftUI

internal struct CosmonautSuitView: View {
    var body: some View {
        RealityKitView()
            .edgesIgnoringSafeArea(.all)
    }
}

internal struct RealityKitView: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.environment.background = .color(.white)

        guard let cosmonautSuit = try? Entity.load(named: "CosmonautSuit") else {
            fatalError("Failed to load CosmonautSuit.reality file")
        }

        let anchor = AnchorEntity(.camera)
        anchor.addChild(cosmonautSuit)

        cosmonautSuit.setPosition(SIMD3<Float>(0, -0.4, 0), relativeTo: anchor)
        cosmonautSuit.setScale(SIMD3<Float>(2.4, 2.4, 2.4), relativeTo: anchor)

        arView.scene.addAnchor(anchor)

        if let animation = cosmonautSuit.availableAnimations.first {
            cosmonautSuit.playAnimation(animation.repeat())
        }

        let panGesture = UIPanGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handlePan(_:)))
        arView.addGestureRecognizer(panGesture)

        let pinchGesture = UIPinchGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handlePinch(_:)))
        arView.addGestureRecognizer(pinchGesture)

        return arView
    }

    func updateUIView(_: ARView, context _: Context) {}
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject {
        var lastPanPosition: CGPoint?
        var initialScale: Float = 2.4

        @objc
        func handlePan(_ gesture: UIPanGestureRecognizer) {
            guard
                let arView = gesture.view as? ARView,
                let cosmonautSuit = arView.scene.anchors.first?.children.first else { return }

            switch gesture.state {
            case .began:
                lastPanPosition = gesture.location(in: arView)
            case .changed:
                guard let lastPosition = lastPanPosition else {
                    return
                }

                let currentPosition = gesture.location(in: arView)
                let delta = SIMD3<Float>(
                    Float(currentPosition.x - lastPosition.x) * 0.001,
                    Float(lastPosition.y - currentPosition.y) * 0.001,
                    0)
                cosmonautSuit.position += delta
                lastPanPosition = currentPosition
            default:
                lastPanPosition = nil
            }
        }

        @objc
        func handlePinch(_ gesture: UIPinchGestureRecognizer) {
            guard
                let arView = gesture.view as? ARView,
                let cosmonautSuit = arView.scene.anchors.first?.children.first else { return }

            switch gesture.state {
            case .began:
                initialScale = cosmonautSuit.scale.x
            case .changed:
                let newScale = initialScale * Float(gesture.scale)
                cosmonautSuit.setScale(SIMD3<Float>(repeating: newScale), relativeTo: nil)
            default:
                break
            }
        }
    }
}
