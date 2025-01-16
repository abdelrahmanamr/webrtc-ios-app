//
//  VideoViewController.swift
//  WebRTC
//
//  Created by Stasel on 21/05/2018.
//  Copyright © 2018 Stasel. All rights reserved.
//

import UIKit
import WebRTC

class VideoViewController: UIViewController {
    
    private var pointsArray: [CGPoint] = [] // The dynamic array of points
    private var pointViews: [UIView] = []  // Keeps track of the created point views
    private var displayLink: CADisplayLink? // CADisplayLink for continuous updates
    
    @IBOutlet private weak var localVideoView: UIView?
    private let webRTCClient: WebRTCClient

    init(webRTCClient: WebRTCClient) {
        self.webRTCClient = webRTCClient
        super.init(nibName: String(describing: VideoViewController.self), bundle: Bundle.main)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the local video renderer to take up the entire screen
        let localRenderer = RTCMTLVideoView(frame: self.view.frame)
        localRenderer.videoContentMode = .scaleAspectFill
        self.webRTCClient.startCaptureLocalVideo(renderer: localRenderer)
        self.embedView(localRenderer, into: self.view)

        // Add the back button
        let backButton = UIButton(type: .system)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.white, for: .normal) // White text color for contrast
        backButton.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Semi-transparent background
        backButton.layer.cornerRadius = 5
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backDidTap(_:)), for: .touchUpInside)
        
        // Add the button to the main view
        self.view.addSubview(backButton)
        
        // Set up constraints to position the button
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 60),
            backButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    
        pointsArray = [
//            CGPoint(x: 50, y: 100),
//            CGPoint(x: 150, y: 200),
//            CGPoint(x: 250, y: 300),
//            CGPoint(x: 100, y: 400),
//            CGPoint(x: 200, y: 500),
//            CGPoint(x: 300, y: 600)
        ]
    
        // Set up CADisplayLink for continuous updates
        setupDisplayLink()
    }
    
    private func embedView(_ view: UIView, into containerView: UIView) {
        containerView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                        view.topAnchor.constraint(equalTo: containerView.topAnchor),
                        view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                        view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                        view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
                    ])
        containerView.layoutIfNeeded()
    }
    
    @IBAction private func backDidTap(_ sender: Any) {
        self.webRTCClient.stopCaptureLocalVideo()
        self.dismiss(animated: true)
    }
    
    private func updatePoints() {
        
        // Define the source resolution of the points (e.g., the video frame size)
        let sourceWidth: CGFloat = 480 // Replace with the actual width of your source
        let sourceHeight: CGFloat = 640 // Replace with the actual height of your source

        // Get the size of the current view
        let targetWidth = self.view.frame.size.width
        let targetHeight = self.view.frame.size.height
        
        
        // Calculate scaling factors
        let scaleX = targetWidth  / sourceWidth
        let scaleY = targetHeight / sourceHeight
        print("targetWidth: \(targetWidth), sourceWidth: \(sourceWidth)")
        print("scaleX: \(scaleX), scaleY: \(scaleY)")
        
        
        // Remove all existing point views from the superview
        pointViews.forEach { $0.removeFromSuperview() }
        pointViews.removeAll()
        
        for point in pointsArray {
            let adjustedX = point.x * scaleX
            let adjustedY = point.y * scaleY
            
            let pointView = UIView()
            pointView.backgroundColor = .red
            pointView.layer.cornerRadius = 5
            pointView.translatesAutoresizingMaskIntoConstraints = false
            
            self.view.addSubview(pointView)

            // Set size and position constraints
            NSLayoutConstraint.activate([
                pointView.widthAnchor.constraint(equalToConstant: 10),
                pointView.heightAnchor.constraint(equalToConstant: 10),
                pointView.centerXAnchor.constraint(equalTo: self.view.leadingAnchor, constant: round(adjustedX)),
                pointView.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: round(adjustedY))
            ])
            
            // Add the new point view to the tracking array
            pointViews.append(pointView)
        }
    }
    
    private func setupDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(refreshPoints))
        displayLink?.preferredFramesPerSecond = 1 // Set to 1 FPS for lower update frequency
        displayLink?.add(to: .current, forMode: .default)
    }
    
    @objc private func refreshPoints() {
        // Simulate updating the array (you can replace this logic with dynamic updates)
        if(!self.webRTCClient.receivedPoints.isEmpty){
            pointsArray = self.webRTCClient.receivedPoints.map { CGPoint(x: $0.x, y: $0.y) }
        }
        updatePoints()
    }
    
    deinit {
        // Invalidate CADisplayLink to avoid memory leaks
        displayLink?.invalidate()
    }
}
