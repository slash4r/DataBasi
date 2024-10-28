SELECT
    track_id,
    title AS track_title,
    duration_sec,
    album_id,
    genre_id,
    CASE
        WHEN status = 'pending' THEN 'Pending'
        WHEN status = 'active' THEN 'Active'
        WHEN status = 'inactive' THEN 'Inactive'
        ELSE 'Unknown'
    END AS track_status  -- Standardize status values
FROM {{ ref('raw_tracks') }}
WHERE title IS NOT NULL  -- Ensure that each track has a title
AND duration_sec > 10  -- Remove any trash data