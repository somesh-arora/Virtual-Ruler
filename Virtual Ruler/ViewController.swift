//
//  ViewController.swift
//  Virtual Ruler
//
//  Created by Somesh Arora on 3/13/18.
//  Copyright © 2018 Somesh Arora. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController, ARSCNViewDelegate
{
    var nodes: [SphereNode] = []
    
    lazy var sceneView: ARSCNView =
    {
            let view = ARSCNView(frame: CGRect.zero)
        view.delegate = self
        view.autoenablesDefaultLighting = true
        view.antialiasingMode = SCNAntialiasingMode.multisampling4X
            return view
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(sceneView)
        view.addSubview(infoLabel)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapRecognizer.numberOfTapsRequired = 1
        sceneView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer)
    {
        let tapLocation = sender.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation, types: .featurePoint)
        if let result = hitTestResults.first
        {
            let position = SCNVector3.positionFrom(matrix: result.worldTransform)
            let sphere = SphereNode(position: position)
            sceneView.scene.rootNode.addChildNode(sphere)
            let lastNode = nodes.last
            nodes.append(sphere)
            if lastNode != nil
            {
                let distance = lastNode!.position.distance(to: sphere.position)
                infoLabel.text = String(format: "Distance: %.2f meters", distance)
            }
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        sceneView.frame = view.bounds
        infoLabel.frame = CGRect(x: 0, y: 16, width: view.bounds.width, height: 64)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        let configration = ARWorldTrackingConfiguration()
        sceneView.session.run(configration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera)
    {
        var status = "Loading objects"
        switch camera.trackingState
        {
        case ARCamera.TrackingState.notAvailable:
            status = "Not Available"
        case ARCamera.TrackingState.limited(_):
            status = "Analyzing"
        case ARCamera.TrackingState.normal:
            status = "Ready"
        }
        infoLabel.text = status
    }

}


extension SCNVector3
{
    func distance(to destination: SCNVector3) -> CGFloat
    {
        let dx = destination.x - x
        let dy = destination.y - y
        let dz = destination.z - z
        return CGFloat(sqrt(dx*dx + dy*dy + dz*dz))
    }
    
    static func positionFrom(matrix: matrix_float4x4) -> SCNVector3
    {
        let column = matrix.columns.3
        return SCNVector3(column.x, column.y, column.z)
    }
}

