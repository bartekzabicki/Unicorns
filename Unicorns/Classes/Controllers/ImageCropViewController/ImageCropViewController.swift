//
//  ImageCropViewController.swift
//  Unicorns
//
//  Created by Bartek Żabicki on 29.04.2018.
//

import UIKit

public protocol ImageCropRouter: class {
  func routeToCropImage(viewModel: ImageCropViewController.ViewModel)
}

public extension ImageCropRouter where Self: UIViewController {
  
  func routeToCropImage(viewModel: ImageCropViewController.ViewModel) {
    let bundle = Bundle(for: ImageCropViewController.classForCoder())
    let controller = ImageCropViewController(nibName: ImageCropViewController.reuseIdentifier, bundle: bundle)
    controller.setup(with: viewModel)
    controller.modalPresentationStyle = .overFullScreen
    present(controller, animated: true, completion: nil)
  }
  
}

public protocol ImageCropDelegate: class {
  func didCancelCrop(image: UIImage?)
  func didCropImage(to: UIImage?)
}

public final class ImageCropViewController: UIViewController {
  
  // MARK: - Structures
  
  public struct ViewModel {
    var image: UIImage
    var rectType: RectType
    weak var delegate: ImageCropDelegate?
    
    public init(image: UIImage, rectType: RectType, delegate: ImageCropDelegate?) {
      self.image = image
      self.rectType = rectType
      self.delegate = delegate
    }
  }
  
  // MARK: - Outlets
  
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet var imageView: UIImageView!
  @IBOutlet weak var cropView: UIView!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var acceptButton: UIButton!
  
  // MARK: - Properties
  
  private var viewModel: ViewModel?
  private var shapePath: CGMutablePath?
  
  // MARK: - Lifecycle
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    view.alpha = 0
    imageView.image = viewModel?.image
    scrollView.maximumZoomScale = 4
    scrollView.minimumZoomScale = 1
    scrollView.clipsToBounds = true
    scrollView.bouncesZoom = true
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupMaskView()
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.view.alpha = 1
    }
  }
  
  // MARK: - Actions
  
  @IBAction func cancelButtonAction(_ sender: UIButton) {
    viewModel?.delegate?.didCancelCrop(image: viewModel?.image)
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func acceptButtonAction(_ sender: UIButton) {
    guard let image = imageView.image, let path = shapePath else { return }
    let bezier = UIBezierPath(cgPath: path)
    let croppedImage = crop(image: image, in: scrollView, to: bezier)
    viewModel?.delegate?.didCropImage(to: croppedImage)
    dismiss(animated: true, completion: nil)
  }
  
  // MARK: - Functions
  
  func setup(with viewModel: ViewModel) {
    self.viewModel = viewModel
  }
  
  private func setupMaskView() {
    guard let viewModel = viewModel else { return }
    cropView.backgroundColor = .black
    cropView.alpha = 0.6
    cropView.layer.mask = generateMaskLayer(with: viewModel)
    cropView.clipsToBounds = true
    cropView.isUserInteractionEnabled = false
  }
  
  private func generateMaskLayer(with: ViewModel) -> CAShapeLayer {
    let layer = CAShapeLayer()
    shapePath = viewModel?.rectType.shapePath(in: scrollView)
    shapePath = scaled(path: shapePath)
    let path = shapePath?.mutableCopy()
    path?.addRect(CGRect(x: 0, y: 0, width: cropView.bounds.width, height: cropView.bounds.height+50))
    layer.path = path
    layer.fillRule = .evenOdd
    layer.backgroundColor = UIColor.black.cgColor
    return layer
  }
  
  private func crop(image: UIImage, in scrollView: UIScrollView, to path: UIBezierPath ) -> UIImage? {
    let scale = 1/scrollView.zoomScale
    let factor = imageView.image!.size.width/view.frame.width
    let imageFrame = imageView.imageFrame()
    let x = (scrollView.contentOffset.x + path.bounds.origin.x - imageFrame.origin.x) * scale * factor
    let y = (scrollView.contentOffset.y + path.bounds.origin.y - imageFrame.origin.y) * scale * factor
    let width =  path.bounds.width  * scale * factor
    let height = path.bounds.height  * scale * factor
    let cropArea = CGRect(x: x, y: y, width: width, height: height)
    guard let croppedCGImage = imageView.image?.cgImage?.cropping(to: cropArea) else {
      Log.e("Cannot crop outside of image")
      return image
    }
    let croppedImage = UIImage(cgImage: croppedCGImage)
    return croppedImage
  }
  
  private func scaled(path: CGMutablePath?) -> CGMutablePath? {
    guard let path = path else {
      return nil
    }
    let bezierPath = UIBezierPath(cgPath: path)
    let imageFrame = imageView.imageFrame()
    if bezierPath.bounds.size > imageFrame.size {
      var scale: CGFloat
      if bezierPath.bounds.width > imageFrame.size.width {
        scale = imageFrame.size.width/bezierPath.bounds.width
      } else {
        scale = imageFrame.size.height/bezierPath.bounds.height
      }
      let translatedBounds = bezierPath.bounds.applying(CGAffineTransform(scaleX: scale, y: scale))
      let translatedX = (bezierPath.bounds.size.width - translatedBounds.size.width)/2 + bezierPath.bounds.origin.x - translatedBounds.origin.x
      let translatedY = (bezierPath.bounds.size.height - translatedBounds.size.height)/2 + bezierPath.bounds.origin.y - translatedBounds.origin.y
      
      bezierPath.apply(CGAffineTransform(scaleX: scale, y: scale))
      bezierPath.apply(CGAffineTransform(translationX: translatedX, y: translatedY))
    }
    return bezierPath.cgPath.mutableCopy()
  }
  
}

extension UIImageView
{
  func imageFrame()->CGRect
  {
    let imageViewSize = self.frame.size
    guard let imageSize = self.image?.size else
    {
      return CGRect.zero
    }
    let imageRatio = imageSize.width / imageSize.height
    let imageViewRatio = imageViewSize.width / imageViewSize.height
    if imageRatio < imageViewRatio
    {
      let scaleFactor = imageViewSize.height / imageSize.height
      let width = imageSize.width * scaleFactor
      let topLeftX = (imageViewSize.width - width) * 0.5
      return CGRect(x: topLeftX, y: 0, width: width, height: imageViewSize.height)
    }
    else
    {
      let scalFactor = imageViewSize.width / imageSize.width
      let height = imageSize.height * scalFactor
      let topLeftY = (imageViewSize.height - height) * 0.5
      return CGRect(x: 0, y: topLeftY, width: imageViewSize.width, height: height)
    }
  }
}

// MARK: - UIScrollViewDelegate

extension ImageCropViewController: UIScrollViewDelegate {
  
  public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
  
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {}
  
  public func scrollViewDidZoom(_ scrollView: UIScrollView) {}
  
  public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    checkIfCircleIsOnImage()
  }
  
  public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
    checkIfCircleIsOnImage()
  }
  
  @discardableResult
  private func checkIfCircleIsOnImage() -> Bool {
    guard let shapePath = shapePath else {
      Log.e("Shape path cannot be nil")
      return false
    }
    Log.e("\(imageView.imageFrame().contains(shapePath.boundingBox))")
    Log.i("\(shapePath.boundingBox)")
    return true
  }
  
}

// MARK: - Shapes extension

extension ImageCropViewController {
  
  public enum RectType {
    case round
    case square
    case roundedCornersSquare
    case custom(CGPath)
    
    func shapePath(in view: UIView) -> CGMutablePath? {
      let viewMargin: CGFloat = 40
      let yOrigin = view.center.y
      let availableWidth = view.bounds.width - 2*viewMargin
      let mutalbePath = CGMutablePath()
      switch self {
      case .round:
        mutalbePath.addArc(center: view.center,
                           radius: availableWidth/2,
                           startAngle: 270.asRadian(),
                           endAngle: 270.asRadian(),
                           clockwise: true,
                           transform: .identity)
      case .square:
        mutalbePath.addRect(CGRect(x: viewMargin, y: yOrigin - availableWidth/2, width: availableWidth, height: availableWidth))
      case .roundedCornersSquare:
        mutalbePath.addRoundedRect(in: CGRect(x: viewMargin,
                                              y: yOrigin - availableWidth/2,
                                              width: availableWidth,
                                              height: availableWidth), cornerWidth: availableWidth*0.1, cornerHeight: availableWidth*0.1)
      case .custom(let customPath):
        return customPath.mutableCopy()
      }
      mutalbePath.closeSubpath()
      return mutalbePath
    }
    
  }
  
}
