# Movie_Ratings

## Project Overview
This project involves designing an Entity-Relationship (ER) model and developing a MySQL database to store and analyze a dataset related to movie ratings, tagging activities, and genome scores. The project is divided into two main parts:

**Part 1:** Developing a physical ER model of the dataset, focusing on correct database design and normalization principles.
**Part 2:** Using the provided ER model to create tables, set up constraints within a normalized relational database, and populate the database with the provided dataset.

## Dataset
The client has provided three datasets located in flat CSV files, which are as follows:

**ratings.csv:** Contains user ratings for movies.
**tagged.csv:** Contains free-text movie-tagging activities.
**genome-scores.csv:** Contains data related to how strongly movies exhibit particular properties as represented by tag relevance scores.

**Note on Dataset Upload**
Given the extensive size of the datasets, they will not be uploaded to the repository. 

## Schema Design

The designed schema consists of several tables as follows:

users
movies
genres
tags
movie_genome
tagged
ratings
Detailed SQL DDL statements to create these tables and establish constraints are included in the .sql files provided within this project.

## Deliverables

**Part 1:** A Word file containing the image of the designed ER model, developed using a diagramming tool such as Lucidchart or draw.io.

**Part 2:** A .sql script file containing DDL and DML SQL statements used to create the tables and insert data into them.

## Data Cleaning Challenges
Working with the given dataset was like untangling a ball of yarn! Here's what we faced:

**Mixed Data Types:** Imagine expecting a column of numbers and finding words mixed in. That's what happened with our data. We had to go in and make sure each column had just one type of data.

**Unexpected Characters:** In some columns, where we expected years (like '1995' or '2005'), we found weird characters. We had to carefully look through and fix these.

**Repeating Data:** Some rows in our data were like echoes – they just repeated what was already there. We had to identify these duplicates and remove them to keep our data neat and tidy.

**Database Drama:** When we tried to move our cleaned-up data into a MySQL database, we ran into some technical hiccups. It's like trying to fit a square peg in a round hole! We had to break our data into smaller pieces and then insert them bit by bit.

In simple words, cleaning this data was a journey, but step by step, we made it neat and ready to use!
