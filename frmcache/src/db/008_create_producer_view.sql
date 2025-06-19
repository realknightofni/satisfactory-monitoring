-- Write your migrate up statements here

CREATE VIEW producer AS
    (
        SELECT id, metric, url, session_name,
           (data ->> 'Name') as building_name,
           (data ->> 'Recipe') as recipe_name,
           (data ->> 'IsPaused')::BOOLEAN as is_paused,
           (data -> 'PowerInfo'->> 'CircuitGroupID') as circuit_id,
           (data ->> 'ManuSpeed')::NUMERIC as clock_speed,
           (data -> 'PowerInfo' ->> 'PowerConsumed')::NUMERIC as power_consumed,
           (data -> 'PowerInfo' ->> 'MaxPowerConsumed')::NUMERIC as power_consumed_max,
           (data -> 'production' -> 0 ->> 'ProdPercent')::NUMERIC as effeciency,
           (data -> 'production' -> 0 ->> 'Name') as main_item_name,
           (data -> 'production' -> 0 ->> 'CurrentProd')::NUMERIC as main_item_output,
           (data -> 'production' -> 1 ->> 'Name') as byproduct_item_name,
           (data -> 'production' -> 1 ->> 'CurrentProd')::NUMERIC as byproduct_item_output,
           (data -> 'location' ->> 'x')::NUMERIC/100 as x,
           (data -> 'location' ->> 'y')::NUMERIC/100 as y,
           (data -> 'location' ->> 'z')::NUMERIC/100 as z,
           (((data -> 'location' ->> 'x')::NUMERIC + 375000) * 0.0000001015) as longitude,
           (((data -> 'location' ->> 'y')::NUMERIC + 375000) * -0.0000001172) as latitude
        FROM cache
        WHERE metric in ('factory', 'extractor')
    );

---- create above / drop below ----

-- Write your migrate down statements here. If this migration is irreversible
-- Then delete the separator line above.

DROP VIEW IF EXISTS producer;
