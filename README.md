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
