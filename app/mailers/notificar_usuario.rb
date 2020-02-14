class NotificarUsuario < ActionMailer::Base
  
  default from: "kantytransportadora@gmail.com"

  def test_email(user_id, adjuntos)

    @datos_adjuntos = adjuntos
    @user = Usuario.find_by_id user_id

    if (@user)

      to = @user.email
      mail(:to => to, :subject => "Aviso para cobro de producciones", :from => "kantytransportadora@gmail.com") 
    end
  end

  def email(usuario, password)
    
    @usuario = usuario
    @password = password

    mail(to: @usuario.email, subject: "ULTRON: Nuevo Usuario")

  end

  def email_usuario(usuario, password)
    
    @usuario = usuario
    @password = password

    mail(to: @usuario.email, subject: "ULTRON: Nuevo Usuario")

  end

  def email_recuperar_password(usuario, password)
    
    @usuario = usuario
    @password = password

    mail(to: @usuario.email, subject: "ULTRON: Recuperar Contraseña")

  end

  

end
