CREATE VIEW nextgis.order_prorabotka_last_5_years AS
SELECT o.id
     , o.order_type_id
     , o.description
     , o.latitude
     , o.longitude
     , o.link
     , o.date
     , o.geometry
FROM nextgis."order" AS o
WHERE o.order_type_id = 1
  AND o.date >= NOW() - INTERVAL '5 year';

CREATE VIEW nextgis.order_prorabotka_older_than_5_years AS
SELECT o.id
     , o.order_type_id
     , o.description
     , o.latitude
     , o.longitude
     , o.link
     , o.date
     , o.geometry
FROM nextgis."order" AS o
WHERE o.order_type_id = 1
  AND o.date < NOW() - INTERVAL '5 year';

CREATE VIEW nextgis.order_podklyuchenie_last_5_years AS
SELECT o.id
     , o.order_type_id
     , o.description
     , o.latitude
     , o.longitude
     , o.link
     , o.date
     , o.geometry
FROM nextgis."order" AS o
WHERE o.order_type_id = 2
  AND o.date >= NOW() - INTERVAL '5 year';

CREATE VIEW nextgis.order_podklyuchenie_older_than_5_years AS
SELECT o.id
     , o.order_type_id
     , o.description
     , o.latitude
     , o.longitude
     , o.link
     , o.date
     , o.geometry
FROM nextgis."order" AS o
WHERE o.order_type_id = 2
  AND o.date < NOW() - INTERVAL '5 year';
