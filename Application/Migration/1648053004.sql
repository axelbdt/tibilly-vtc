ALTER TABLE clients ADD COLUMN user_id UUID NOT NULL;
CREATE INDEX clients_user_id_index ON clients (user_id);
ALTER TABLE clients ADD CONSTRAINT clients_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
