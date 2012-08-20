CREATE TABLE IF NOT EXISTS sessions (
    id           CHAR(72) PRIMARY KEY,
    session_data TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS respecteds (
    id           INTEGER PRIMARY KEY AUTO_INCREMENT,
    from_id      BIGINT,
    to_id        BIGINT,
    to_name      VARCHAR(255),
    tags         VARCHAR(255),
    UNIQUE KEY (from_id,to_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS tags (
    id           INTEGER PRIMARY KEY AUTO_INCREMENT,
    text         VARCHAR(255) NOT NULL,
    UNIQUE KEY (text)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT IGNORE INTO tags (id, text) VALUES
    (1, 'perl'),
    (2, 'mysql'),
    (3, 'Amon2'),
    (4, 'Catalyst');
