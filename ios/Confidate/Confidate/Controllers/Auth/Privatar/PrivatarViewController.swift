//
//  PrivatarViewController.swift
//  Confidate
//
//  Created by Maxim Perehod on 09.03.2024.
//

import UIKit

final class PrivatarViewController: UIViewController {
    private let viewModel: PrivatarViewModel
    
    init(viewModel: PrivatarViewModel) {
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
    
    // MARK: - UI Components
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: Consts.initialImageName1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var regenerateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Regenerate", for: .normal)
        button.backgroundColor = .label
        button.tintColor = .systemBackground
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(regenerateTouchUpInside), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var connectAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Connect\nAccount", for: .normal)
        button.backgroundColor = .label
        button.tintColor = .systemBackground
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(connectAccountUpInside), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // GENERATE
        setupUI()
    }
    
    // MARK: - Setup UI components
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupImageView()
        setupRegenerateButton()
        setupConnectAccountButton()
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 32).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 32).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1).isActive = true
    }
    
    private func setupRegenerateButton() {
        view.addSubview(regenerateButton)
        regenerateButton.heightAnchor.constraint(equalToConstant: 45)
            .isActive = true
        regenerateButton.widthAnchor.constraint(equalToConstant: 120)
            .isActive = true
        regenerateButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -32)
            .isActive = true
        regenerateButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 32)
            .isActive = true
    }
    
    private func setupConnectAccountButton() {
        view.addSubview(connectAccountButton)
        connectAccountButton.heightAnchor.constraint(equalToConstant: 45)
            .isActive = true
        connectAccountButton.widthAnchor.constraint(equalToConstant: 120)
            .isActive = true
        connectAccountButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 32)
            .isActive = true
        connectAccountButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 32)
            .isActive = true
    }
    
   
    // MARK: - Events
    @objc private func regenerateTouchUpInside() {
        viewModel.finishTapped()
    }
    
    @objc private func connectAccountUpInside() {
        viewModel.finishTapped()
    }
    
    
}
