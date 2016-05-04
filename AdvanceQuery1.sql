--
-- Name: Fahim NoorAhmad
--
-- Write your queries below each comment. Please use good style (one clause
-- per line, JOIN syntax, indentation) and make sure all queries end with a
-- semicolon. When necessary, limit the output to the first 500 results.
--
-- DO NOT MODIFY OR DELETE ANY OTHER LINES!
--

--------------------------------------------------------------------------------
-- IMDb Queries
\c imdb
--------------------------------------------------------------------------------

--
\echo QUERY #1
\echo
-- For the movies named Star Wars, what kind of movie was it and what year was
-- it released?
--
-- Schema: kind varchar(15), year integer
--  Order: year, kind

SELECT kind_type.kind, movie.year
FROM movie
JOIN kind_type
ON kind_type.id = movie.kind_id
WHERE title = 'Star Wars'
ORDER BY "year", kind_id;


--
\echo QUERY #2
\echo
-- Show all actors and actresses for The Lego Movie (2014).
--
-- Schema: real_name text, char_name text
--  Order: nr_order

SELECT person.name, "character".name
FROM movie
JOIN cast_info ON movie.id = cast_info.movie_id
JOIN person ON cast_info.person_id = person.id
JOIN character ON cast_info.char_id = character.id
JOIN role_type ON cast_info.role_id = role_type.id
WHERE (movie.title = 'The Lego Movie') AND( movie.kind_id = 1)
ORDER BY person.name;

--
\echo QUERY #3
\echo
-- For each tv movie in 2015 that has runtime information,
-- what is the plot of the movie? If there is no plot record
-- in the database, simply use NULL for that movie's plot.
-- Only display the first 15 results (there are 2040 total).
--
-- Schema: title text, runtime text, plot text
--  Order: descending runtime, ascending title


--
\echo QUERY #4
\echo
-- List the top 10 actors and actresses with "Smith" in their name.
-- By "top" we mean those who have been in the most movies of any
-- type. If a person plays more than one role in a particular movie,
-- then that movie should only be counted once for that person.
--
-- Schema: name text, count bigint
--  Order: descending count, ascending name


--------------------------------------------------------------------------------
-- VDOE Queries
\c vdoe
--------------------------------------------------------------------------------

--
\echo QUERY #5
\echo
-- How many students were enrolled in each grade at Harrisonburg High in 2014?
--
-- Schema: grade_num integer, fall_cnt integer
--  Order: grade_num

SELECT grade_num, fall_cnt
FROM fall_membership
where sch_year = 2014
AND grade_num >=9
AND div_num =113
AND sch_num = 2
AND race ='ALL'
AND gender = 'ALL'
AND disabil = 'ALL'
AND lep = 'ALL'
AND disadva = 'ALL'
ORDER BY grade_num;

--
\echo QUERY #6
\echo
-- What are the five largest schools in terms of their 2014 total enrollment?
--
-- Schema: div_name text, sch_name text, fall_cnt integer
--  Order: descending fall_cnt

SELECT composite.div_name, school.sch_name, fall_membership.fall_cnt
FROM school
JOIN composite ON school.div_num = composite.div_num AND composite.comp_year = '2012-2014'
JOIN fall_membership ON school.sch_num = fall_membership.sch_num AND school.div_num = fall_membership.div_num
WHERE fall_membership.sch_year = 2014
AND grade_num = 0
AND gender = 'ALL'
AND disadva = 'ALL'
AND disabil = 'ALL' 
AND lep = 'ALL'
ORDER BY fall_membership.fall_cnt DESC
LIMIT 5;


--
\echo QUERY #7
\echo
-- List the SOL results for 8th graders from Skyline Middle in 2014-2015,
-- showing all scores for male and female students as well as both genders.
--
-- Schema: test_name text, gender text, avg_score integer,
--         pass_advn real, pass_prof real, pass_rate real, fail_rate real
--  Order: test_name, gender
SELECT 
      sol_test_data.test_name, 
	sol_test_data.gender,  
	sol_test_data.avg_score,
	sol_test_data.pass_advn,
	sol_test_data.pass_prof, 
	sol_test_data.pass_rate,
      sol_test_data.fail_rate
FROM    
      sol_test_data	
WHERE   
      sol_test_data.sch_num =111

	AND sol_test_data.div_num =113
	AND sol_test_data.test_level = '8'
	AND sol_test_data.sch_year = 2014
	AND sol_test_data.race = 'ALL'
	AND sol_test_data.disabil = 'ALL'
	AND sol_test_data.lep = 'ALL'
	AND sol_test_data.disadva = 'ALL'
	
ORDER BY 
      test_name, gender;

--
\echo QUERY #8
\echo
-- In 2014-2015, which schools had more than 1000 students enrolled
-- and achieved an SOL pass rate of over 90% in 8th grade math?
--
-- Schema: div_num text, sch_num text
--  Order: div_num, sch_num

SELECT sol_test_data.div_num, sol_test_data.sch_num
FROM sol_test_data
JOIN fall_membership
ON sol_test_data.sch_num = fall_membership.sch_num
AND sol_test_data.sch_year = fall_membership.sch_year
AND sol_test_data.div_num = fall_membership.div_num
AND sol_test_data.race = fall_membership.race
WHERE sol_test_data.pass_rate > '90'
AND sol_test_data.test_level = '8'
AND sol_test_data.subject ='MATH'
AND sol_test_data.test_name = 'Mathematics'
AND sol_test_data.sch_year = 2014
AND sol_test_data.race = 'ALL'
AND sol_test_data.gender = 'ALL'
AND sol_test_data.disabil = 'ALL'
AND sol_test_data.lep = 'ALL'
AND sol_test_data.disadva = 'ALL'
AND sol_test_data.sch_num > 0
AND fall_membership.disabil = 'ALL'
AND fall_membership.lep = 'ALL'
AND fall_membership.disadva = 'ALL'
AND fall_membership.gender = 'ALL'
AND fall_membership.fall_cnt > 1000
ORDER BY sol_test_data.div_num, sol_test_data.sch_num;

