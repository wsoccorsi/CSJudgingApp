//Hudson Elledge
import UIKit
import AVFoundation
import Foundation


class QRScannerController: UIViewController
{
    
    @IBOutlet var messageLabel:UILabel!
    @IBOutlet var topbar: UIView!
    @IBOutlet var FeedbackLabel: UILabel!
    
    var API: WebAPI!
    
    var captureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    var ProjectStore: ProjectStore!
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Checks for wide or back facing cameras
        var deviceDiscoverySession: AVCaptureDevice.DiscoverySession
        
        if AVCaptureDevice.default(.builtInDualCamera, for: AVMediaType.video, position: .back) != nil {
            deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        }
        else {
            deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        }
        
        guard let captureDevice = deviceDiscoverySession.devices.first
        else
        {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device
            captureSession.addInput(input)
            
            // Set output
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Has to do with call back not familier
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
        } catch {
            print(error)
            return
        }
        
        // Sets the video preview and adds it as a subview
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture
        captureSession.startRunning()
        
        // Moves the access request to the front of the view
        view.bringSubviewToFront(messageLabel)
        
        FeedbackLabel.isHidden = true
        view.bringSubviewToFront(FeedbackLabel)
        
        // QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView
        {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        captureSession.startRunning()
        
        if (API.isLoggedIn) {
            FeedbackLabel.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Helper methods
    
    func launchApp(decodedURL: String)
    {
        
        if presentedViewController != nil {
            return
        }
        
        captureSession.stopRunning()
        print(decodedURL)
        API.GetQRProject(completion: segueTableView, link:decodedURL)
    }
    
    func segueTableView(projectsResult: ProjectsResult)
    {
        switch projectsResult
        {
            case let .Success(projects):
                
                captureSession.stopRunning()
                
                FeedbackLabel.isHidden = true
                
                ProjectStore.Projects = projects
                
                performSegue(withIdentifier: "mySegueID", sender: self)
            
            case let .Failure(error):
                
                let errorCode = error._code
                
                if(errorCode == 3840)
                {
                    print("\(errorCode): Invalid Web Request")
                    FeedbackLabel.text = "Invalid QR Code"
                }
                else if(errorCode == 401)
                {
                    print("\(errorCode): Invalid Bearer Token")
                    FeedbackLabel.text = "Sign In To Use The Scanner"
                }
                else
                {
                    print("\(error)")
                    FeedbackLabel.text = "Invalid QR Code"
                }
                FeedbackLabel.isHidden = false
                captureSession.startRunning()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "mySegueID"
        {
            let p = ProjectStore.Projects[0]
            
            let DetailsViewController = segue.destination as! DetailsViewController
            DetailsViewController.Project = p
            DetailsViewController.API = API
            
            
        }
        else {
            preconditionFailure("Unexpected Segue Identifier.")
        }
    }
}


extension QRScannerController: AVCaptureMetadataOutputObjectsDelegate
{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection)
    {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0
        {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.]
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type)
        {
            // If the found metadata is equal to the QR code metadata (or barcode) creates the frame and runs the decode
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil
            {
                launchApp(decodedURL: metadataObj.stringValue!)
                messageLabel.text = metadataObj.stringValue
            }
        }
    }    
}
