class UsersBackoffice::WelcomeController < UsersBackofficeController
  def index
    @users = User.all
  end
end
