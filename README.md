## Where is Vincey?

### About the project
I built an R Shiny app that let people know where I was when I was travelling around Europe in Summer 2017. You can view the app [here](http://whereis.vinceyau.me).

### Data
I used Excel and VLOOKUPs to create a .csv file with the date and location latitude and longitude. This became the data source for the app.

### How to deploy or build your own
To set up the app, browse to where you would like to keep your code locally, then run the following in your terminal.
```
git clone git@github.com:invinceyble/where-is.git
R -e "shiny::runApp('app.R')"
```

To customise the data to yours, copy the file ```data/data.csv``` and edit each of the columns:

date | country | city | lat | long
--- |---| ---| ---| ---

Then run the app in R or RStudio.

#### Sharing it online
There's a few ways to deploy the app online. I recommend using [shinyapps.io](https://www.shinyapps.io).
