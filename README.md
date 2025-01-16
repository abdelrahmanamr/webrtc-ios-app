# WebRTC iOS App

An iOS app for WebRTC built with Swift.


## Setup instructions
1. Start the signaling server (Node.js) using the repository at this [link](https://github.com/abdelrahmanamr/webrtc-client-and-signaling-server/tree/main).
2. Navigate to `WebRTC-Demo-app` folder
3. Open `WebRTC-Demo.xcworkspace`
4. Open `Config.swift` and set the `defaultSignalingServerUrl` variable to your signaling server ip/host.
5. Build and run on an iPhone device.

## Run instructions
1. Run the app on the iPhone and on the edge server with the signaling server running.
2. Make sure both of the devices are connected to the signaling server.
3. On the first device, click on 'Send offer' - this will generate a local offer SDP and send it to the other client using the signaling server.
4. Wait until the second device receives the offer from the first device.
5. The edge server will respond with SDP answer
6. when the answer arrives to the iPhone device, both of the devices should be now connected to each other using webRTC, try to click on the 'video' button to start capturing video.

## Acknowledgments
The **signaling server** in this repository is based on the original work from [WebRTC-iOS](https://github.com/stasel/WebRTC-iOS). However, significant modifications have been made to the signaling server to enhance its functionality. Specifically:
- The signaling server has been updated to support communication not only with mobile phones but also with **computers**.
- Additional improvements have been made to handle multi-server multi-client feature.
- Also handling SDP answers on the iPhone that is comming edge server beside drawing the received points

## References:
* WebRTC website: https://webrtc.org/
* WebRTC source code: https://webrtc.googlesource.com/src

