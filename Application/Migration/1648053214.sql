ALTER TABLE bills ADD COLUMN client_id UUID NOT NULL;
CREATE INDEX bills_client_id_index ON bills (client_id);
ALTER TABLE bills ADD CONSTRAINT bills_ref_client_id FOREIGN KEY (client_id) REFERENCES clients (id) ON DELETE NO ACTION;
