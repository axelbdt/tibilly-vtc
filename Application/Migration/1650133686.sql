ALTER TABLE bills RENAME COLUMN sent_at TO sent_on;
ALTER TABLE bills ALTER COLUMN number SET DEFAULT '';
