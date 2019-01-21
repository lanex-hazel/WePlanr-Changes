def auth_admin
  @_auth_admin ||=
    begin
      Admin.transaction do
        admin = Admin.create(
          username: 'admin',
          password: '123'
        )

        admin.assign_auth_token!
        admin
      end
    end
end
