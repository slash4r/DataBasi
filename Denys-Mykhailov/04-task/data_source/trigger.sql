USE task_04;

DELIMITER $$

CREATE TRIGGER after_track_insert
AFTER INSERT ON Tracks
FOR EACH ROW
BEGIN
    -- Declare a variable to store the artist_id of the album
    DECLARE album_artist_id BIGINT;

    -- Select the artist_id from the Albums table based on the album_id of the newly inserted track
    SELECT artist_id INTO album_artist_id
    FROM Albums
    WHERE album_id = NEW.album_id;

    -- Insert a new record into Tracks_Artists with the newly inserted track and the associated artist
    INSERT INTO Tracks_Artists (track_id, artist_id)
    VALUES (NEW.track_id, album_artist_id);
END$$

DELIMITER ;
