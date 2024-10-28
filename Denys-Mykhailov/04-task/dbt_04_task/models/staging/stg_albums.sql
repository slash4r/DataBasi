SELECT
    album_id,
    title AS album_title,
    release_date,
    artist_id
FROM {{ ref('raw_albums') }}
WHERE release_date IS NOT NULL  -- Ensure that the album has a valid release date
