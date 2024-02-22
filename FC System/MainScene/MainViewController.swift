//
//  ViewController.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 11.01.2024.
//

import UIKit
import Firebase
import FirebaseFirestore

final class MainViewController: UIViewController {

    // MARK: - Properties

    private var matches: [Match] = []
    private var news: [News] = []
    private var players: [Player] = []
    private var topNews: [News] = []

    // MARK: - Outlets

    private var timer: Timer!
    private let refreshControl = UIRefreshControl()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.red
        pageControl.pageIndicatorTintColor = UIColor.systemGray
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        return pageControl
    }()

    private lazy var pageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private let matchesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Матчи"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    private lazy var collectionViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.systemGray3.cgColor
        view.layer.shadowOpacity = 10
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MatchViewCell.self, forCellWithReuseIdentifier: MatchViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 15
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        collectionView.layer.masksToBounds = true
        return collectionView
    }()

    private let newsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Новости"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    private lazy var tableViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.systemGray3.cgColor
        view.layer.shadowOpacity = 10
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        return view
    }()

    private lazy var newsTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.sectionHeaderTopPadding = .zero
        tableView.layer.cornerRadius = 15
        return tableView
    }()

    private lazy var showAllNewsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Все новости", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(showAllNewsButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let contentView: UIView = {
        let contentView = UIView ()
        contentView.backgroundColor = .systemMint
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        contentView.backgroundColor = .systemGray6
        setupHierarchy()
        setupLayout()

        fetchNews()
        fetchMatches()
        fetchPlayers()
        fetchTopNews()

        setupPageScrollView()
        startTimer()

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        scrollView.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        scrollView.addGestureRecognizer(swipeRight)

        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        scrollView.refreshControl = refreshControl
    }

    // MARK: - SetupPageControll
    private func setupPageScrollView() {

        for (index, oneNews) in topNews.enumerated() {

            let imageView = ConfigImageView()
            imageView.contentMode = .scaleToFill

            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.tag = index
            imageView.frame = CGRect(x: 0, y: 0, width: pageScrollView.frame.width, height: pageScrollView.frame.height)

            imageView.getImage(url: oneNews.image) { imageSize in
                if let imageSize = imageSize {
                    imageView.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
                }
            }
            pageScrollView.addSubview(imageView)

            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = CGRect(x: 0, y: 0, width: imageView.frame.width * CGFloat(topNews.count), height: 250)
            gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
            gradientLayer.locations = [0, 1]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
            imageView.layer.addSublayer(gradientLayer)

            let label = UILabel()
            label.text = oneNews.title
            label.textColor = .white
            label.textAlignment = .left
            label.font = .systemFont(ofSize: 20, weight: .bold)
            label.translatesAutoresizingMaskIntoConstraints = false
            pageScrollView.addSubview(label)

            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: pageScrollView.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: pageScrollView.leadingAnchor, constant: view.frame.width * CGFloat(index)),
                imageView.widthAnchor.constraint(equalTo: pageScrollView.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: pageScrollView.heightAnchor),

                label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -50),
                label.leadingAnchor.constraint(equalTo: pageScrollView.leadingAnchor, constant: view.frame.width * CGFloat(index)),
                label.widthAnchor.constraint(equalTo: pageScrollView.widthAnchor),
                label.heightAnchor.constraint(equalToConstant: 20)
            ])

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapGesture)

        }

        pageScrollView.contentSize = CGSize(width: pageScrollView.frame.width * CGFloat(topNews.count), height: pageScrollView.frame.height)
    }

    // MARK: - Actions

    @objc private func refreshData() {
        fetchNews()
        fetchMatches()
        fetchPlayers()
        fetchTopNews()
        setupPageScrollView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.scrollView.refreshControl?.endRefreshing()
        }
    }

    @objc private func showAllNewsButtonTapped() {
        UIView.animate(withDuration: 0.2, animations: { 
            self.showAllNewsButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.showAllNewsButton.transform = .identity
            }
        }
        let vc = NewsListViewController(news: news)
        if let navigationController = navigationController {
            navigationController.pushViewController(vc, animated: true)
        }
    }

    @objc private func pageControlTapped(_ sender: UIPageControl) {
        let page = sender.currentPage
        let x = CGFloat(page) * pageScrollView.frame.size.width
        pageScrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }

    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else { return }

        let index = imageView.tag

        guard index >= 0 && index < topNews.count else { return }

        let vc = NewsDetailViewController(news: topNews[index])
        if let navigationController = navigationController {
            navigationController.pushViewController(vc, animated: true)
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(scrollToNextPage), userInfo: nil, repeats: true)
    }

    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left:
            scrollToNextPage()
        case .right:
            scrollToPreviousPage()
        default:
            break
        }
    }

    @objc private func scrollToNextPage() {
        var nextPage = pageControl.currentPage + 1
        if nextPage == topNews.count {
            nextPage = 0
        }
        let x = CGFloat(nextPage) * pageScrollView.frame.size.width
        pageScrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }

    private func scrollToPreviousPage() {
        var previousPage = pageControl.currentPage - 1
        if previousPage < 0 {
            previousPage = topNews.count - 1
        }
        let x = CGFloat(previousPage) * pageScrollView.frame.size.width
        pageScrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }

    // MARK: - FetchData

    private func fetchTopNews() {
        FirestoreService.shared.fetchItems(for: .topNews) { [weak self] (result: Result<[News], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let topNews):
                self.topNews = topNews
                DispatchQueue.main.async {
                    self.setupPageScrollView()
                }
            case .failure(let error):
                print(error)
            }
        }
    }


    private func fetchMatches() {
        FirestoreService.shared.fetchItems(for: .matches) { [weak self] (result: Result<[Match], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let matches):
                self.matches = matches
                self.matches.reverse()
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }

    }

    private func fetchNews() {
        FirestoreService.shared.fetchItems(for: .news) { [weak self] (result: Result<[News], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let news):
                self.news = news
                self.news.reverse()
                DispatchQueue.main.async {
                    self.newsTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    private func fetchPlayers() {
        FirestoreService.shared.fetchItems(for: .players) { [weak self] (result: Result<[Player], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let players):
                self.players = players
            case .failure(let error):
                print(error)
            }
        }
    }

    // MARK: - SetupUI

    private func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(pageScrollView)
        contentView.addSubview(pageControl)
        contentView.addSubview(matchesLabel)
        contentView.addSubview(collectionViewContainer)
        collectionViewContainer.addSubview(collectionView)
        contentView.addSubview(newsLabel)
        contentView.addSubview(tableViewContainer)
        tableViewContainer.addSubview(newsTableView)
        contentView.addSubview(showAllNewsButton)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),


            pageScrollView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 0),
            pageScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pageScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pageScrollView.heightAnchor.constraint(equalToConstant: 250),

            pageControl.bottomAnchor.constraint(equalTo: pageScrollView.bottomAnchor, constant: 0),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            matchesLabel.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 10),
            matchesLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            matchesLabel.heightAnchor.constraint(equalToConstant: 20),

            collectionViewContainer.topAnchor.constraint(equalTo: matchesLabel.bottomAnchor, constant: 10),
            collectionViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionViewContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionViewContainer.heightAnchor.constraint(equalToConstant: 200),

            collectionView.topAnchor.constraint(equalTo: collectionViewContainer.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: collectionViewContainer.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: collectionViewContainer.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: collectionViewContainer.bottomAnchor),

            newsLabel.topAnchor.constraint(equalTo: collectionViewContainer.bottomAnchor, constant: 20),
            newsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            newsLabel.heightAnchor.constraint(equalToConstant: 20),
            newsLabel.widthAnchor.constraint(equalToConstant: 150),

            tableViewContainer.topAnchor.constraint(equalTo: newsLabel.bottomAnchor, constant: 10),
            tableViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tableViewContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tableViewContainer.heightAnchor.constraint(equalToConstant: 750),

            newsTableView.topAnchor.constraint(equalTo: tableViewContainer.topAnchor),
            newsTableView.leadingAnchor.constraint(equalTo: tableViewContainer.leadingAnchor),
            newsTableView.trailingAnchor.constraint(equalTo: tableViewContainer.trailingAnchor),
            newsTableView.bottomAnchor.constraint(equalTo: tableViewContainer.bottomAnchor),

            showAllNewsButton.bottomAnchor.constraint(equalTo: newsTableView.topAnchor, constant: -10),
            showAllNewsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            showAllNewsButton.heightAnchor.constraint(equalToConstant: 10),
            showAllNewsButton.widthAnchor.constraint(equalToConstant: 100),

            newsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as! NewsTableViewCell
        let news = news[indexPath.item]
        cell.configure(news: news)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let news = news[indexPath.item]
        let vc = NewsDetailViewController(news: news)
        if let navigationController = navigationController {
            navigationController.pushViewController(vc, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        250
    }
}


extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        matches.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MatchViewCell.identifier, for: indexPath) as? MatchViewCell else { return UICollectionViewCell() }
        let match = matches[indexPath.item]
        cell.configure(match: match)
        cell.layer.cornerRadius = 15
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 220, height: 170)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        15
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        15
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let match = matches[indexPath.item]
        let vc = MatchCenterViewController(match: match, players: players)
        if let navigationController = navigationController {
            navigationController.pushViewController(vc, animated: true)
        }
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}



// MARK: - Properties
// MARK: - Outlets
// MARK: - Lifecycles
// MARK: - SetupUI
// MARK: - FetchData
// MARK: - Actions
// MARK: - Initializers
// MARK: - Binding
// MARK: - ConfigureCell


//[weak self]
//guard let self = self else { return }
