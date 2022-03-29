ALTER TABLE trips DROP CONSTRAINT trips_ref_bill_id;
ALTER TABLE trips ADD CONSTRAINT trips_ref_bill_id FOREIGN KEY (bill_id) REFERENCES bills (id) ON DELETE CASCADE;
