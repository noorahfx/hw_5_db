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
-- DBLP Queries
\c dblp
--------------------------------------------------------------------------------

--
\echo QUERY #1
\echo
-- List the coauthors of Jennifer Widom who have written more publications
-- than she has.
--
-- You must write the query in a generic way that would work for any author.
-- Hint: The only table you need is auth. Use subqueries to do the counting.
--
-- Schema: coauthor
--  Order: coauthor

SELECT DISTINCT author AS coauthor
FROM auth
WHERE author = ANY 
	(SELECT author 
	 FROM auth
	 WHERE dblp_key = ANY 
		(SELECT dblp_key
		 FROM auth
		 WHERE author LIKE'Jennifer Widom'
		 )
	AND author NOT LIKE 'Jennifer Widom'
	)
GROUP BY author
HAVING COUNT(author) >
	(SELECT COUNT(author)
	 FROM auth
	 WHERE author LIKE 'Jennifer Widom'
	);
	
--
\echo QUERY #2
\echo
-- Find all publications since Jan 1, 2000 that have the words 'K-12 education'
-- anywhere in the title (i.e., the user typed that into a simple search box).
--
-- Schema: year, title, dblp_type, booktitle, journal, volume, issnum, pages
--  Order: dblp_mdate, dblp_key

SELECT  year,title, dblp_type, booktitle, 
	journal, volume, issnum, pages
FROM publ
	NATURAL JOIN publ_fts
WHERE year >= 2000
AND title_tsv @@ plainto_tsquery('K-12 education') 
ORDER BY dblp_mdate, dblp_key;


--
\echo QUERY #3
\echo
-- Search for publications that have a title similar to our textbook's title.
-- Set the similarity threshold to 0.45 before running your query.
--
-- Schema: dblp_key, year, title, similarity
--  Order: similarity DESC, dblp_key


SELECT set_limit('0.45');
SELECT dblp_key, year, title, similarity('A First Course in Database Systems', title) AS similarity
FROM  publ
WHERE title % 'A First Course in Database Systems' 
ORDER BY similarity DESC, dblp_key;



--


--------------------------------------------------------------------------------
-- TPC-H Queries
\c tpch
--------------------------------------------------------------------------------

--
\echo QUERY #4
\echo
-- Which parts are supplied in the Europe region?
-- Display in order of retail price and part number.
--
-- Schema: p_partkey, p_name, p_retailprice

SELECT DISTINCT part.p_partkey, part.p_name, part.p_retailprice
FROM part 
FULL JOIN partsupp ON partsupp.ps_partkey = part.p_partkey
FULL JOIN supplier ON supplier.s_suppkey = partsupp.ps_suppkey
FULL JOIN nation ON nation.n_nationkey = supplier.s_nationkey
FULL JOIN region on region.r_regionkey = nation.n_regionkey
WHERE region.r_regionkey = 3
ORDER BY part.p_retailprice, part.p_partkey
LIMIT 500;

--
\echo QUERY #5
\echo
-- Find the minimum cost supplier for each part.
-- Display in ascending order by part number.
--
-- You must use a WITH clause to receive full credit.
-- Hint: Find the minimum cost of each part first.
--
-- Schema: ps_partkey, ps_suppkey, min_supplycost

WITH min_cost_supplier AS (
	SELECT DISTINCT ps_partkey, min(ps_supplycost) AS ms
	FROM partsupp
	GROUP BY ps_partkey
	)
SELECT m.ps_partkey, ps.ps_suppkey, m.ms
FROM min_cost_supplier AS m
JOIN partsupp AS ps ON ps.ps_partkey = m.ps_partkey
AND ps.ps_supplycost = m.ms
ORDER BY m.ps_partkey ASC
LIMIT 500;

--
\echo QUERY #6
\echo
-- Which urgent priority orders have only one line item?
-- Display in ascending order by the order number.
--
-- Schema: o_orderkey, o_custkey, o_orderstatus

SELECT DISTINCT o_orderkey, o_custkey, o_orderstatus
FROM orders AS o
JOIN lineitem AS l ON l.l_orderkey = o.o_orderkey
WHERE o.o_orderpriority = '1-URGENT' 	
GROUP BY o_orderkey, o_custkey, o_orderstatus
HAVING COUNT(o_orderkey) = 1
ORDER BY o_orderkey ASC
LIMIT 500;



