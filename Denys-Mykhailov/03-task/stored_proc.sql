USE task_03;

DELIMITER $$

CREATE PROCEDURE add_album_to_artist(
    IN artist_id_param BIGINT UNSIGNED,
    IN album_title_param VARCHAR(255)
)
BEGIN
    INSERT INTO Albums (artist_id, title, release_date)
    VALUES (artist_id_param, album_title_param, date(NOW()));
END$$

DELIMITER ;

-- Test the stored procedure
CALL add_album_to_artist(1, 'New Album Title');