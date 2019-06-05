class SecurityKeysController < ApplicationController
  def new
    username = current_user.email

    @credential_options = ::WebAuthn.credential_creation_options
    @credential_options[:user][:id] = Base64.strict_encode64(username)
    @credential_options[:user][:name] = username
    @credential_options[:user][:displayName] = username
    @credential_options[:challenge] = bin_to_str(@credential_options[:challenge])
  end

  def create
    pp params

    # current_user.verify_and_enable_mfa!(@seed, :ui_and_api, otp_param, @expire)
    # if current_user.errors.any?
    #   flash[:error] = current_user.errors[:base].join
    #   redirect_to edit_profile_url
    # else
    #   flash[:success] = t('.success')
    #   render :recovery
    # end
    #
    flash[:notice] = 'A new security key is registered.'
    redirect_to edit_profile_path
  end

  private

  def str_to_bin(str)
    Base64.strict_decode64(str)
  end

  def bin_to_str(bin)
    Base64.strict_encode64(bin)
  end
end
