class User
  generator_for :login, :start => 'user_0'
  generator_for :password, 'foobar'
  generator_for :password_confirmation, 'foobar'
end
