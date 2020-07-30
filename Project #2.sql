----------------------------------------------------------------------------
-- Creating users database
----------------------------------------------------------------------------
CREATE TABLE users (
	-- 2.b
  username_id SERIAL PRIMARY KEY,
	-- 1.a.i, 1.a.ii, 1.a.iii, and 1.e
  username VARCHAR(25) CONSTRAINT required_unique_username UNIQUE NOT NULL,
	log_in TIMESTAMP WITH TIME ZONE
);
-- 2.a
CREATE INDEX log_in_index ON users (log_in);
-- 2.c
CREATE INDEX username_index ON users (username VARCHAR_PATTERN_OPS);
----------------------------------------------------------------------------
-- Creating topics database
----------------------------------------------------------------------------
CREATE TABLE topics (
	-- 2.d
	topic_id SERIAL PRIMARY KEY,
	-- 1.b.i, 1.b.ii, and 1.b.iii
	topic VARCHAR(30) CONSTRAINT required_unique_topic UNIQUE NOT NULL,
	-- 1.b.iv
	topic_description VARCHAR(500)
);
-- 2.e
CREATE INDEX topic_index ON topics (topic VARCHAR_PATTERN_OPS);
----------------------------------------------------------------------------
-- Creating posts database
----------------------------------------------------------------------------
CREATE TABLE posts (
	id SERIAL PRIMARY KEY,
	-- 1.c and 1.c.iv
	topic_id INTEGER REFERENCES topics ON DELETE CASCADE,
	-- 1.c and 1.c.v
	user_id INTEGER REFERENCES users ON DELETE SET NULL,
	time_stamp_post TIMESTAMP WITH TIME ZONE,
	-- 1.c.i and 1.c.ii
	title VARCHAR(100) CONSTRAINT required_title NOT NULL,
	url VARCHAR(4000) DEFAULT NULL,
	text_content TEXT DEFAULT NULL,
	-- 1.c.iii
	CONSTRAINT url_or_text
	CHECK(url IS NOT NULL AND text_content IS NULL OR
				url IS NULL AND text_content IS NOT NULL)
);
-- 2.f
CREATE INDEX latest_posts_per_topic ON posts (topic_id,time_stamp_post);
-- 2.g
CREATE INDEX latest_posts_per_user ON posts (topic_id,user_id);
-- 2.h
CREATE INDEX post_url_moderation ON posts (url VARCHAR_PATTERN_OPS);
----------------------------------------------------------------------------
-- Creating comments database
----------------------------------------------------------------------------
CREATE TABLE comments (
	id SERIAL PRIMARY KEY,
	-- 1.d and 1.d.iv
	user_id INTEGER REFERENCES users ON DELETE SET NULL,
	-- 1.d.iii
	post_id INTEGER REFERENCES posts ON DELETE CASCADE,
	-- 1.d.i
	text_content TEXT CONSTRAINT required_text_content NOT NULL,
	-- 2.k
	time_stamp_comment TIMESTAMP WITH TIME ZONE,
	-- 1.d.ii and 1.d.v
	level INTEGER REFERENCES comments ON DELETE CASCADE
);
-- 2.i
CREATE INDEX level_index ON comments (level);
-- 2.j
CREATE INDEX parent_id_index ON comments (post_id);
-- 2.k
CREATE INDEX comments_by_user ON comments (user_id,time_stamp_comment);
----------------------------------------------------------------------------
-- Creating votes database
----------------------------------------------------------------------------
CREATE TABLE votes (
	PRIMARY KEY (user_id, post_id),
	-- 1.e.iii
	user_id INTEGER REFERENCES users ON DELETE SET NULL,
	-- 1.e.ii
	post_id INTEGER REFERENCES posts ON DELETE CASCADE,
	-- 1.e.i
	vote INTEGER CONSTRAINT up_down_vote CHECK(vote=1 OR vote=-1)
);
-- 2.l
CREATE INDEX score_post ON votes (vote);
----------------------------------------------------------------------------
-- 3. Tables have been normalized with various constraints and indexes
-- 4. Format is correct
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- Inserting data into user database
----------------------------------------------------------------------------
-- All users who've made posts
INSERT INTO users (username)
	SELECT DISTINCT username
	FROM bad_posts;
-- All users who've made only commented
INSERT INTO users (username)
	SELECT DISTINCT bc.username
	FROM bad_comments bc
	LEFT JOIN users u
	ON bc.username = u.username
	WHERE u.username IS NULL;
-- All users who've only up voted
INSERT INTO users (username)
	WITH table1 AS (SELECT REGEXP_SPLIT_TO_TABLE(upvotes, ',')
									AS upvote
								  FROM bad_posts)
	SELECT DISTINCT upvote
	FROM table1
	LEFT JOIN users u
	ON table1.upvote = u.username
	WHERE u.username IS NULL;
-- All users who've only down voted
INSERT INTO users (username)
	WITH table1 AS (SELECT REGEXP_SPLIT_TO_TABLE(downvotes, ',')
									AS downvote
									FROM bad_posts)
	SELECT downvote
	FROM table1
	LEFT JOIN users u
	ON table1.downvote = u.username
	WHERE u.username IS NULL;
----------------------------------------------------------------------------
-- Inserting data into topics database
----------------------------------------------------------------------------
-- All topic names
INSERT INTO topics (topic)
	SELECT DISTINCT topic
	FROM bad_posts;
----------------------------------------------------------------------------
-- Inserting data into posts database
----------------------------------------------------------------------------
-- all post data into posts database
INSERT INTO posts (id, topic_id, user_id, title, url, text_content)
	SELECT bp.id, t.topic_id, u.username_id,
				 LEFT(bp.title,100), bp.url, bp.text_content
	FROM bad_posts bp
	JOIN topics t
	ON bp.topic = t.topic
	JOIN users u
	ON bp.username = u.username;
---------------------------------------------------------------------------
-- Inserting data into comments database
---------------------------------------------------------------------------
INSERT INTO comments (user_id, post_id, text_content, level)
	SELECT u.username_id, p.id, bc.text_content,
	       ROW_NUMBER() OVER(PARTITION BY p.id)
	FROM bad_comments bc
	JOIN posts p
	ON bc.post_id = p.id
	JOIN users u
	ON bc.username = u.username;
---------------------------------------------------------------------------
-- Inserting data into votes database
---------------------------------------------------------------------------
INSERT INTO votes (user_id, post_id, vote)
	WITH table1 AS (SELECT id, REGEXP_SPLIT_TO_TABLE(downvotes, ',')
									AS downvote
									FROM bad_posts)
	SELECT u.username_id, table1.id, -1 AS vote
	FROM table1
	JOIN users u
	ON u.username = table1.downvote;

INSERT INTO votes (user_id, post_id, vote)
	WITH table1 AS (SELECT id, REGEXP_SPLIT_TO_TABLE(upvotes, ',')
									AS upvote
									FROM bad_posts)
	SELECT u.username_id, table1.id, 1 AS vote
	FROM table1
	JOIN users u
	ON u.username = table1.upvote;
