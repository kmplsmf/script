CREATE EXTENSION postgis;

CREATE SCHEMA nextgis;

CREATE TABLE nextgis.order_type
(
    id   INTEGER PRIMARY KEY,
    name VARCHAR(256) NOT NULL
);

INSERT INTO nextgis.order_type(id, name) VALUES (1, 'Проработка'), (2, 'Подключение');


CREATE TABLE nextgis.order
(
    id            INTEGER PRIMARY KEY,
    order_type_id INTEGER REFERENCES nextgis.order_type (id),
    description   TEXT,
    latitude      NUMERIC(8, 6) NOT NULL,
    longitude     NUMERIC(9, 6) NOT NULL,
    link          TEXT          NOT NULL,
    date          TIMESTAMP     NOT NULL,
    geometry      geometry      NOT NULL
);

CREATE INDEX ON nextgis.order (date);
