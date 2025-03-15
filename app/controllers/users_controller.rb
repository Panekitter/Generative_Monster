class UsersController < ApplicationController
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
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
