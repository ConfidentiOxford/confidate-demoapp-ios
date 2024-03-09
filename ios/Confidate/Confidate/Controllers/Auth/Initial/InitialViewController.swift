//
//  InitialViewController.swift
//  Confidate
//
//  Created by Maxim Perehod on 09.03.2024.
//

import UIKit

final class InitialViewController: UIViewController {
    private let viewModel: InitialViewModel
    
    init(viewModel: InitialViewModel) {
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
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Join us today!"
        label.font = .systemFont(ofSize: 45)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.textColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(signUpTouchUpInside), for: .touchUpInside)
        return button
    }()
    
    private let initialImageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: Consts.initialImageName1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let initialImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: Consts.initialImageName2)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        title = "Welcome"
    }
    
    // MARK: - Setup UI components
    
    private func setupUI() {
        view.backgroundColor = .white
        setupNavigationBar()
        setupSignUpButton()
        setupLabel()
        setupInitImageView1()
        setupInitImageView2()
    }
    
    private func setupNavigationBar() {
        let signIn = UIBarButtonItem(title: "Sign in", style: .plain, target: viewModel, action: #selector(viewModel.logInTapped))
        navigationItem.leftBarButtonItems = [signIn]
    }
    
    private func setupSignUpButton() {
        view.addSubview(signUpButton)
        signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -64).isActive = true
        signUpButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        signUpButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    private func setupLabel() {
        view.addSubview(label)
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        label.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -60).isActive = true
    }
    
    private func setupInitImageView1() {
        view.addSubview(initialImageView1)
        initialImageView1.heightAnchor.constraint(equalToConstant: 200).isActive = true
        initialImageView1.widthAnchor.constraint(equalToConstant: 200).isActive = true
        initialImageView1.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -64).isActive = true
        initialImageView1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
    }
    
    private func setupInitImageView2() {
        view.addSubview(initialImageView2)
        initialImageView2.heightAnchor.constraint(equalToConstant: 200).isActive = true
        initialImageView2.widthAnchor.constraint(equalToConstant: 200).isActive = true
        initialImageView2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        initialImageView2.bottomAnchor.constraint(equalTo: initialImageView1.topAnchor, constant: -16).isActive = true
    }
    
    // MARK: - Events
    @objc private func signUpTouchUpInside() { viewModel.signUpTapped() }
    
    func translate(to viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}
