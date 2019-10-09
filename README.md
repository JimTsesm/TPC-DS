# TPC-DS

Query translation to PostgreSQL:
Modify the following template:
77, 23, 49, 30, 14, 2, 86, 70, 36, 98, 95, 94, 92, 82, 80, 40, 37, 32, 21, 20, 16, 12, 5
------------------------------------------------------------------------------------------
1.  Change to SQL queries that subtracted or added days were modified slightly:

Old:
and (cast('2000-02-28' as date) + 30 days)

New:
and (cast('2000-02-28' as date) + '30 days'::interval)

This was done on queries: 5, 12, 16, 20, 21, 32, 37, 40, 77, 80, 82, 92, 94, 95, and 98.
------------------------------------------------------------------------------------------
2.  Change to queries with ORDER BY on column alias to use sub-select.
(We added the lines that contain the following mark: --added line)

OLD:
select
    sum(ss_net_profit) as total_sum
   ,s_state
   ,s_county
   ,grouping(s_state)+grouping(s_county) as lochierarchy
   ,rank() over (
 	partition by grouping(s_state)+grouping(s_county),
 	case when grouping(s_county) = 0 then s_state end 
 	order by sum(ss_net_profit) desc) as rank_within_parent
 from
    store_sales
   ,date_dim       d1
   ,store
 where
    d1.d_month_seq between 1212 and 1212+11
 and d1.d_date_sk = ss_sold_date_sk
 and s_store_sk  = ss_store_sk
 and s_state in
             ( select s_state
               from  (select s_state as s_state,
 			    rank() over ( partition by s_state order by sum(ss_net_profit) desc) as ranking
                      from   store_sales, store, date_dim
                      where  d_month_seq between 1212 and 1212+11
 			    and d_date_sk = ss_sold_date_sk
 			    and s_store_sk  = ss_store_sk
                      group by s_state
                     ) tmp1 
               where ranking <= 5
             )
 group by rollup(s_state,s_county)
 order by
   lochierarchy desc
  ,case when lochierarchy = 0 then s_state end
  ,rank_within_parent
 limit 100;

New:
select * from ( --added line
select 
    sum(ss_net_profit) as total_sum
   ,s_state
   ,s_county
   ,grouping(s_state)+grouping(s_county) as lochierarchy
   ,rank() over (
 	partition by grouping(s_state)+grouping(s_county),
 	case when grouping(s_county) = 0 then s_state end 
 	order by sum(ss_net_profit) desc) as rank_within_parent
 from
    store_sales
   ,date_dim       d1
   ,store
 where
    d1.d_month_seq between 1212 and 1212+11
 and d1.d_date_sk = ss_sold_date_sk
 and s_store_sk  = ss_store_sk
 and s_state in
             ( select s_state
               from  (select s_state as s_state,
 			    rank() over ( partition by s_state order by sum(ss_net_profit) desc) as ranking
                      from   store_sales, store, date_dim
                      where  d_month_seq between 1212 and 1212+11
 			    and d_date_sk = ss_sold_date_sk
 			    and s_store_sk  = ss_store_sk
                      group by s_state
                     ) tmp1 
               where ranking <= 5
             )
 group by rollup(s_state,s_county)
) AS sub --added line
 order by
   lochierarchy desc
  ,case when lochierarchy = 0 then s_state end
  ,rank_within_parent
 limit 100;

This was done on queries: 36, 70 and 86.
------------------------------------------------------------------------------------------
3. Query templates were modified to exclude columns not found in the query.

This was done on query: 30 (c_last_review_date_sk and ctr_total_return does not exists and are not used in the query.

------------------------------------------------------------------------------------------
4.  Added table aliases.
This was done on queries: 2, 14, and 23.

------------------------------------------------------------------------------------------


Data Qualification:
1)Create the Qualification Database, which has exactly the same structure as the Test Database and contains only 1GB of data.
2)Modify every template as it is described in the Appendix B chapter of the specification document. We changed every parameter with the right one.
The produced templated can be found in v2.11.0rc2/qualification_query_templates/ directory.
3)Run the dsqgen program with the parameter -QUALIFY Y in order to get the right permutation of the queries.
Command to be executed: "./dsqgen -input ../qualification_query_templates/templates.lst -directory ../qualification_query_templates/ -dialect ../query_templates/netezza -output_dir ../produced_query/ -QUALIFY Y"
The above program produced a file that contains all the 99 sql queries that will be used for the validation phase.
4)We execure every one of these queries and we save each output to a file named "queryX".
5)We compare every file we produced in the previous step with the equivalent file that exists in the v2.11.0rc2/answer_sets directory.
[Analyze here how our program works]

Data Population:
1)Create csv files using ...
2)Remove the last "|" from every csv files using "\|$" expression (Search Mode: Regular expression) and [Replace All in All Opened Documents] command in Notepad++
3)Give right permission to the directory that contains the csv files, in order to be accessible by pgAdmin
4)Run [insert_dataset_to_db.sql] script in order to insert data from csv into the database. Here the Copy function of Postgresql is used.
