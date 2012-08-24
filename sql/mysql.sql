CREATE TABLE IF NOT EXISTS sessions (
    id           CHAR(72) PRIMARY KEY,
    session_data TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS users (
    id           BIGINT PRIMARY KEY,
    name         VARCHAR(255),
    token        VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS likes (
    id           INTEGER PRIMARY KEY AUTO_INCREMENT,
    from_id      BIGINT,
    from_name    VARCHAR(255),
    to_id        BIGINT,
    to_name      VARCHAR(255),
    UNIQUE KEY (from_id,to_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
