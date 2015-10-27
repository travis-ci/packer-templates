CREATE KEYSPACE travis
WITH REPLICATION = {
  'class': 'SimpleStrategy',
  'replication_factor': 1
};

USE travis;

CREATE TABLE users (
  first varchar PRIMARY KEY,
  last varchar,
  age varchar,
);

INSERT INTO users (first, last, age)
  VALUES ('Jane', 'Doe', '84');

EXPAND ON;

SELECT * FROM users WHERE first = 'Jane';
