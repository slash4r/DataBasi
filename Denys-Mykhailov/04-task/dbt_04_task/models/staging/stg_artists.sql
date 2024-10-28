SELECT
    artist_id,
    name AS artist_name,
    UPPER(country) AS country,  -- Convert country names to uppercase for consistency
    user_id
FROM {{ ref('raw_artists') }}
WHERE name IS NOT NULL  -- Remove any rows with missing artist names
