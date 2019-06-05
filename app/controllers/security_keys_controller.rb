class SecurityKeysController < ApplicationController
  def new
    username = current_user.email

    @credential_options = ::WebAuthn.credential_creation_options
    @credential_options[:user][:id] = Base64.strict_encode64(username)
    @credential_options[:user][:name] = username
    @credential_options[:user][:displayName] = username
    @credential_options[:challenge] = bin_to_str(@credential_options[:challenge])

    current_user.update!(current_challenge: @credential_options[:challenge])
  end

  def create
    req =  JSON.parse(params[:data],{symbolize_names: true})
    current_challenge = current_user.current_challenge
    current_user.update!(current_challenge: nil)

    nickname = params[:nickname] || 'my security key'

    auth_response = WebAuthn::AuthenticatorAttestationResponse.new(
      attestation_object: str_to_bin(req[:response][:attestationObject]),
      client_data_json: str_to_bin(req[:response][:clientDataJSON])
    )

    unless auth_response.verify(str_to_bin(current_challenge), request.base_url)
      flash[:alert] = 'invalid request'
      render :new
    end

    security_key = current_user.security_keys.find_or_initialize_by(
      external_id: Base64.strict_encode64(auth_response.credential.id)
    )

    security_key.update!(
      nickname: nickname,
      public_key: Base64.strict_encode64(auth_response.credential.public_key)
    )

    flash[:notice] = "A new security key \"#{nickname}\" is registered."
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
