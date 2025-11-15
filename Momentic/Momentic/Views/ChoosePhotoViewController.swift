//
//  ChoosePhotoViewController.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 4.11.25.
//

import UIKit
import PhotosUI

final class ChoosePhotoViewController: UIViewController {
    
    //MARK: - Properties
    
    var completionHandler: ((Result<UIImage, Error>) -> Void)?
    
    //MARK: - Constants
    
    private enum Constants {
        
        //MARK: - Constraints
        
        static let backButtonSize: CGFloat = 44
        static let backButtonLeadingSpacing: CGFloat = 16
        static let backButtonTopSpacing: CGFloat = 16
        
        static let checkmarkButtonSize: CGFloat = 32
        static let checkmarkButtonTrailingSpacing: CGFloat = 16
        static let checkmarkButtonTopSpacing: CGFloat = 16
        
        static let titleLabelTopSpacing: CGFloat = 16
        
        static let imageViewTopSpacing: CGFloat = 153
        
        //MARK: - Values
        
        static let titleLabelFontSize: CGFloat = 26
        static let backButtonIconSize: CGFloat = 32
        static let checkmarkButtonIconSize: CGFloat = 32
        static let overlayAlpha: CGFloat = 0.65
    }
    
    //MARK: - UI Properties
    
    private let backButton: UIButton = UIButton(type: .system)
    private let checkmarkButton: UIButton = UIButton(type: .system)
    private let titleLabel: UILabel = UILabel()
    private let photoImageView: UIImageView = UIImageView()
    private let overlayView: UIView = UIView()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.openPhotoPicker()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCircularMask()
    }
}

//MARK: - Setup UI
private extension ChoosePhotoViewController {
    func setupUI() {
        setupViewHierarchy()
        setupConstraints()
        configureViews()
    }
    
    func setupViewHierarchy() {
        [backButton, checkmarkButton, titleLabel, photoImageView, overlayView].forEach {
            view.addSubview($0)
        }
    }
    
    func setupConstraints() {
        [backButton, checkmarkButton, titleLabel, photoImageView, overlayView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.backButtonLeadingSpacing),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.backButtonTopSpacing),
            backButton.widthAnchor.constraint(equalToConstant: Constants.backButtonSize),
            backButton.heightAnchor.constraint(equalToConstant: Constants.backButtonSize),
            
            checkmarkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.checkmarkButtonTrailingSpacing),
            checkmarkButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.checkmarkButtonTopSpacing),
            checkmarkButton.widthAnchor.constraint(equalToConstant: Constants.checkmarkButtonSize),
            checkmarkButton.heightAnchor.constraint(equalToConstant: Constants.checkmarkButtonSize),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            
            photoImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.imageViewTopSpacing),
            photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor),
            
            overlayView.topAnchor.constraint(equalTo: photoImageView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor),
        ])
    }
    
    func configureViews() {
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = UIColor(named: "main")
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        checkmarkButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        checkmarkButton.tintColor = UIColor(named: "lightGreen")
        checkmarkButton.addTarget(self, action: #selector(checkmarkButtonTapped), for: .touchUpInside)
        checkmarkButton.isEnabled = false
        
        titleLabel.text = NSLocalizedString("add_photo_title", comment: "Add photo")
        titleLabel.font = .readexPro(size: Constants.titleLabelFontSize, weight: .medium)
        titleLabel.textColor = UIColor(named: "main")
        titleLabel.textAlignment = .center
        
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        photoImageView.backgroundColor = .clear
        
        overlayView.backgroundColor = UIColor(named: "pickerGray")?.withAlphaComponent(Constants.overlayAlpha)
        overlayView.isUserInteractionEnabled = false
        overlayView.isHidden = true
    }
    
    func updateCircularMask() {
        guard !overlayView.isHidden else { return }
        
        let maskLayer = CAShapeLayer()
        let bounds = overlayView.bounds
        let circlePath = UIBezierPath(rect: bounds)
        
        let circleSize = min(bounds.width, bounds.height)
        let circleRect = CGRect(
            x: (bounds.width - circleSize) / 2,
            y: (bounds.height - circleSize) / 2,
            width: circleSize,
            height: circleSize
        )
        let circleCutout = UIBezierPath(ovalIn: circleRect)
        
        circlePath.append(circleCutout)
        circlePath.usesEvenOddFillRule = true
        
        maskLayer.path = circlePath.cgPath
        maskLayer.fillRule = .evenOdd
        
        overlayView.layer.mask = maskLayer
    }
}

//MARK: - Selectors
private extension ChoosePhotoViewController {
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func checkmarkButtonTapped() {
        guard let image = photoImageView.image else { return }
        
        let croppedImage = cropToCircle(image: image)
        completionHandler?(.success(croppedImage))
        dismiss(animated: true)
    }
    
    func cropToCircle(image: UIImage) -> UIImage {
        let imageSize = image.size
        let diameter = min(imageSize.width, imageSize.height)
        let isLandscape = imageSize.width > imageSize.height
        
        let xOffset = isLandscape ? (imageSize.width - diameter) / 2 : 0
        let yOffset = isLandscape ? 0 : (imageSize.height - diameter) / 2
        
        let imageRef = image.cgImage!.cropping(to: CGRect(x: xOffset * image.scale,
                                                           y: yOffset * image.scale,
                                                           width: diameter * image.scale,
                                                           height: diameter * image.scale))
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = image.scale
        format.opaque = false
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: diameter, height: diameter), format: format)
        
        let circularImage = renderer.image { context in
            let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
            UIBezierPath(ovalIn: rect).addClip()
            
            if let imageRef = imageRef {
                UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation).draw(in: rect)
            }
        }
        
        return circularImage
    }
}

//MARK: - Photo Picker
private extension ChoosePhotoViewController {
    func openPhotoPicker() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("take_photo", comment: "Take photo"), style: .default) { [weak self] _ in
            self?.checkCameraPermission()
        })
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("choose_from_gallery", comment: "Choose from gallery"), style: .default) { [weak self] _ in
            self?.openPhotoGallery()
        })
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: "Cancel"), style: .cancel) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        present(alert, animated: true)
    }
    
    func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            openCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.openCamera()
                    } else {
                        self?.showPermissionDeniedAlert(for: .camera)
                    }
                }
            }
        case .denied, .restricted:
            showPermissionDeniedAlert(for: .camera)
        @unknown default:
            break
        }
    }
    
    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showAlert(title: NSLocalizedString("camera_not_available", comment: "Camera not available"),
                     message: NSLocalizedString("camera_not_available_message", comment: "Camera is not available on this device"))
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func openPhotoGallery() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func showPermissionDeniedAlert(for type: PermissionType) {
        let title = type == .camera ?
            NSLocalizedString("camera_permission_denied", comment: "Camera permission denied") :
            NSLocalizedString("photo_permission_denied", comment: "Photo permission denied")
        
        let message = type == .camera ?
            NSLocalizedString("camera_permission_denied_message", comment: "Please enable camera access in Settings") :
            NSLocalizedString("photo_permission_denied_message", comment: "Please enable photo access in Settings")
        
        showAlert(title: title, message: message, showSettings: true)
    }
    
    func showAlert(title: String, message: String, showSettings: Bool = false) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if showSettings {
            alert.addAction(UIAlertAction(title: NSLocalizedString("settings", comment: "Settings"), style: .default) { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            })
        }
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: "Cancel"), style: .cancel) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        
        present(alert, animated: true)
    }
}

//MARK: - UIImagePickerControllerDelegate
extension ChoosePhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                self?.displaySelectedPhoto(image)
            } else {
                self?.completionHandler?(.failure(PhotoError.invalidImage))
                self?.dismiss(animated: true)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { [weak self] in
            self?.dismiss(animated: true)
        }
    }
}

//MARK: - PHPickerViewControllerDelegate
extension ChoosePhotoViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let provider = results.first?.itemProvider else {
            dismiss(animated: true)
            return
        }
        
        if provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self?.completionHandler?(.failure(error))
                        self?.dismiss(animated: true)
                    } else if let image = image as? UIImage {
                        self?.displaySelectedPhoto(image)
                    } else {
                        self?.completionHandler?(.failure(PhotoError.invalidImage))
                        self?.dismiss(animated: true)
                    }
                }
            }
        }
    }
}

//MARK: - Helper Methods
private extension ChoosePhotoViewController {
    func displaySelectedPhoto(_ image: UIImage) {
        photoImageView.image = image
        overlayView.isHidden = false
        checkmarkButton.isEnabled = true
        
        DispatchQueue.main.async { [weak self] in
            self?.updateCircularMask()
        }
    }
}

//MARK: - PermissionType
private enum PermissionType {
    case camera
    case photos
}
