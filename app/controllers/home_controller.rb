require 'mailgun'

class HomeController < ApplicationController
  def index
    
    
    
  end
  
  def write
    #send email..delete
    
    redirect_to "/list"
  end
  def list
      @content_all = Post.all.order("id desc")
  end
  
  def confirm_email
    @emails = Email.all
    @users = User.all
    @confirm_emails = User.where(isConfirm: true)
    
  end
  
  def send_email
    #generate random key string.
    motherSample = (0..9).to_a + ('a'..'z').to_a
    randomKey = motherSample.sample(7).join
    
    #인증 시도한 데이터를 입력...
    @new_email = Email.new
    @new_email.email = params[:user_email]
    @new_email.key = randomKey
    @new_email.save
    
    #유저 정보를 입력. 이미 있는 유저는 알아서 무시.
    @new_user = User.new
    @new_user.email = params[:user_email]
    @new_user.save 
    
    #메일 전송
    mg_client = Mailgun::Client.new("key-bf85af4d95e0b6d5da926c9c812d64e4")
    message_params =  {
                      from: 'no-reply@lionlove.me',
                      to:   params[:user_email],
                      subject: 'lionloveme 인증 메일입니다',
                      text:  '인증코드 : '+randomKey
                      }
    
    result = mg_client.send_message('lionlove.me', message_params).to_h!
    
    
    #ajax call 응답
    respond_to do |format|
      
        format.json { render json: {message:'메일이 발송되었습니다'} }
      
    end
    
  end
  
  def check_code
    #가장 최근에 시도한 니 이메일 인증코드를 가져오자 
    #@email = Email.find_by(email: params[:user_email]).order(created_at: :desc)
    @email = Email.where(email: params[:user_email]).order(created_at: :desc).limit(1)
    
    respond_to do |format|
      #인증번호 일치하면 유저 정보 수정
      
      if @email.try(:first).try(:key) == params[:user_code]
      
        @user = User.find_by(email: params[:user_email])
        @user.isConfirm = true
        @user.save
        format.json {render json: {message: "인증완료" }}
        #format.json {render nothing: true, status: 200 }
      else
      
        format.json {render json: {message: "문제가 있습니다"} }
      end
    end
    
    
  end
end
