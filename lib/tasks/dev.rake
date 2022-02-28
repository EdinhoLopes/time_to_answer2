namespace :dev do
  DEFAULT_PASSWORD = 123456
  DEFAULT_FILES_PATH = File.join(Rails.root, 'lib', 'tmp')

  desc "Configura o ambiente de desenvolvimento executando os comandos aninhados (rails db:drop db:create db:migrate)"
  task setup: :environment do
    if Rails.env.development?
      show_spinner('Apagando BD...') {%x(rails db:drop)}
      show_spinner('Criando BD...') {%x(rails db:create)}
      show_spinner('Migrando o BD...') {%x(rails db:migrate)}
      show_spinner('Cadastrando o Admin padrão') {%x(rails dev:add_default_admin)}
      show_spinner('Cadastrando o Admin extras') {%x(rails dev:add_extra_admins)}
      show_spinner('Cadastrando o User padrão') {%x(rails dev:add_default_user)}
      show_spinner("Cadastrando assuntos padrões...") { %x(rails dev:add_subjects) }
      show_spinner("Cadastrando perguntas e respostas...") { %x(rails dev:answers_and_questions) }
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

  desc "Adiciona assuntos padrões"
  task add_subjects: :environment do
    file_name = 'subjects.txt'
    file_path = File.join(DEFAULT_FILES_PATH, file_name)
  
    File.open(file_path, 'r').each do |line|
     Subject.create!(description: line.strip)
    end
  end

  desc "Adiciona perguntas e respostas"
  task answers_and_questions: :environment do
    Subject.all.each do |subject|
      rand(5..10).times do |i|
        params = create_question_params(subject)
        answers_arrays = params[:question][:answers_attributes]

        add_answers(answers_arrays)
        elect_true_answer

        Question.create!(params[:question])
      end
    end
  end


  private #Apenas o próprio namespace dev consegue conversar com esse métodos...

  def create_question_params(subject = Subject.all.sample)
    {question: {
      description: "#{Faker::Lorem.paragraph} #{Faker::Lorem.question}",
      subject: subject,
      answers_attributes: []
    }}
  end

  def create_answer_params(correct = false)
    {description: Faker::Lorem.sentence, correct: correct}
  end

  def elect_true_answer(answers_arrays = [])
    selected_index = rand(answers_arrays.size)
    answers_arrays[selected_index] = create_answer_params(true)
  end

  def add_answers(answers_arrays = [])
    rand(2..5).times do |j|
      answers_arrays.push(
        create_answer_params
      )
    end
  end
  
  def show_spinner(msg_start, msg_end = "Concluído!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    sleep(2)
    yield
    spinner.success("(#{msg_end})")
  end
end
