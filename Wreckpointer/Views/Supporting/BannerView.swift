//
//  BannerView.swift
//  Wreckpointer
//
//  Created by Danylo Ternovoi on 21.01.2024.
//

import GoogleMobileAds
import SwiftUI

struct BannerContentView: View {
    var width: CGFloat = UIScreen.main.bounds.width
    
    var size: CGSize {
        return GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(width).size
    }
    
    var body: some View {
        BannerView()
            .frame( height: size.height)
            .background()
    }
}

private struct BannerView: UIViewControllerRepresentable {
  @State private var viewWidth: CGFloat = .zero
  private let bannerView = GADBannerView()
    private let adUnitID = "ca-app-pub-9448970575693448/8055880538"
    

  func makeUIViewController(context: Context) -> some UIViewController {
    let bannerViewController = BannerViewController()
    bannerView.adUnitID = adUnitID
    bannerView.rootViewController = bannerViewController
    bannerView.delegate = context.coordinator
    bannerView.translatesAutoresizingMaskIntoConstraints = false
    bannerViewController.view.addSubview(bannerView)
    // Constrain GADBannerView to the bottom of the view.
    NSLayoutConstraint.activate([
      bannerView.bottomAnchor.constraint(
        equalTo: bannerViewController.view.safeAreaLayoutGuide.bottomAnchor),
      bannerView.centerXAnchor.constraint(equalTo: bannerViewController.view.centerXAnchor),
    ])
    bannerViewController.delegate = context.coordinator

    return bannerViewController
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    guard viewWidth != .zero else { return }

    bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
    bannerView.load(GADRequest())
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  fileprivate class Coordinator: NSObject, BannerViewControllerWidthDelegate, GADBannerViewDelegate {
    let parent: BannerView

    init(_ parent: BannerView) {
      self.parent = parent
    }

    // MARK: - BannerViewControllerWidthDelegate methods

    func bannerViewController(_ bannerViewController: BannerViewController, didUpdate width: CGFloat) {
      parent.viewWidth = width
    }

    // MARK: - GADBannerViewDelegate methods

    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("DID RECEIVE AD")
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("DID NOT RECEIVE AD: \(error.localizedDescription)")
    }
  }
}

#Preview {
    BannerContentView()
}

protocol BannerViewControllerWidthDelegate: AnyObject {
  func bannerViewController(_ bannerViewController: BannerViewController, didUpdate width: CGFloat)
}

class BannerViewController: UIViewController {

  weak var delegate: BannerViewControllerWidthDelegate?

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    delegate?.bannerViewController(
      self, didUpdate: view.frame.inset(by: view.safeAreaInsets).size.width)
  }

  override func viewWillTransition(
    to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator
  ) {
    coordinator.animate { _ in
      // do nothing
    } completion: { _ in
      self.delegate?.bannerViewController(
        self, didUpdate: self.view.frame.inset(by: self.view.safeAreaInsets).size.width)
    }
  }
}
