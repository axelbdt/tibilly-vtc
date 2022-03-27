CREATE TABLE bills (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    user_id TEXT NOT NULL,
    date DATE NOT NULL
);
CREATE INDEX bills_user_id_index ON bills (user_id);
CREATE TABLE trips (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    startcity TEXT NOT NULL,
    destinationcity TEXT NOT NULL,
    date DATE NOT NULL,
    bill_id UUID NOT NULL
);
CREATE INDEX trips_bill_id_index ON trips (bill_id);
ALTER TABLE bills ADD CONSTRAINT bills_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
ALTER TABLE trips ADD CONSTRAINT trips_ref_bill_id FOREIGN KEY (bill_id) REFERENCES bills (id) ON DELETE NO ACTION;
