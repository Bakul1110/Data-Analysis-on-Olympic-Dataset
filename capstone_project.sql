--                                                Capstone Project on Olympics Data Analysis                                             --

-- 1. Given is the dataset regarding the performance of different olympic players. ---
-- 2. It is giving us information about how many gold medals, silver medals and bronze medals have been won by these players. ---
-- 3. The dataset also contains information about the countries they are representing, their age, and the date on which they won the medal.--
-- 4. The dataset also gives information about the sports with which the player is associated with . --

create database capstone_olympics;   #database created which will contain the table having all the information
use  capstone_olympics;              #database is all set to be used
SELECT * FROM olympics_data;    #selecting the information from the table

-- Now I will look at whether the table is normalized or not.--
-- I will check here for 3 normal forms which are 1nf, 2nf, 3nf ---
-- 1nf says that the If a relation contains a composite or multi-valued attribute,
-- it violates the first normal form, or the relation is in first normal form 
-- if it does not contain any composite or multi-valued attribute.
-- A relation is in first normal form if every attribute in that relation is singled valued attribute. 

-- So if we look at the table with that perspective then we can clearly see that the table is in 1st normal form.

-- Now I will check for the second normal form which states that :
-- the relation which contains a composite primary key in order to be in 2NF should not contain any partial dependency.
----- Partial dependency occurs when any non prime attribute is dependent on any of the proper subsets of the candidate key.


-- On looking at the table it can be concluded that none of the attributed can be considered as primary key.
-- As each column has reapeted values none of the columns have unique value.
-- I can now add the Id column that will represent each record
ALTER TABLE `capstone_olympics`.`olympics_data` 
ADD COLUMN `record_id` INT NOT NULL AUTO_INCREMENT AFTER `Date_given`,
ADD PRIMARY KEY (`record_id`);
select * from olympics_data;
 
create table Dates select distinct Date_Given , year from capstone_olympics.olympics;
select * from dates;
# Now I will create a table player and will fetch details about player such as name, country and age
create table player select distinct Name from capstone_olympics.olympics_data;
select * from player;

#Now I will create another table named sports
create table sports select  distinct sports from capstone_olympics.olympics_data;
select * from sports;
#now I will create another table medal having all the details of medals in it alomng with player_id so that when we need data from both tables
#we can join these tables based on common column player_id
create table medal select player_id, gold_medal, silver_medal, bronze_medal, total_medal from olympics_data join player on olympics_data.name = player.name; #separate medal table created
#Another table player_age is being created  having player_id, age and date_id in it
#so if we want to know who has won which medal we can simply join date and player_age table on the basis of date_id column and then can fetch data from them
create table player_age select player_id, age , date_id from dates join olympics_data on dates.Date_Given = olympics_data.Date_Given
join player on olympics_data.name = player.name;
# Now if I need data from both tables then in order to do that I need to create a connection between the two tables
# I will do this by creating a table having playerid and sportsid
create table sports_player select distinct player_id, sports_id from player join olympics_data on player.name = olympics_data.name 
join sports on olympics_data.sports = sports.sports;
# Now I also need to create a country table as well
create table country select distinct country from olympics_data;
create table olympic_country select distinct country, player_id from player join olympics_data on player.name = olympics_data.name;
#Now another table country_player will be created so as to add country and sports id into it.
create table player_country select distinct player_id, country_id from player join olympics_data on olympics_data.name = player.name join country on olympics_data.country = country.country;




-----------------------------------------------------------------------------------------------------------------
select* from olympics;
# 2).Find the average number of medals won by each country.
select avg(total_medal), country  from olympics_data group by country;

# 3).Display the countries and the number of gold medals they have won in decreasing order
select country, sum(total_medal) from olympics_data group by country order by sum(total_medal) desc;

# 4). Display the list of people with the medals they have won according to their their age
select distinct age from olympics_data; #here we got the distinct ages
-- Now will get the people with medals according to their age so for this we will first select only those records where the number of medals won is not zero.
select name, age, silver_medal, gold_medal, bronze_medal, total_medal from olympics_data  group by age order by age desc;

#5). Which country has won the most number of medals (cumulative).
select distinct country, sum(total_medal)  over (partition by country) as cumulative_medal from olympics_data order by cumulative_medal desc;
# United States Has the most number of medals on a cumulative basis
select country, sum(total_medal) from olympics_data group by country order by total_medal desc;
# using this query too we will be getting the same result



