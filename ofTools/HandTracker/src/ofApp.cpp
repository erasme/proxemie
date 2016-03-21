#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    
    
    device.setup(0, true);
   // device.setDepthClipping(0, 255);
    device.setDepthClipping(1000, 2500);

    cam.setup(&device);
    
    // GUI
    gui.setup();
    gui.setName("Settings");
    gui.add(oscHost.setup("OSC Host", "127.0.0.1"));
    gui.add(oscPort.setup("OSC Port", 12000, 1024, 65535));
    gui.add(nearHandThreshold.setup("Hand Near Threshold", 0, 0, 255));
    gui.add(farHandThreshold.setup("Hand Far Threshold", 255, 0, 255));
    gui.add(nearDepthClipping.setup("Near Depth Clipping", 500, 500, 8000));
    gui.add(farDepthClipping.setup("Far Depth Clipping", 8000, 500, 8000));
    gui.add(interactiveAreaPos.setup("Interactive Area Pos", ofVec2f(0,0), ofVec2f(0,0), ofVec2f(device.getDepthWidth(), device.getDepthHeight())));
    gui.add(interactiveAreaSize.setup("Interactive Area Size", ofVec2f(device.getDepthWidth(), device.getDepthHeight()), ofVec2f(0,0), ofVec2f(device.getDepthWidth(), device.getDepthHeight())));
            

    nearHandThreshold.addListener(this, &ofApp::onHandThresholdChanged);
    farHandThreshold.addListener(this, &ofApp::onHandThresholdChanged);
    nearDepthClipping.addListener(this, &ofApp::onDepthClippingChanged);
    farDepthClipping.addListener(this, &ofApp::onDepthClippingChanged);
    
    guiShow = true;
    
    gui.loadFromFile("settings.xml");
    
    // Generate interactive area mask
    ofImage mask;
    mask.allocate(device.getDepthWidth(), device.getDepthHeight(), OF_IMAGE_GRAYSCALE);
    ofRectangle interactiveArea = ofRectangle(interactiveAreaPos->x, interactiveAreaPos->y, interactiveAreaSize->x, interactiveAreaSize->y);
    for(int i=0; i<mask.getWidth()*mask.getHeight(); i++){
        if(interactiveArea.inside(i%(int)mask.getWidth(), i/mask.getWidth())){
            mask.setColor(i%(int)mask.getWidth(), i/mask.getWidth(), ofColor::white);
        }
        else {
            mask.setColor(i%(int)mask.getWidth(), i/mask.getWidth(), ofColor::black);
        }
    }
    mask.save("activeAreaMask.png");
    
    // OSC
    oscSender.setup(oscHost, oscPort);
    
    detectHands.setup(&cam.getDepthImage(), cam.getDepthImage().getWidth(), cam.getDepthImage().getHeight(), nearHandThreshold, farHandThreshold);
    depthImage = &cam.getDepthImage();
    
}

//--------------------------------------------------------------
void ofApp::update(){
    
    // Camera
    cam.update();
    
    // Set pixels nearest than near threshold to black
    for(int i=0; i<depthImage->getWidth()*depthImage->getHeight(); i++){
        if(depthImage->getPixels()[i] == 255){
            depthImage->getPixels()[i] = 0;
        }
    }
    
    // Hand tracker
    detectHands.update();
    
    
    // OSC
    // Create new message
    ofxOscMessage m;
    
    // Send number of hands tracked
    m.setAddress("/handTracker/handsTracked");
    m.addIntArg(detectHands.getHands().size());
    // Send message to osc
    oscSender.sendMessage(m);
    // Clear message to be able to reuse it
    m.clear();
    
    ofRectangle interactiveArea = ofRectangle(interactiveAreaPos->x, interactiveAreaPos->y, interactiveAreaSize->x, interactiveAreaSize->y);
    
    // Send hands positions
    for(int i=0; i<detectHands.getHands().size(); i++){
        if(interactiveArea.inside(detectHands.getHands()[i].palmCenter)){
            // Set address with hand id
            m.setAddress("/handTracker/hand" + ofToString(i));
            // Args are palm center x and y positions
            m.addFloatArg(ofMap(detectHands.getHands()[i].palmCenter.x, interactiveAreaPos->x, interactiveAreaPos->x + interactiveAreaSize->x, 0, 1));
            m.addFloatArg(ofMap(detectHands.getHands()[i].palmCenter.y, interactiveAreaPos->y, interactiveAreaPos->y + interactiveAreaSize->y, 0, 1));
            // Send message to osc
            oscSender.sendMessage(m);
            // Clear message to be able to reuse it
            m.clear();
        }
    }
    
}

//--------------------------------------------------------------
void ofApp::draw(){

    ofSetWindowTitle(ofToString(ofGetFrameRate()));
    
    ofBackground(0);
    
    int anchor = 10 + gui.getWidth() + 10;
    
    depthImage->update();
    depthImage->draw(anchor, 0);
    //cam.getDepthImage().draw(anchor, 0);
    
    device.getColorImage().draw(anchor + cam.getDepthImage().getWidth(),0, device.getColorImage().getWidth()/2, device.getColorImage().getHeight()/2);
    
    ofPushStyle();
    ofNoFill();
    ofSetLineWidth(2);
    ofSetColor(ofColor::red);
    ofDrawRectangle(anchor + interactiveAreaPos->x, interactiveAreaPos->y, interactiveAreaSize->x, interactiveAreaSize->y);
    ofPopStyle();
    
//    cam.getColorImage().draw(0, cam.getDepthImage().getHeight(), 1920/3, 1080/3);
//    device.getRegImage().draw(512, 424);
    
    detectHands.drawOverlay(anchor,0,cam.getDepthImage().getWidth(),cam.getDepthImage().getHeight());
    //detectHands.drawProcess(anchor,0,cam.getDepthImage().getWidth(),cam.getDepthImage().getHeight());
    
    gui.draw();

     

}

//--------------------------------------------------------------
void ofApp::exit(){
    gui.saveToFile("settings.xml");
}


//--------------------------------------------------------------
void ofApp::keyPressed(int key){
    

}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){
    
    switch(key){
        case 'd':
        case 'D':
            guiShow = !guiShow;
            break;
            
        default:
            break;
    }
    
}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseEntered(int x, int y){

}

//--------------------------------------------------------------
void ofApp::mouseExited(int x, int y){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}

//--------------------------------------------------------------
void ofApp::onDepthClippingChanged(int& parameter){
    device.setDepthClipping(nearDepthClipping, farDepthClipping);
}

//--------------------------------------------------------------
void ofApp::onHandThresholdChanged(int& parameter){
    detectHands.setTresholds(nearHandThreshold, farHandThreshold);
}

