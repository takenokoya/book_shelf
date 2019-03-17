class BooksController < ApplicationController
  before_action :set_book, only: [:edit, :update, :destroy]
  
  def index
    # @books = Book.page(params[:page]).per(4)
    # @books = Book.with_attached_image.page(params[:page]).per(4) # N+1問題対策
    # @books = Book.with_attached_image.page(params[:page]).per(4).order(publish_date: :desc) # orderメソッド追加
    # @books = Book.with_attached_image.find_newest_books(params[:page]) #リファクタリング。bookモデルとセット
    # ransak用にApplicationコントローラ側に記述したので削除
  end
  
  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to @book, notice: "書籍を登録しました。"
    else
      render :new
    end
  end

  def show
    # @book = Book.with_attached_image.includes(reviews: :user).find(params[:id]) #アソシエーションでhas_many throughオプションを書かない場合
    @book = Book.with_attached_image.includes(:reviews, :users).find(params[:id])
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to @book, notice: "書籍を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path, notice: "書籍を削除しました。"
  end

  private

  def book_params
    params.require(:book).permit(:title, :price, :publish_date, :description, :new_image, :category_id)
  end

  def set_book
    @book = Book.find(params[:id])
  end
end
