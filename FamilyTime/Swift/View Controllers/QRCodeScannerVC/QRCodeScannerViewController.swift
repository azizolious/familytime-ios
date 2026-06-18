import UIKit
import AVFoundation

class QRCodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var blurEffectView: UIVisualEffectView!
    var overlayView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOverlay()
        setupBlurEffect()
        checkCameraAccess()
    }
    
    private func setupOverlay() {
        overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.9) // Semi-transparent black
        view.addSubview(overlayView)
    }
    
    private func setupBlurEffect() {
        
        // Create a square mask for the camera view
        let maskLayer = CAShapeLayer()
        let squarePath = UIBezierPath(rect: CGRect(x: (view.bounds.width - 250) / 2, y: (view.bounds.height - 250) / 2, width: 250, height: 250))
        let path = UIBezierPath(rect: view.bounds)
        path.append(squarePath.reversing())
        maskLayer.path = path.cgPath
    }
    
    private func checkCameraAccess() {
        captureSession = AVCaptureSession()

        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            configureCameraInput() // Proceed to configure the camera if authorized
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.configureCameraInput()
                    } else {
                        self?.navigateBack()
                    }
                }
            }
        case .denied:
            showAlertForDeniedPermission()
        case .restricted:
            showAlertForRestrictedPermission()
        default:
            break
        }
    }
    
    private func navigateBack() {
        // Check if the view controller is part of a navigation stack
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil) // Fallback for modal presentation
        }
    }
    
    private func showAlertForDeniedPermission() {
        
        let alert = UIAlertController(
            title: "camera_access_denied".localized,
            message: "enable_camera_access".localized,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "cancel_button".localized, style: .default, handler: {_ in
            self.navigateBack()
            
        }))
        
        alert.addAction(UIAlertAction(title: "open_settings".localized, style: .default, handler: { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }))
        
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showAlertForRestrictedPermission() {
        let alert = UIAlertController(
            title: "camera_access_restricted".localized,
            message: "camera_access_restricted_device".localized,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "ok_button".localized, style: .default, handler: {_ in
            self.navigateBack()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func configureCameraInput() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            return
        }
        
        // Create the preview layer for the camera
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: (view.bounds.width - 250) / 2, y: (view.bounds.height - 250) / 2, width: 250, height: 250)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        DispatchQueue.main.async {
            self.captureSession.startRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            
            // Extract the part of the string before the newline character
            let extractString = stringValue.components(separatedBy: "\n").first ?? stringValue
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            captureSession.stopRunning()
            
            if extractString.hasPrefix("FT-PREMIUM-PREPAID-") {
                handleSubscription(code: extractString)
            } else {
                showAlert(alertTitle: "invalid_code".localized, alertMessage: "")
            }
        }
    }
    
    private func handleSubscription(code: String) {
        SwiftFTUtils.showHUDAdded(to: view, withText: "Reloading...".localized, animated: true)
        debugPrint("qr code get: ", code)
        HLApiManager.prePaidSubscriptionApiCall(code: code) { error in
            SwiftFTUtils.hideHUDAdded(to: self.view, animated: true)
            if error == nil {
                self.showAlert(alertTitle: "", alertMessage: "processing_subscription".localized)
                NotificationCenter.default.post(name: Notification.Name("pre_paid_subscription_observer"), object: nil)
            } else {
                self.showAlert(alertTitle: "failure".localized, alertMessage: error ?? "")
            }
        }
    }
    
    private func showAlert(alertTitle: String, alertMessage: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok_button".localized, style: .default, handler: { _ in
            // Check if the view controller is part of a navigation stack
            if let navigationController = self.navigationController {
                navigationController.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil) // Fallback for modal presentation
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        if self.isMovingFromParent {
            if captureSession != nil && captureSession.isRunning {
                captureSession.stopRunning()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear called")
        NotificationCenter.default.addObserver(self, selector: #selector(checkCameraPermission), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc private func checkCameraPermission() {
        checkCameraAccess() // Check camera permission when the app becomes active
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
