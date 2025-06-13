module api

import crypto.bcrypt

pub fn (app &App) add_user(email string, password string) !User {
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

	return sql app.db {
		select from User where email == email limit 1
	}!.first()
}

pub fn (app &App) sign_in_user(email string, password string) !string {
	user_rows := sql app.db {
		select from User where email == email limit 1
	}!

	if user_rows.len == 0 {
		return error('User not found')
	}

	user := user_rows.first()

	bcrypt.compare_hash_and_password(password.bytes(), user.password.bytes()) or {
		return error('Failed to auth user, ${err}')
	}

	return encode_jwt(user)
}
