
use sql_and_tableau;

/* joining the two tables */
select cs.student_id, c.track_name, cs.date_enrolled, cs.date_completed 
from career_track_info c
join career_track_student_enrollments cs on c.track_id=cs.track_id;

/* creating new three columns: student_track_id, track_completed, and days_for_completion */
select a.*
from
 (select
 row_number() over(order by cs.student_id desc, c.track_name desc) as student_track_id,
 case when cs.date_completed is not null then 'Yes'
 else 'No' end as track_completed,
 datediff(cs.date_completed, cs.date_enrolled) as days_for_completion
 from career_track_info c
 join career_track_student_enrollments cs on c.track_id=cs.track_id
 where cs.date_completed is not null) as a;
 
 /* creating a column: completion_bucket */
 select a.*,
 case 
  when days_for_completion = 0 then 'Same day'
  when days_for_completion between 1 and 7 then '1 to 7 days'
  when days_for_completion between 8 and 30 then '8 to 30 days'
  when days_for_completion between 31 and 60 then '31 to 60 days'
  when days_for_completion between 61 and 90 then '61 to 90 days'
  when days_for_completion between 91 and 365 then '91 to 365 days'
  when days_for_completion > 365 then '366+ days' 
end as completion_bucket
from
 (select cs.date_enrolled, cs.date_completed, c.track_name, cs.student_id,
 row_number() over(order by cs.student_id desc, c.track_name desc) as student_track_id,
 case when cs.date_completed is not null then 1
 else 0 end as track_completed,
 datediff(cs.date_completed, cs.date_enrolled) as days_for_completion
 from career_track_info c
 join career_track_student_enrollments cs on c.track_id=cs.track_id) as a;

 
 


