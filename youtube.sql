/* 
 Calculate the number of videos uploded each year
*/

select 
	Year, count(video_id)
from 
(
	select video_id, strftime('%Y',upload_date) as "Year"
	from youtube_api
)
group by Year

/* 
find top 10 video with the most view_count and show its upload_date and rank
*/

SELECT 
		ROW_NUMBER() OVER(ORDER BY view_count DESC) AS rank_by_view,
		video_id, video_title, view_count, upload_date
FROM youtube_api
order by view_count DESC
limit 10;

/* 
find top 10 video with the most like_count and show its upload_date and rank
*/

SELECT
	ROW_NUMBER() OVER(ORDER BY like_count DESC) AS rank_by_like,
	video_id, video_title, like_count, upload_date
FROM youtube_api
order by like_count DESC
limit 10;

/* 
	list the top 20 videos on video leaderboard, and see their ranking situations on like_count leaderboard
*/

select *
from (
  SELECT 	ROW_NUMBER() OVER(ORDER BY view_count DESC) AS rank_by_view,
		video_id, video_title, view_count, upload_date
  FROM youtube_api
  order by view_count DESC) /* the view_count leaderboard */
  as top10_view  Left JOIN
  (
    SELECT ROW_NUMBER() OVER(ORDER BY like_count DESC) AS rank_by_like,
		video_id, video_title, like_count, upload_date
    FROM youtube_api
    order by like_count DESC) /* the like_count leaderboard */
  as top10_like on top10_view.video_id = top10_like.video_id
  limit 20;
  