class Book < ApplicationRecord
  belongs_to :category
  has_many :reviews, dependent: :destroy # 本が削除されたらレビューも消える
  has_many :users, through: :reviews #ユーザーモデルの先にレビューモデルがある(review経由してuserとアソシエーション)ことを定義
  has_one_attached :image
  attribute :new_image

  validates :title, presence: true, length: { maximum: 50 }
  validates :price, presence: true,
      numericality: {
        only_integer: true,
        greater_than: 1
      }
  validates :publish_date, presence: true
  validates :description, presence: true, length: { maximum: 1000 }
  
  # scope :find_newest_books, -> { order(publish_date: :desc) }
  scope :find_newest_books, -> (p) { page(p).per(4).order(publish_date: :desc) } #リファクタリング。booksコントローラとセットで変更

  before_save do
    self.image = new_image if new_image
  end
end