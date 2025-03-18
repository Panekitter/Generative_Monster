class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :authorize_user, only: [:edit, :update]

  def index
    sort = params[:sort] || "win_rate"  # デフォルトは勝率順
    @users = case sort
             when "newest"
               User.order(created_at: :desc)
             else  # "win_rate" またはパラメータがない場合
               # 勝率は計算が必要なので、ここでは勝率順にソートする例として仮の処理を記述
               User.all.sort_by { |u| u.battle_count > 0 ? - (u.win_count.to_f / u.battle_count) : 0 }
             end
    # Kaminariの場合、ページネーションのために .page をチェーンする必要があります。
    @users = Kaminari.paginate_array(@users).page(params[:page]).per(10)
  end

  def show
    @characters = @user.characters.order(created_at: :desc).limit(12)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "プロフィールを更新しました。"
    else
      flash.now[:alert] = "更新に失敗しました。"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_user
    redirect_to root_path, alert: "権限がありません。" unless @user == current_user
  end

  def user_params
    permitted = params.require(:user).permit(:name, :image, :image_cache)
    # もし画像ファイルが空（サイズ0）かつ image_cache も空なら、:image を削除する
    if permitted[:image].respond_to?(:size) && permitted[:image].size == 0 && permitted[:image_cache].blank?
      permitted.delete(:image)
    end
    permitted
  end
  
end
