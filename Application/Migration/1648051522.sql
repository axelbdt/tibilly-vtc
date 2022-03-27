ALTER TABLE bills ADD COLUMN user_id TEXT NOT NULL;
CREATE INDEX bills_user_id_index ON bills (user_id);
ALTER TABLE bills ADD CONSTRAINT bills_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
