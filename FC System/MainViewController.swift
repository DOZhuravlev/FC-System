//
//  ViewController.swift
//  FC System
//
//  Created by Zhuravlev Dmitry on 11.01.2024.
//

import UIKit

final class MainViewController: UIViewController {


    let names = ["Новость 1", "Поле для тренировок Новость 1", "Стадион для игр Новость 1", "Тех. поддержка Новость 1", "Настройки Новость 1", "Оценить приложение Новость 1", "Новость 1", "Поле для тренировок Новость 1", "Стадион для игр Новость 1", "Тех. поддержка Новость 1", "Настройки Новость 1", "Оценить приложение Новость 1"]

    var cellIdetifier = "Cell"

    let newsTableView = UITableView()


    private let playerOfMonthImage: UIImageView = {
        let image = UIImageView ()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = true
        return image

    }()


    private let playerOfMonthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = true
        label.text = "Игрок месяца - ТИМУРЧИК"
        label.textColor = .white
        label.font = UIFont(name: "Bold", size: 24)
        return label
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.translatesAutoresizingMaskIntoConstraints = true
        return scrollView
    }()



    private let containerView: UIView = {
        let containerView = UIView ()
        containerView.backgroundColor = .red
        containerView.translatesAutoresizingMaskIntoConstraints = true
        return containerView
    }()



    private var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        return pageControl
    }()



    var imageNames = ["team", "stad2", "stad1"]
    var currentIndex = 0
    var timer: Timer?

    var imageView2: UIImageView!
    var label2: UILabel!

    private let scrollViewForImageView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.translatesAutoresizingMaskIntoConstraints = true
        return scrollView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()





    override func viewDidLoad() {
        super.viewDidLoad()

        playerOfMonthImage.image = UIImage(named: "1")
        playerOfMonthLabel.frame = CGRect(x: 100, y: 120, width: 300, height: 200)
        playerOfMonthImage.frame = CGRect(x: 150, y: 250, width: 200, height: 200)
        newsTableView.frame = CGRect(x: 0, y: 470, width: view.bounds.width, height: 300)
        newsTableView.translatesAutoresizingMaskIntoConstraints = false
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.isScrollEnabled = false

        //ПЕРВЫЙ СКРОЛЛ
        scrollView.frame = view.bounds
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(playerOfMonthLabel)
        containerView.addSubview(playerOfMonthImage)
        containerView.addSubview(newsTableView)
        newsTableView.rowHeight = 60
        newsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdetifier)
        containerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: newsTableView.frame.maxY)
        scrollView.contentSize = containerView.bounds.size






        containerView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        //stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 200).isActive = true


      //  stackView.addArrangedSubview(scrollViewForImageView)

        pageControl.numberOfPages = imageNames.count
        pageControl.currentPage = currentIndex
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        stackView.addArrangedSubview(pageControl)
        pageControl.backgroundColor = .blue



        scrollViewForImageView.delegate = self
        scrollViewForImageView.isPagingEnabled = true
        scrollViewForImageView.showsHorizontalScrollIndicator = false

        scrollViewForImageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 200)
        scrollViewForImageView.contentSize = CGSize(width: view.bounds.width * CGFloat(imageNames.count), height: 200)


        for i in 0..<imageNames.count {
            let imageView = UIImageView(frame: CGRect(x: view.bounds.width * CGFloat(i), y: 0, width: view.bounds.width, height: 200))
            imageView.contentMode = .scaleToFill
            imageView.image = UIImage(named: imageNames[i])
            imageView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            imageView.addGestureRecognizer(tapGesture)
            stackView.addArrangedSubview(imageView)
           // scrollViewForImageView.addSubview(imageView)

            let label = UILabel(frame: CGRect(x: view.bounds.width * CGFloat(i), y: 140, width: view.bounds.width, height: 50))
            label.textAlignment = .center
            label.textColor = .green
            label.text = "НАЗВАНИЕ НОВОСТИ - \(imageNames[i])"
            scrollViewForImageView.addSubview(label)



               }

        updateContentForCurrentIndex()
        startAutoScroll()

    }


    func updateContentForCurrentIndex() {
        //            imageView2.image = UIImage(named: imageNames[currentIndex])
        //
        //                    // Установите текст в UILabel на основе текущего индекса
        //                    label2.text = "Image \(currentIndex + 1)"
        //
        //            // В этом методе вы можете обновить отображаемый контент на основе текущего индекса.
        //            // В этом примере, я просто печатаю текущий индекс и имя картинки.
        //            print("Current Index: \(currentIndex), Image Name: \(imageNames[currentIndex])")
           // Обновление отображаемого контента на основе текущего индекса
       }

    func startAutoScroll() {
            timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(scrollToNextPage), userInfo: nil, repeats: true)
        }

    @objc func scrollToNextPage() {
            currentIndex += 1
            if currentIndex >= imageNames.count {
                currentIndex = 0
            }

            // Обновляем текущий индекс UIPageControl
            pageControl.currentPage = currentIndex

        let contentOffset = CGPoint(x: view.bounds.width * CGFloat(currentIndex), y: 0)
                scrollViewForImageView.setContentOffset(contentOffset, animated: true)

        }

        @objc func pageControlTapped(_ sender: UIPageControl) {
            // Обновляем текущий индекс и отображаем контент для выбранной страницы
            currentIndex = sender.currentPage
            let contentOffset = CGPoint(x: view.bounds.width * CGFloat(currentIndex), y: 0)
                   scrollViewForImageView.setContentOffset(contentOffset, animated: true)
        }

    @objc func imageTapped(_ gesture: UITapGestureRecognizer) {
print("AAA")
            // Обработка нажатия на изображение
            if let tappedImageView = gesture.view as? UIImageView,
               let index = stackView.arrangedSubviews.firstIndex(of: tappedImageView) {
                let detailViewController = DetailViewController(imageName: imageNames[index])
                navigationController?.pushViewController(detailViewController, animated: true)
                print("BBBBBBBB")
            } else {print("BBBBBBBB")}
        }


    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()

            // Устанавливаем размер UIScrollView в соответствии с UIStackView
            scrollViewForImageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 200)
            scrollViewForImageView.contentSize = CGSize(width: view.bounds.width * CGFloat(imageNames.count), height: 200)
        }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdetifier, for: indexPath)
        var content = cell.defaultContentConfiguration()

        let date = names[indexPath.row]
        content.text = date
        cell.contentConfiguration = content
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }



}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Вычисляем текущий индекс страницы на основе contentOffset
        currentIndex = Int(scrollViewForImageView.contentOffset.x / view.bounds.width)

        // Обновляем UIPageControl
        pageControl.currentPage = currentIndex
    }
}

