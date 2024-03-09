//
//  WalletConnectViewController.swift
//  Confidate
//
//  Created by Maxim Perehod on 09.03.2024.
//

import UIKit

final class WalletConnectViewController: UIViewController {
    private let viewModel: WalletConnectViewModel
    
    init(viewModel: WalletConnectViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private struct Consts {
        static let initialImageName1 = "initial_image_1"
        static let initialImageName2 = "initial_image_2"
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: Consts.initialImageName1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        title = "Wallet connect"
    }
    
    // MARK: - Setup UI components
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupImageView()
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 32).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 32).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1).isActive = true
    }
    
    // MARK: - Events
    
}

