\set ON_ERROR_STOP on
INSERT INTO contents(channel_id,sequence,id,text,idempotency_key,author_id,request_text_hash)
SELECT 'general',n,'message-'||n,'baseline message '||n,'seed-'||n,:'owner',sha256(convert_to('baseline message '||n,'UTF8')) FROM generate_series(1,:objects) n;
INSERT INTO events(channel_id,sequence,content_sequence,cursor,type)
SELECT 'general',n,n,'event-'||n,'content.created' FROM generate_series(1,:objects) n;
INSERT INTO forum_threads(id,channel_id,author_id,author_name,title,body,sequence,idempotency_key)
SELECT 'topic-'||n,'baseline_forum',:'owner','Owner','baseline topic '||n,'baseline body',n,'seed-'||n FROM generate_series(1,:objects) n;
INSERT INTO forum_replies(id,channel_id,thread_id,author_id,author_name,body,sequence,idempotency_key)
SELECT 'reply-'||n,'baseline_forum','topic-1',:'owner','Owner','baseline reply '||n,n,'reply-'||n FROM generate_series(1,:objects) n;
INSERT INTO feed_posts(id,channel_id,author_id,author_name,body,sequence,idempotency_key)
SELECT 'post-'||n,'baseline_feed',:'owner','Owner','baseline post '||n,n,'seed-'||n FROM generate_series(1,:objects) n;
INSERT INTO feed_comments(id,channel_id,post_id,author_id,author_name,body,sequence,idempotency_key)
SELECT 'comment-'||n,'baseline_feed','post-1',:'owner','Owner','baseline comment '||n,n,'comment-'||n FROM generate_series(1,:objects) n;
UPDATE channels SET next_sequence=:objects+1,next_event_sequence=:objects+1;
UPDATE forum_threads SET reply_count=:objects WHERE id='topic-1';
UPDATE feed_posts SET comment_count=:objects WHERE id='post-1';
UPDATE forum_threads SET hidden=true WHERE sequence%100=0;
UPDATE feed_posts SET hidden=true WHERE sequence%100=0;
UPDATE contents SET deleted=true,text='' WHERE sequence%100=0;
ANALYZE;
SELECT json_build_object('contents',(SELECT count(*) FROM contents),
 'topics',(SELECT count(*) FROM forum_threads),'replies',(SELECT count(*) FROM forum_replies),
 'posts',(SELECT count(*) FROM feed_posts),'comments',(SELECT count(*) FROM feed_comments));
