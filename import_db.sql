DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255),
  body TEXT,
  author_id INTEGER NOT NULL,
  FOREIGN KEY (author_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,
  body TEXT,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS questions_likes;

CREATE TABLE questions_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users(fname, lname)
VALUES
  ('George', 'Washington'), ('John', 'Adams'), ('Barack', 'Obama');


INSERT INTO
  questions(title, body, author_id)
VALUES
  ('What did you eat for breakfast?', 'Tell me', (SELECT id FROM users WHERE fname = 'Barack')),
  ('What is your favorite animal?', 'Lions or tigers', (SELECT id FROM users WHERE fname = 'George'));

INSERT INTO
  question_follows(user_id, question_id)
VALUES
  (1, 2), (3, 2), (2, 1);

INSERT INTO
  replies(question_id, parent_id, user_id, body)
VALUES
  (1, NULL, 2, 'Cereal'), (2, NULL, 3, 'Lions'), (2, 2, 2, 'Lions suck!');

INSERT INTO
  questions_likes(user_id, question_id)
VALUES
  (1, 1), (2, 1), (3, 2);
