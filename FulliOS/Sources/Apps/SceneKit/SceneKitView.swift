//
//  SceneContainer.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 11/7/2024.
//

import CoreMotion
import SceneKit
import SwiftUI

class MainScene: ObservableObject {
    var scene: SCNScene
    private var cubeNode: SCNNode?
    private var motionManager = CMMotionManager()

    init() {
        scene = SCNScene()
        setupCamera()
        setupLights()
        setupCube()
        spawnPyramids()
    }

    private func setupCamera() {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        scene.rootNode.addChildNode(cameraNode)
    }

    private func setupLights() {
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
    }

    private func setupCube() {
        let boxGeometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        cubeNode = SCNNode(geometry: boxGeometry)
        cubeNode!.position = SCNVector3(x: 0, y: -5, z: 0)
        cubeNode!.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        scene.rootNode.addChildNode(cubeNode!)
    }

    private func spawnPyramids() {
        for _ in 1 ... 10 {
            let pyramidGeometry = SCNPyramid(width: 1, height: 1, length: 1)
            let pyramidNode = SCNNode(geometry: pyramidGeometry)
            let randomX = Float.random(in: -5 ... 5)
            pyramidNode.position = SCNVector3(x: randomX, y: 10, z: 0)
            pyramidNode.geometry?.firstMaterial?.diffuse.contents = UIColor.random()
            let moveDown = SCNAction.moveBy(x: 0, y: -20, z: 0, duration: 5)
            let remove = SCNAction.removeFromParentNode()
            pyramidNode.runAction(SCNAction.sequence([moveDown, remove]))
            scene.rootNode.addChildNode(pyramidNode)
        }
    }

    func moveCube(_ translation: CGSize) {
        SCNTransaction.animationDuration = 0.1
        let currentX = cubeNode!.position.x
        cubeNode!.position.x = currentX + Float(translation.width) * 0.1
    }
}

internal struct SceneKitView: View {
    @ObservedObject var mainScene = MainScene()
    @State private var currentOffset = CGSize.zero
    @State private var accumulatedOffset = CGSize.zero

    var body: some View {
        SceneView(
            scene: mainScene.scene,
            options: [.autoenablesDefaultLighting, .allowsCameraControl])
            .gesture(
                DragGesture()
                    .onChanged { value in
                        mainScene.moveCube(value.translation)
                    }
                    .onEnded { value in
                        accumulatedOffset.width += value.translation.width
                        accumulatedOffset.height += value.translation.height
                        currentOffset = accumulatedOffset
                    })
    }
}
