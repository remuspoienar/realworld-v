module database

import db.sqlite

pub fn create_db_connection() !sqlite.DB {
	mut db := sqlite.connect('database/realworld.sqlite')!
	return db
}
