DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

PRAGMA foreign_keys = ON;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL

);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(100) NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
  FOREIGN KEY (question_id) REFERENCES questions(id)

);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
  FOREIGN KEY (question_id) REFERENCES questions(id)
  FOREIGN KEY (parent_id) REFERENCES replies(id)

);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY ,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
  FOREIGN KEY (question_id) REFERENCES questions(id)

);

INSERT INTO
  users (fname, lname)
  VALUES
  ('Alex', 'Abrams'),
  ('Peter', 'Griffon'),
  ('Urosh', 'Stojkovikj'),
  ('Taco', 'McClaren'),
  ('Pam', 'Poovie');

INSERT INTO
  questions (title, body, user_id)
  VALUES
  ('Why is the sky?', 'The sky is blue and I dunno whyyy',(SELECT id FROM users
  WHERE id = 1)),
  ('Why is the sky?', 'The sky is blue and I dunno whyyy',(SELECT id FROM users
  WHERE id = 2)),
  ('Why is the sky?', 'The sky is blue and I dunno whyyy',(SELECT id FROM users
  WHERE id = 3)),
  ('Why is the sky?', 'The sky is blue and I dunno whyyy',(SELECT id FROM users
  WHERE id = 1)),
  ('Taco bell?', 'The cheesy gordita crucnch is worth the diaherra',(SELECT id FROM users
  WHERE fname = 'Urosh'));

INSERT INTO
  replies (body, question_id, parent_id, user_id)
  VALUES
  ('REEEEEEEEEEEEEEEEEEEEE', (SELECT id FROM questions WHERE id = 1), (SELECT id FROM replies), (SELECT id FROM users WHERE id = 1)),
  ('GG EZ', (SELECT id FROM questions WHERE id = 2), (SELECT id FROM replies), (SELECT id FROM users WHERE id = 2)),
  ('Garfield isnt even funny', (SELECT id FROM questions WHERE id = 3), (SELECT id FROM replies), (SELECT id FROM users WHERE id = 3)),
  ('The sky is blue cause of the ocean', (SELECT id FROM questions WHERE id = 1), (SELECT id FROM replies), (SELECT id FROM users WHERE id = 1));
