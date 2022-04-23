-- Your database schema. Use the Schema Designer at http://localhost:8001/ to add some tables.
CREATE TABLE users (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    email TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    locked_at TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    failed_login_attempts INT DEFAULT 0 NOT NULL,
    name TEXT NOT NULL,
    immatriculation TEXT NOT NULL,
    address TEXT DEFAULT '' NOT NULL,
    capital INT DEFAULT 0 NOT NULL,
    company_type TEXT DEFAULT '' NOT NULL,
    has_vat_number BOOLEAN DEFAULT false NOT NULL
);
CREATE TABLE bills (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    user_id UUID NOT NULL,
    client_id UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    sent_on DATE,
    number TEXT DEFAULT '' NOT NULL
);
CREATE TABLE trips (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    "start" TEXT NOT NULL,
    destination TEXT NOT NULL,
    date DATE DEFAULT NOW() NOT NULL,
    bill_id UUID NOT NULL,
    price INT NOT NULL
);
CREATE INDEX trips_bill_id_index ON trips (bill_id);
CREATE INDEX bills_user_id_index ON bills (user_id);
CREATE TABLE clients (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    email TEXT NOT NULL,
    name TEXT NOT NULL,
    user_id UUID NOT NULL,
    address TEXT DEFAULT '' NOT NULL
);
CREATE INDEX clients_user_id_index ON clients (user_id);
CREATE INDEX bills_client_id_index ON bills (client_id);
ALTER TABLE bills ADD CONSTRAINT bills_ref_client_id FOREIGN KEY (client_id) REFERENCES clients (id) ON DELETE NO ACTION;
ALTER TABLE bills ADD CONSTRAINT bills_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
ALTER TABLE clients ADD CONSTRAINT clients_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
ALTER TABLE trips ADD CONSTRAINT trips_ref_bill_id FOREIGN KEY (bill_id) REFERENCES bills (id) ON DELETE CASCADE;
