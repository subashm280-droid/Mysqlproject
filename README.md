# Mysqlproject
A SQL project focused on analyzing samplesuperstore sales data using MySQL. Includes data filtering, sorting, aggregation, joins, subqueries, and sales and profit analysis to gain meaningful business insights.

## Sample Superstore final project

The 25 requested analysis queries are in [`sql/sample_superstore_analysis.sql`](sql/sample_superstore_analysis.sql). Import the Sample Superstore CSV into the `Samplesuperstore` schema as a table named `superstore`, retaining the standard CSV column headers, then run the script in MySQL Workbench. The queries use MySQL 8.0 window functions and CTEs.

Query 18 uses example sales bands of High (at least 500), Medium (100 to under 500), and Low (under 100). Query 25 defines high-sales Sub-Categories as those whose total Sales exceed the average total Sales across all Sub-Categories; it returns only those with negative total Profit.
