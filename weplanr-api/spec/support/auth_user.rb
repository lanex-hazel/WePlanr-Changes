def auth_user
  @_auth_user ||=
    begin
      User.transaction do
        user = User.create(
          firstname: 'Source',
          lastname: 'Pad',
          email: 'foo@bar.com',
          password: '123',
          wedding: Wedding.create
        )

        user.assign_auth_token!
        user
      end
    end
end
