module main

import crypto.bcrypt

fn (mut app App) add_user(email string, password string) !User {
	hashed_password := bcrypt.generate_from_password(password.bytes(), bcrypt.min_cost) or {
		eprintln(err)
		return err
	}

	user_model := User{
		email:    email
		username: email
		password: hashed_password
	}

	sql app.db {
		insert user_model into User
	} or {
		eprintln(err)
		return err
	}

	users := sql app.db {
		select from User where email == email limit 1
	}!

	return users.first()
}
