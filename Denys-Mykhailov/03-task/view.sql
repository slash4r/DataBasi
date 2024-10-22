USE task_03;

CREATE VIEW view_ukr_tracks_info AS
SELECT
    t.track_id,
    a.title AS album_title,
    t.title AS track_title,
    ar.name AS artist_name,
    ar.country AS artist_country,
    g.name AS genre,
    t.status
FROM Tracks t
         JOIN Albums a ON t.album_id = a.album_id
         JOIN Artists ar ON a.artist_id = ar.artist_id
         JOIN Genres g ON t.genre_id = g.genre_id
WHERE ar.country = 'Ukraine';
