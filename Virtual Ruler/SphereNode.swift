//
//  SphereNode.swift
//  Virtual Ruler
//
//  Created by Somesh Arora on 3/14/18.
//  Copyright © 2018 Somesh Arora. All rights reserved.
//

import Foundation
import SceneKit

class SphereNode: SCNNode
{
    init(position: SCNVector3)
    {
        super.init()
        let sphereGeometry = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.blue
        material.lightingModel = .physicallyBased
        sphereGeometry.materials = [material]
        self.geometry = sphereGeometry
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
}
