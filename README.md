# PostGres-Relational-Databases
## Project Description
Udiddit, a social news aggregation, web content rating, and discussion website, is currently using a risky and unreliable Postgres database schema to store the forum posts, discussions, and votes made by their users about different topics. I create a new schema, fix exsiting issues, and migrate the data from the databases.<br>

## Project Files
> * Udiddit, a social news aggregator.docx - Contains the DDL of old schema, design guidlines new schema DDL, and DML data migration explanations.
> * Project #2 -  The sql code used to improve the DDL of old schema and DML to migrate data.

## Conclusion
I wrote a new Schema to accomodate the following: <br>

> 1.	Guideline #1: here is a list of features and specifications that Udiddit needs in order to support its website and administrative interface:
> * A.	Allow new users to register: <br>
> * i.	Each username has to be unique <br>
> * ii.	Usernames can be composed of at most 25 characters <br>
> * iii.	Usernames can’t be empty <br>
> * iv.	We won’t worry about user passwords for this project <br>
> * B.	Allow registered users to create new topics: <br>
> * i.	Topic names have to be unique. <br>
> * ii.	The topic’s name is at most 30 characters <br>
> * iii.	The topic’s name can’t be empty <br>
> * iv.	Topics can have an optional description of at most 500 characters. <br>
> * C.	Allow registered users to create new posts on existing topics: <br>
> * i.	Posts have a required title of at most 100 characters <br>
> * ii.	The title of a post can’t be empty. <br>
> * iii.	Posts should contain either a URL or a text content, but not both. <br>
> * iv.	If a topic gets deleted, all the posts associated with it should be automatically deleted too. <br>
> * v.	If the user who created the post gets deleted, then the post will remain, but it will become dissociated from that user. <br>
> * D.	Allow registered users to comment on existing posts: <br>
> * i.	A comment’s text content can’t be empty. <br>
> * ii.	Contrary to the current linear comments, the new structure should allow comment threads at arbitrary levels. <br>
> * iii.	If a post gets deleted, all comments associated with it should be automatically deleted too. <br>
> * iv.	If the user who created the comment gets deleted, then the comment will remain, but it will become dissociated from that user. <br>
> * v.	If a comment gets deleted, then all its descendants in the thread structure should be automatically deleted too. <br>
> * E.	Make sure that a given user can only vote once on a given post: <br>
> * i.	Hint: you can store the (up/down) value of the vote as the values 1 and -1 respectively. <br>
> * ii.	If the user who cast a vote gets deleted, then all their votes will remain, but will become dissociated from the user. <br>
> * iii. If a post gets deleted, then all the votes for that post should be automatically deleted too. <br>
> 2.	Guideline #2: here is a list of queries that Udiddit needs in order to support its website and administrative interface. Note that you don’t need to produce the DQL for those queries: they are only provided to guide the design of your new database schema. <br>
> * A.	List all users who haven’t logged in in the last year. <br>
> * B.	List all users who haven’t created any post. <br>
> * C.	Find a user by their username. <br>
> * D.	List all topics that don’t have any posts. <br>
> * E.	Find a topic by its name. <br>
> * F.	List the latest 20 posts for a given topic. <br>
> * G.	List the latest 20 posts made by a given user. <br>
> * H.	Find all posts that link to a specific URL, for moderation purposes. <br>
> * I.	List all the top-level comments (those that don’t have a parent comment) for a given post. <br>
> * J.	List all the direct children of a parent comment. <br>
> * K.	List the latest 20 comments made by a given user. <br>
> * L.	Compute the score of a post, defined as the difference between the number of upvotes and the number of downvotes. <br>
> * 3.	Guideline #3: you’ll need to use normalization, various constraints, as well as indexes in your new database schema. You should use named constraints and indexes to make your schema cleaner. <br>
> * 4.	Guideline #4: your new database schema will be composed of five (5) tables that should have an auto-incrementing id as their primary key. <br>
