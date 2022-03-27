CREATE TABLE bills (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    date DATE NOT NULL
);
CREATE TABLE trips (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    startcity TEXT NOT NULL,
    destinationcity TEXT NOT NULL,
    date DATE NOT NULL,
    bill_id UUID NOT NULL
);
CREATE INDEX trips_bill_id_index ON trips (bill_id);
ALTER TABLE trips ADD CONSTRAINT trips_ref_bill_id FOREIGN KEY (bill_id) REFERENCES bills (id) ON DELETE NO ACTION;
