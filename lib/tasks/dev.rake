namespace :dev do
  DEFAULT_PASSWORD = 123456
  desc "Configura o ambiente de desenvolvimento executando os comandos aninhados (rails db:drop db:create db:migrate)"
  task setup: :environment do
    if Rails.env.development?
      show_spinner('Apagando BD...') {%x(rails db:drop)}
      show_spinner('Criando BD...') {%x(rails db:create)}
      show_spinner('Migrando o BD...') {%x(rails db:migrate)}
      show_spinner('Cadastrando o Admin padrão') {%x(rails dev:add_default_admin)}
      show_spinner('Cadastrando o Admin extras') {%x(rails dev:add_extra_admins)}
      show_spinner('Cadastrando o User padrão') {%x(rails dev:add_default_user)}
      #%x(rails dev:add_mining_types)
    else
      puts "Você não está em ambiente de desenvolvimento!"
    end
  end

  desc "Adiciona o Administrador padrão"
  task add_default_admin: :environment do
    Admin.create!(
      email: "teste@teste.com.br",
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Adiciona o Administradores extras"
  task add_extra_admins: :environment do
    10.times do |i|
      Admin.create!(
        email: Faker::Internet.email,
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD
      )
    end
  end

  desc "Adiciona o usuário padrão"
  task add_default_user: :environment do
    User.create!(
      email: "user@user.com.br",
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end


  private #Apenas o próprio namespace dev consegue conversar com esse métodos...
  
  def show_spinner(msg_start, msg_end = "Concluído!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    sleep(2)
    yield
    spinner.success("(#{msg_end})")
  end
end
