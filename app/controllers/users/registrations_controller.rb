# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]

  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    @user = User.new
    @user.build_confirm
    puts "aaaa"
  end

  # POST /resource
  def create
    # パスワード入力欄からの内容と、確認用パスワード入力欄の内容が一致しているかを確かめます。
    if params.require(:user)["password"]==params.require(:user)["password_confirmation"]

      # まず、params.require(:user).require(:confirm_attributes)["birthday(2i)"]が1桁なら、2桁にする処理をします。
      if params.require(:user).require(:confirm_attributes)["birthday(2i)"].length==1
        # デバッグ用の表示です。
        # p "birthday(2i) -- is 1 length! changing 2 length"
        params.require(:user).require(:confirm_attributes)["birthday(2i)"]=(0.to_s+params.require(:user).require(:confirm_attributes)["birthday(2i)"])
        # p params.require(:user).require(:confirm_attributes)["birthday(2i)"]
      end

      # 次に、params.require(:user).require(:confirm_attributes)["birthday(3i)"]が1桁なら、同様に処理します。
      if params.require(:user).require(:confirm_attributes)["birthday(3i)"].length==1
        # デバッグ用の表示です。
        # p "birthday(3i) -- is 1 length! changing 2 length"
        params.require(:user).require(:confirm_attributes)["birthday(3i)"]=(0.to_s+params.require(:user).require(:confirm_attributes)["birthday(3i)"])
        # p params.require(:user).require(:confirm_attributes)["birthday(3i)"]
      end

      #params.require(:user).require(:confirm_attributes)["birthday(1i)"]はString型なので、2iと文字列結合。さらにその後3iとも結合します。
      params.require(:user).require(:confirm_attributes)["birthday(1i)"].concat(params.require(:user).require(:confirm_attributes)["birthday(2i)"])
      params.require(:user).require(:confirm_attributes)["birthday(1i)"].concat(params.require(:user).require(:confirm_attributes)["birthday(3i)"])
      # デバッグ用の表示です。
      # p "---concated-birthday1i---"
      # p params.require(:user).require(:confirm_attributes)["birthday(1i)"]

      # 結合結果の1iを、params.require(:user).require(:confirm_attributes)[:birthday]でbirthdayというキーを作り、値として挿入
      params.require(:user).require(:confirm_attributes)[:birthday]=params.require(:user).require(:confirm_attributes)["birthday(1i)"]
      # 結合したのでparams.require(:user).require(:confirm_attributes)["birthday(2i)"]と3iをけします。
      params.require(:user).require(:confirm_attributes).delete("birthday(2i)")
      params.require(:user).require(:confirm_attributes).delete("birthday(3i)")
      params.require(:user).require(:confirm_attributes).delete("birthday(1i)")

      @user = User.new(user_params)
      # バリデーションにかかるとsaveできないので、確かめます
      if @user.valid?
        @user.save!
      else
        # バリデーションにかかった場合、flashメッセージを表示しつつ、新規ユーザ登録画面にリダイレクトします。
        redirect_to new_user_registration_path, notice: @user.errors.full_messages
        return
      end
      # puts "binding.pry1"
      # binding.pry
      # 保存が完了したら、会員情報入力画面にリダイレクトします。
      sign_in(:user, @user)
      redirect_to new_address_path
    else
      # パスワードが一致しない場合、エラーメッセージをflashで表示し、新規登録画面へリダイレクトします。
      redirect_to new_user_registration_path, notice: 'パスワードが一致しません。'
      # render "new"
      return
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected
  private

  def user_params
    params.require(:user).permit(:nikname, :email,:password,confirm_attributes:[:id, :name_last_name, :name_first_name, :last_name_kana, :first_name_kana , :birthday])
  end

  def confirm_params
    params.require(:user).require(:confirm_attributes).permit(:id, :name_last_name, :name_first_name, :last_name_kana, :first_name_kana , :birthday[1i])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)

  # protected
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:nikname])
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:nikname,:email, :encrypted_password])
  # end

end
