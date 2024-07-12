CREATE SCHEMA nextgis;

CREATE TABLE nextgis.order_type
(
    id   INTEGER PRIMARY KEY,
    name VARCHAR(256) NOT NULL
);

INSERT INTO nextgis.order_type(id, name)
VALUES (1, 'Проработка')
     , (2, 'Подключение');


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

CREATE OR REPLACE FUNCTION nextgis.order_create_jsonb(in_orders_list_jsonb jsonb)
    RETURNS INT
    LANGUAGE plpgsql
AS
$$
DECLARE
    out_inserted_rows INT;
BEGIN
    INSERT INTO nextgis.order(id, order_type_id, description, latitude, longitude, link, date, geometry)
    SELECT new_orders_list.order_id
         , new_orders_list.order_type_id
         , new_orders_list.description
         , new_orders_list.latitude
         , new_orders_list.longitude
         , new_orders_list.order_url
         , new_orders_list.date
         , ST_SetSRID(ST_MakePoint(new_orders_list.longitude, new_orders_list.latitude), 4326)
    FROM JSONB_TO_RECORDSET(in_orders_list_jsonb) AS new_orders_list(
                                                                     order_id INT,
                                                                     order_type_id INT,
                                                                     description TEXT,
                                                                     latitude NUMERIC(8, 6),
                                                                     longitude NUMERIC(9, 6),
                                                                     order_url TEXT,
                                                                     DATE TIMESTAMP);
    GET DIAGNOSTICS out_inserted_rows = ROW_COUNT;

    RETURN out_inserted_rows;
END;
$$;
