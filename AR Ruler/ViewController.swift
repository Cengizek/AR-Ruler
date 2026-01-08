//
//  ViewController.swift
//  AR Ruler
//
//  Created by Cengiz Ekmekçi on 8.01.2026.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    var dotNodes = [SCNNode]()
    var textNode = SCNNode()
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
    }
    
    
  
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if dotNodes.count >= 2 {
            for dot in dotNodes {
                dot.removeFromParentNode()
            }
            dotNodes = [SCNNode]()
        }
        
        
        
        if let touch = touches.first {
            let location = touch.location(in: sceneView)
            let results = sceneView.hitTest(location,types: .featurePoint)
            
            if let hitResult = results.first {
                addDot(at: hitResult)
            }
        }
        
    }
    
    func addDot(at hitResult: ARHitTestResult){
        let sphere = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        sphere.materials = [material]
        let node = SCNNode(geometry: sphere)
        
        node.position = SCNVector3(
            hitResult.worldTransform.columns.3.x,
            hitResult.worldTransform.columns.3.y,
            hitResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(node)
        
        dotNodes.append(node)
        
        if dotNodes.count >= 2 {
            calculate()
        }
        
        
        
        
       
        
    }
    
    func calculate(){
        let start = dotNodes[0]
        let end = dotNodes[1]
        
        print(start.position)
        print(end.position)
        
        
        let distance = sqrt(
            pow(end.position.x - start.position.x, 2) +
            pow(end.position.y - start.position.y, 2) +
            pow(end.position.z - start.position.z, 2)
        )
        updateText(text: "\(abs(distance))", atPosition: end.position)
    }
    
    func updateText(text: String, atPosition position: SCNVector3){
        textNode.removeFromParentNode()
        
        
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.red
        textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3(position.x,position.y + 0.01,position.z)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    


}
