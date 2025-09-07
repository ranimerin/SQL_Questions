

create table booking_table (
    booking_id varchar(10),
    booking_date date,
    user_id varchar(10),
    line_of_business varchar(20)
);

insert into booking_table (booking_id, booking_date, user_id, line_of_business) values
('b1',  '2022-03-23', 'u1', 'Flight'),
('b2',  '2022-03-27', 'u2', 'Flight'),
('b3',  '2022-03-28', 'u1', 'Hotel'),
('b4',  '2022-03-31', 'u4', 'Flight'),
('b5',  '2022-04-02', 'u1', 'Hotel'),
('b6',  '2022-04-02', 'u2', 'Flight'),
('b7',  '2022-04-06', 'u5', 'Flight'),
('b8',  '2022-04-06', 'u6', 'Hotel'),
('b9',  '2022-04-06', 'u2', 'Flight'),
('b10', '2022-04-10', 'u1', 'Flight'),
('b11', '2022-04-12', 'u4', 'Flight'),
('b12', '2022-04-16', 'u1', 'Flight'),
('b13', '2022-04-19', 'u2', 'Flight'),
('b14', '2022-04-20', 'u5', 'Hotel'),
('b15', '2022-04-22', 'u6', 'Flight'),
('b16', '2022-04-26', 'u4', 'Hotel'),
('b17', '2022-04-28', 'u2', 'Hotel'),
('b18', '2022-04-30', 'u1', 'Hotel'),
('b19', '2022-05-04', 'u4', 'Hotel'),
('b20', '2022-05-06', 'u1', 'Flight');

create table user_table (
    user_id varchar(10),
    segment varchar(10)
);

insert into user_table (user_id, segment) values
('u1', 's1'),
('u2', 's1'),
('u3', 's1'),
('u4', 's2'),
('u5', 's2'),
('u6', 's3'),
('u7', 's3'),
('u8', 's3'),
('u9', 's3'),
('u10', 's3');

select * from user_table
select * from booking_table

//***1. Write an SQL query to show, for each segment, the total number of users and the number of users who booked a flight in April 2022.**/
select u.segment,count(distinct u.user_id) as total_users,
count(distinct case when DATEPART(month,b.booking_date)=04 and DATEPART(year,b.booking_date)=2022 and b.line_of_business='Flight' then u.user_id else null end)
from user_table u
left join booking_table b
on b.user_id =u.user_id
group by u.segment

---2. Write a query to identify users whose first booking was a hotel booking
with cte as
(select *,ROW_NUMBER() over(partition by user_id order by booking_date)as rn
from
booking_table)
select * from 
cte
where cte.rn=1 and cte.line_of_business='Hotel'

--3. Write a query to calculate the number of days between the first and last booking of the user with user_id = 1
with cte as
(select user_id,MIN(booking_date) as first,MAX(booking_date)as last
from booking_table
group by user_id)
select *,datediff(day,first,last) as diff 
from
cte where user_id='u1'


--4. Write a query to count the number of flight and hotel bookings in each user segment for the year 2022
with cte2 as
(select b.booking_id,b.user_id,b.line_of_business,u.segment
from booking_table b
inner join user_table u
on b.user_id=u.user_id
where DATEPART(year,b.booking_date)=2022
and b.line_of_business in ('Flight','Hotel'))
select cte2.segment,count(case when cte2.line_of_business='Flight' then cte2.booking_id else null end) as count_of_flight,
count(case when cte2.line_of_business='Hotel' then cte2.booking_id else null end) as count_of_hotel
from cte2 group by cte2.segment

--5. Find, for each segment, the user who made the earliest booking in April 2022, and also return how many total bookings that user made in April 2022.
with cte as
(select b.*,u.segment,
row_number() over(partition by u.segment order by b.booking_date,b.booking_id)as rn,
count(*) over(partition by b.user_id) as count_user
from booking_table b
inner join user_table u
on u.user_id=b.user_id
where DATEPART(year,b.booking_date)=2022 and DATEPART(month,b.booking_date)=04)
select * from cte where cte.rn=1


