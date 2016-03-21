#pragma once

#include "ofMain.h"
#include "ofxHandDetect.h"
#include "ofxDepthCameraKinect.h"
#include "ofxDepthCameraProvider.h"
#include "ofxGui.h"
#include "ofxOsc.h"


class ofApp : public ofBaseApp{

public:
    void setup();
    void update();
    void draw();
    void exit();
    
    void keyPressed(int key);
    void keyReleased(int key);
    void mouseMoved(int x, int y );
    void mouseDragged(int x, int y, int button);
    void mousePressed(int x, int y, int button);
    void mouseReleased(int x, int y, int button);
    void mouseEntered(int x, int y);
    void mouseExited(int x, int y);
    void windowResized(int w, int h);
    void dragEvent(ofDragInfo dragInfo);
    void gotMessage(ofMessage msg);
    
    void onDepthClippingChanged(int& parameter);
    void onHandThresholdChanged(int& parameter);
    
    
    ofxDepthCameraKinect device;
    ofxDepthCameraProvider cam;
    
    ofxHandDetect   detectHands;
    int imgIndx = 1;
    
    ofImage* depthImage;
    
    // OSC
    ofxOscSender oscSender;
    
    // GUI / Controlpanel
    bool guiShow;
    ofxPanel gui;
    
    ofxLabel oscHost;
    ofxIntSlider oscPort;
    
    ofxIntSlider   nearHandThreshold;
    ofxIntSlider   farHandThreshold;
    
    ofxIntSlider   nearDepthClipping;
    ofxIntSlider   farDepthClipping;
    
    ofxVec2Slider  interactiveAreaPos;
    ofxVec2Slider  interactiveAreaSize;

		
};
