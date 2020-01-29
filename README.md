# BrainyYack

## create rails application

Given we have two models, Article and Story. Article has name, text and type (like blog post, facebook post or tweet).
Story has name and contains one or more articles.

There should be a single API endpoint that returns list of articles. Basing on query params list could be:

 - searched by article name or text
 - sorted on any field
 - grouped by any of field
 - grouped by story with totals:
   - article count
   - article type count
   - last created article
   

## add UI

Display the data using React.JS and Mobx.

UI should consist of:

- table of articles with sort controls in column headers
- select box with options to group by
- search input field


## add realtime

Let's suppose there are two users are on the same page and if one of them will create/delete/update article, second user should see these changes in real time.


## deploy it

Application should be up and running on the server. Please provide SSH access to it.


# Deployed to

https://brainy-yack.herokuapp.com/

as I us Heroku for hosting, to get ssh access, please send me email address which used as Heroku login

I implement English full text search, using Postgres feature, so search will work in little bit different way as usual.
