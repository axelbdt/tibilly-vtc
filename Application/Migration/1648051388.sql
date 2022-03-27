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
    date DATE NOT NULL
);
ALTER TABLE bills ADD CONSTRAINT bills_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
