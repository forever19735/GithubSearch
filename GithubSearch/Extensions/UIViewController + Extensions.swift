//
//  UIViewController + Extensions.swift
//  CubeTest
//
//  Created by 季紅 on 2024/10/27.
//
import UIKit

private var loadingIndicatorKey: UInt8 = 0

extension UIViewController {
    func setupNavigationBar(title: String?, textColor: UIColor = UIColor(hex: "#1B212B"), backgroundColor: UIColor = .whiteTwo) {
        navigationItem.title = title
        navigationController?.navigationBar.prefersLargeTitles = true
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.font(.pingFangBold, fontSize: 14),
                                                         .foregroundColor: textColor]

        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = backgroundColor
        barAppearance.titleTextAttributes = attributes
        barAppearance.shadowColor = nil
        navigationController?.navigationBar.standardAppearance = barAppearance
        navigationController?.navigationBar.compactAppearance = barAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
    }

    private var loadingIndicator: UIActivityIndicatorView {
        if let indicator = objc_getAssociatedObject(self, &loadingIndicatorKey) as? UIActivityIndicatorView {
            return indicator
        }
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indicator)

        indicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        objc_setAssociatedObject(self, &loadingIndicatorKey, indicator, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return indicator
    }

    func showLoading() {
        DispatchQueue.main.async {
            self.loadingIndicator.startAnimating()
            self.view.isUserInteractionEnabled = false
        }
    }

    func hideLoading() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
}

extension UINavigationController {
    func updateNavigationBarStyle(
           backgroundColor: UIColor,
           titleColor: UIColor = .label,
           shadowColor: UIColor = .clear
       ) {
           let appearance = UINavigationBarAppearance()
           appearance.configureWithTransparentBackground()
           appearance.backgroundColor = backgroundColor
           appearance.titleTextAttributes = [.foregroundColor: titleColor]
           appearance.shadowColor = shadowColor
           
           navigationBar.standardAppearance = appearance
           navigationBar.scrollEdgeAppearance = appearance
       }
}
