//
//  FootballFieldViewController.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 24.01.2024.
//

import Foundation
import UIKit

final class FootballFieldViewController: UIViewController {

    // MARK: - Properties

    private var players: [UIView] = []
    private var opponents: [UIView] = []
    private var ballImageView: UIImageView?
    private let drawingView = DrawingView()
    private var ballCoordinate: CGPoint = CGPoint(x: 184, y: 460)
    private let playerCoordinates: [CGPoint] = [
        CGPoint(x: 184, y: 125),
        CGPoint(x: 28, y: 254),
        CGPoint(x: 184, y: 254),
        CGPoint(x: 340, y: 254),
        CGPoint(x: 28, y: 358),
        CGPoint(x: 184, y: 358),
        CGPoint(x: 340, y: 358),
        CGPoint(x: 184, y: 419),

    ]
    private let opponentCoordinates: [CGPoint] = [
        CGPoint(x: 184, y: 797),
        CGPoint(x: 28, y: 667),
        CGPoint(x: 184, y: 667),
        CGPoint(x: 340, y: 667),
        CGPoint(x: 28, y: 577),
        CGPoint(x: 184, y: 577),
        CGPoint(x: 340, y: 577),
        CGPoint(x: 184, y: 529),
    ]

    // MARK: - Outlets

    private let footballFieldImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "fieldHD"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var clearDrawingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "eraser"), for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(clearDrawing), for: .touchUpInside)
        return button
    }()

    private lazy var resetPositionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "updateIcon"), for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(resetPositions), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 253/255, green: 243/255, blue: 120/255, alpha: 1)
        view.addSubview(drawingView)
        setupUI()
        addPlayers()
        addOpponents()
        addBall()
        drawingView.frame = CGRect(x: 50, y: 100, width: 300, height: 400)
    }

    // MARK: - SetupUI

    private func setupUI() {
        view.addSubview(footballFieldImageView)
        view.addSubview(drawingView)
        view.addSubview(clearDrawingButton)
        view.addSubview(resetPositionButton)
        footballFieldImageView.translatesAutoresizingMaskIntoConstraints = false
        drawingView.translatesAutoresizingMaskIntoConstraints = false
        clearDrawingButton.translatesAutoresizingMaskIntoConstraints = false
        resetPositionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            footballFieldImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            footballFieldImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            footballFieldImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            footballFieldImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            drawingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            drawingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            drawingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            drawingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            clearDrawingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            clearDrawingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            clearDrawingButton.widthAnchor.constraint(equalToConstant: 30),
            clearDrawingButton.heightAnchor.constraint(equalToConstant: 30),
            resetPositionButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            resetPositionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            resetPositionButton.widthAnchor.constraint(equalToConstant: 30),
            resetPositionButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    // MARK: - Actions

    @objc private func addPlayers() {
        for (index, position) in playerCoordinates.enumerated() {
            let player = createPlayer(at: position, index: index)
            view.addSubview(player)
            players.append(player)
        }
    }

    @objc private func addOpponents() {
        for (index, position) in opponentCoordinates.enumerated() {
            let opponent = createOpponent(at: position, index: index)
            view.addSubview(opponent)
            opponents.append(opponent)
        }
    }

    @objc private func addBall() {
        if ballImageView == nil {
            let ball = createBall(at: ballCoordinate)
            ballImageView = ball
            view.addSubview(ball)
        }
    }

    private func createPlayer(at position: CGPoint, index: Int) -> UIView {
        let playerView = UIView(frame: CGRect(origin: position, size: CGSize(width: 30, height: 30)))
        playerView.backgroundColor = .systemBlue
        playerView.layer.cornerRadius = 15
        playerView.layer.borderWidth = 1
        playerView.layer.borderColor = UIColor.white.cgColor
        playerView.isUserInteractionEnabled = true

        let numberLabel = UILabel(frame: playerView.bounds)
        numberLabel.text = "\(index + 1)"
        numberLabel.textColor = .white
        numberLabel.textAlignment = .center
        playerView.addSubview(numberLabel)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        playerView.addGestureRecognizer(panGesture)
        return playerView
    }

    private func createOpponent(at position: CGPoint, index: Int) -> UIView {
        let opponentView = UIView(frame: CGRect(origin: position, size: CGSize(width: 30, height: 30)))
        opponentView.backgroundColor = .red
        opponentView.layer.cornerRadius = 15
        opponentView.layer.borderWidth = 1
        opponentView.layer.borderColor = UIColor.white.cgColor
        opponentView.isUserInteractionEnabled = true

        let numberLabel = UILabel(frame: opponentView.bounds)
        numberLabel.text = "\(index + 1)"
        numberLabel.textColor = .white
        numberLabel.textAlignment = .center
        opponentView.addSubview(numberLabel)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        opponentView.addGestureRecognizer(panGesture)
        return opponentView
    }

    private func createBall(at position: CGPoint) -> UIImageView {
        let ballImageView = UIImageView(image: UIImage(named: "ballFieldCL"))
        ballImageView.frame = CGRect(origin: position, size: CGSize(width: 30, height: 30))
        ballImageView.isUserInteractionEnabled = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        ballImageView.addGestureRecognizer(panGesture)
        return ballImageView
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let playerView = gesture.view else { return }

        let translation = gesture.translation(in: view)
        gesture.setTranslation(.zero, in: view)

        var center = playerView.center
        center.x += translation.x
        center.y += translation.y
        playerView.center = center
    }

    @objc private func clearDrawing() {
        drawingView.clearDrawing()
    }

    @objc private func resetPositions() {
        for (index, position) in playerCoordinates.enumerated() {
            players[index].frame.origin = position
        }

        for (index, position) in opponentCoordinates.enumerated() {
            opponents[index].frame.origin = position
        }

        if let ball = ballImageView {
            ball.frame.origin = ballCoordinate
        }
    }
}



