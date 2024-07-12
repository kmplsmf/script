CREATE OR REPLACE FUNCTION public.order_create_jsonb(in_orders_list_jsonb jsonb)
  RETURNS INT
  LANGUAGE plpgsql
AS
$$
BEGIN
  INSERT INTO result_1(order_id, order_type_id, description, latitude, longitude, order_url, geom)
  SELECT new_orders_list.order_id,
         new_orders_list.order_type_id,
         new_orders_list.description,
         new_orders_list.latitude,
         new_orders_list.longitude,
         new_orders_list.order_url,
         ST_SetSRID(ST_MakePoint(new_orders_list.longitude, new_orders_list.latitude), 4326)
  FROM jsonb_to_recordset(in_orders_list_jsonb) as new_orders_list(order_id int, order_type_id int, description text,
                                                                   latitude double precision,
                                                                   longitude double precision, order_url text);
  RETURN 0;
END;
$$;
