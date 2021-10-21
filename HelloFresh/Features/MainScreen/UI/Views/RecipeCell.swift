//
//  RecipeCell.swift
//  HelloFresh
//
//  Created by Дайняк Александр Николаевич on 20.10.2021.
//

import UIKit
import Kingfisher
import SnapKit

final class RecipeCell: UITableViewCell {
    
    // MARK: - Nested Types
    
    private enum Consts {
        enum Sizes {
            static let inset: CGFloat = 16
            static let imageHeight: CGFloat = 200
            static let sInset: CGFloat = 4
            static let xsInset: CGFloat = 2
            static let lInset: CGFloat = 8
        }
        
        enum Colors {
            static let titleColor: UIColor = .darkGray
            static let subtitleColor: UIColor = .gray
            static let timeLabelColor: UIColor = .darkGray
            static let borderColor: UIColor = .green
            
        }
        
        enum Fonts {
            static let titleFont: UIFont = UIFont.systemFont(ofSize: 18, weight: .bold)
            static let subtitleFont: UIFont = UIFont.systemFont(ofSize: 18, weight: .regular)
            static let timeLabelFont: UIFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
            
        }
    }
    
    // MARK: - Private properties
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Consts.Fonts.titleFont
        label.textColor = Consts.Colors.titleColor
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Consts.Fonts.subtitleFont
        label.textColor = Consts.Colors.subtitleColor
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = Consts.Fonts.timeLabelFont
        label.textColor = Consts.Colors.timeLabelColor
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var recipeImage: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        
        return $0
    }(UIImageView(frame: .zero))
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        borderView.backgroundColor = selected ? .green : .clear
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .clear
        contentView.shadow()
        backgroundColor = .clear
        selectedBackgroundView = UIView()
        setupSubviews()
    }
    
    override func prepareForReuse() {
        recipeImage.kf.cancelDownloadTask()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func configure(recipe: Recipe) {
        
        titleLabel.text = recipe.name
        subtitleLabel.text = recipe.headline
        timeLabel.text = String(recipe.preparationMinutes).appending(" Min")
        if let url = URL(string: recipe.image) {
            recipeImage.kf.setImage(with: url)
        }
        
    }
    
    // MARK: - Private methods
    
    private func setupSubviews() {
        contentView.addSubview(borderView)
        borderView.addSubview(backView)
        
        backView.addSubview(titleLabel)
        backView.addSubview(subtitleLabel)
        backView.addSubview(timeLabel)
        backView.addSubview(recipeImage)
        
        contentView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(Consts.Sizes.sInset)
        }
        
        borderView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Consts.Sizes.xsInset)
        }
        
        recipeImage.snp.makeConstraints {
            $0.top.left.right.equalTo(backView)
            $0.height.equalTo(Consts.Sizes.imageHeight)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(recipeImage.snp.bottom).inset(-Consts.Sizes.lInset)
            $0.leading.trailing.equalTo(backView).inset(Consts.Sizes.inset)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).inset(-Consts.Sizes.lInset)
            $0.leading.trailing.equalTo(backView).inset(Consts.Sizes.inset)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).inset(-Consts.Sizes.lInset)
            $0.leading.trailing.equalTo(backView).inset(Consts.Sizes.inset)
            $0.bottom.equalToSuperview().inset(Consts.Sizes.lInset)
        }
    }
}
