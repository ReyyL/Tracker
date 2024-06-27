//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Andrey Lazarev on 15.06.2024.
//

import UIKit

protocol CompleteTrackerProtocol: AnyObject {
    func completeTracker(id: UUID, indexPath: IndexPath)
    func uncompleteTracker(id: UUID, indexPath: IndexPath)
}

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    var isTrackerCompleted: Bool = false
    
    private var trackerId: UUID?
    private var indexPath: IndexPath?
    
    weak var delegate: CompleteTrackerProtocol?
    
    private lazy var emojiView: UIView = {
        let emojiView = UIView()
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        emojiView.layer.cornerRadius = 12
        emojiView.alpha = 0.3
        emojiView.layer.masksToBounds = true
        emojiView.backgroundColor = .yWhite
        return emojiView
    }()
    
    private lazy var emoji: UILabel = {
        let emoji = UILabel()
        emoji.translatesAutoresizingMaskIntoConstraints = false
        emoji.font = .systemFont(ofSize: 12, weight: .medium)
        return emoji
    }()
    
    private lazy var title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 12, weight: .medium)
        title.textColor = .yWhite
        title.numberOfLines = 2
        title.textAlignment = .left
        return title
        
    }()
    
    private lazy var date: UILabel = {
        let date = UILabel()
        date.translatesAutoresizingMaskIntoConstraints = false
        date.font = .systemFont(ofSize: 12, weight: .medium)
        date.textColor = .yBlack
        return date
    }()
    
    lazy var plusButton: UIButton = {
        let plusButton = UIButton()
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.addTarget(self, action: #selector(addDayForTracker), for: .touchUpInside)
        return plusButton
    }()
    
    private lazy var bodyView: UIView = {
        let bodyView = UIView()
        bodyView.layer.cornerRadius = 16
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        return bodyView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bodyView)
        
        bodyView.addSubview(emojiView)
        bodyView.addSubview(emoji)
        bodyView.addSubview(title)
        
        contentView.addSubview(date)
        contentView.addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            
            bodyView.heightAnchor.constraint(equalToConstant: 90),
            bodyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bodyView.topAnchor.constraint(equalTo: topAnchor),
            bodyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            emojiView.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor, constant: 12),
            emojiView.topAnchor.constraint(equalTo: bodyView.topAnchor, constant: 12),
            emojiView.heightAnchor.constraint(equalToConstant: 24),
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            
            emoji.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor),
            emoji.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor),
            
            title.leadingAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            title.trailingAnchor.constraint(equalTo: bodyView.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            title.bottomAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: -12),
            
            date.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            date.topAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: 16),
            
            plusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            plusButton.topAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: 8),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            plusButton.widthAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(tracker: Tracker, completedDays: Int, isTrackerCompleted: Bool, indexPath: IndexPath) {
        
        self.isTrackerCompleted = isTrackerCompleted
        self.trackerId = tracker.id
        self.indexPath = indexPath
        
        bodyView.backgroundColor = tracker.color
        
        title.text = tracker.name
        emoji.text = tracker.emoji
        date.text = "\(completedDays) Дней"
        
        plusButton.tintColor = tracker.color
        let image = isTrackerCompleted ? UIImage(named: "Done") : UIImage(named: "Plus")
        plusButton.setImage(image, for: .normal)
    }
    
    @objc
    private func addDayForTracker() {
        guard let indexPath, let trackerId else { return }
        
        if isTrackerCompleted {
            delegate?.uncompleteTracker(id: trackerId, indexPath: indexPath)
        } else {
            delegate?.completeTracker(id: trackerId, indexPath: indexPath)
        }
    }
    
}
