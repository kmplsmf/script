CREATE TABLE nextgis.broken_device
(
    switch_id           INT PRIMARY KEY,
    switch_name         TEXT,
    trouble_id          INT,
    trouble_status_id   INT,
    trouble_status_name TEXT,
    device_url          TEXT,
    trouble_url         TEXT,
    geometry            geometry NOT NULL
);

CREATE FUNCTION nextgis.broken_devices_create_jsonb_replace(in_broken_devices_list_jsonb jsonb)
    RETURNS INT
    LANGUAGE plpgsql
AS
$$
DECLARE
    out_inserted_rows INT;
BEGIN
    TRUNCATE TABLE nextgis.broken_device;

    INSERT INTO nextgis.broken_device( switch_id, switch_name, trouble_id, trouble_status_id, trouble_status_name
                                      , device_url, trouble_url, geometry)
    SELECT new_broken_devices.switch_id
         , new_broken_devices.switch_name
         , new_broken_devices.trouble_id
         , new_broken_devices.trouble_status_id
         , new_broken_devices.trouble_status_name
         , new_broken_devices.device_url
         , new_broken_devices.trouble_url
         , ST_SetSRID(ST_MakePoint(new_broken_devices.longitude, new_broken_devices.latitude), 4326)
    FROM JSONB_TO_RECORDSET(in_broken_devices_list_jsonb) AS new_broken_devices(
                                                                                switch_id INT,
                                                                                switch_name TEXT,
                                                                                latitude NUMERIC(8, 6),
                                                                                longitude NUMERIC(9, 6),
                                                                                trouble_id INT,
                                                                                trouble_status_id INT,
                                                                                trouble_status_name TEXT,
                                                                                device_url TEXT,
                                                                                trouble_url TEXT
        );

    GET DIAGNOSTICS out_inserted_rows = ROW_COUNT;

    RETURN out_inserted_rows;
END;

$$
