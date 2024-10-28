SELECT
    genre_id,
    LOWER(name) AS genre_name_lower  -- Clean up to lowercase for consistency
FROM {{ ref('raw_genres') }}
WHERE name IS NOT NULL  -- Ensure that each genre has a name