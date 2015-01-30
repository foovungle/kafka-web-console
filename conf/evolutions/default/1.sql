# --- !Ups

CREATE TABLE zookeepers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  host VARCHAR(255) NOT NULL,
  port INT NOT NULL,
  statusId INT NOT NULL,
  groupId INT NOT NULL,
  chroot VARCHAR(255)
);

CREATE TABLE groups (
  id INT,
  name VARCHAR(255),
  PRIMARY KEY (id)
);

CREATE TABLE status (
  id INT,
  name VARCHAR(255),
  PRIMARY KEY (id)
);

CREATE TABLE offsetHistory (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  zookeeperId INT,
  topic VARCHAR(255),
  FOREIGN KEY zkId (zookeeperId) REFERENCES zookeepers(id) ON DELETE CASCADE,
  UNIQUE zkTopic (zookeeperId, topic)
);

CREATE TABLE offsetPoints (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  consumerGroup VARCHAR(255),
  timestamp DATETIME,
  offsetHistoryId BIGINT,
  partition INT,
  offset BIGINT,
  logSize BIGINT,
  FOREIGN KEY offhistId (offsetHistoryId) REFERENCES offsetHistory(id) ON DELETE CASCADE
);

CREATE TABLE settings (
  key_ VARCHAR(255) PRIMARY KEY,
  value VARCHAR(255)
);

INSERT INTO groups (id, name) VALUES (0, 'ALL');
INSERT INTO groups (id, name) VALUES (1, 'DEVELOPMENT');
INSERT INTO groups (id, name) VALUES (2, 'PRODUCTION');
INSERT INTO groups (id, name) VALUES (3, 'STAGING');
INSERT INTO groups (id, name) VALUES (4, 'TEST');

INSERT INTO status (id, name) VALUES (0, 'CONNECTING');
INSERT INTO status (id, name) VALUES (1, 'CONNECTED');
INSERT INTO status (id, name) VALUES (2, 'DISCONNECTED');
INSERT INTO status (id, name) VALUES (3, 'DELETED');

INSERT INTO settings (key_, value) VALUES ('PURGE_SCHEDULE', '0 0 0 ? * SUN *');
INSERT INTO settings (key_, value) VALUES ('OFFSET_FETCH_INTERVAL', '30');

# --- !Downs

DROP TABLE IF EXISTS settings;
DROP TABLE IF EXISTS offsetPoints;
DROP TABLE IF EXISTS offsetHistory;
DROP TABLE IF EXISTS status;
DROP TABLE IF EXISTS groups;
DROP TABLE IF EXISTS zookeepers;
