CREATE TABLE IF NOT EXISTS sessions (
    id           CHAR(72) PRIMARY KEY,
    session_data TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS likes (
    id           INTEGER PRIMARY KEY AUTO_INCREMENT,
    from_id      BIGINT,
    to_id        BIGINT,
    to_name      VARCHAR(255),
    to_explain   VARCHAR(255),
    like_status  BIGINT,
    UNIQUE KEY (from_id,to_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS like_status_mst (
    id           INTEGER PRIMARY KEY,
    text         VARCHAR(255) NOT NULL,
    UNIQUE KEY (text)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT IGNORE INTO tags (id, text) VALUES
    (1, 'が好き'),
    (2, 'とデートしたい'),
    (3, 'とランチしたい'),
    (4, 'が何か気になる');
