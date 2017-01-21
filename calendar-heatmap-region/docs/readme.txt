Calendar Heatmap Plugin
=======================

This is a region plugin used to display a yearly calendar heatmap, inspired by the GitHub contribution chart.

Installation:
- Install the plugin into APEX
- Compile the accompanying PL/SQL package specification and body into the database

Usage:
- Add a region to your page and set the region type to "Calendar Heatmap"
- Set the region source to an SQL query that returns one row per day. The first column must be a date and the second column should be a numeric value. Since the region is intended to show the data for the last year (last 365 days), the query should restrict its results accordingly.


For more details, see http://ora-00001.blogspot.com/2017/01/apex-plugin-calendar-heatmap-region.html
