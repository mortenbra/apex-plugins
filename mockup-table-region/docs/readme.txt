Mockup Table Region
===================

Inspired by the Data Grid control in Balsamiq (https://docs.balsamiq.com/desktop/datagrids/), this region plugin allows you to quickly mock up table data on an Apex page without having to create "real" database tables and write queries.

Instead, you just place the region and enter some delimited data, which will be parsed and displayed as table data. You can also copy and paste data directly from an Excel spreadsheet into the region source; if you do this you should set the "CSV Delimiter" attribute of the plugin to "\t" (since Excel data is delimited by tabs).

You can specify up to 15 columns (but you can easily modify the plugin source code to support more columns).

Special Symbols
---------------
You can use the following symbols in your source data:

() empty radio box
(x) selected radio box
(*) selected radio box
[] empty checkbox
[x] selected checkbox
[*] selected checkbox
[some text] select list (dropdown) with specified text
{} empty text box
{some text} text box
<999> link to specified Apex page number
<url> any other link (as specified by url)

Sample Data
-----------

select,product code,product name,price,supplier,sold out,shipping,edit
(),1,Iphone 8,1000,Apple,[x],[Express],<99>
(*),2,WinPho,500,Microsoft,[],[Standard],<99>
(),3,Android XE,250,Google,[x],[-Not specified-],<99>

Requirements
------------
The plugin depends on the CSV_UTIL_PKG from the Alexandria PL/SQL Utility Library (https://github.com/mortenbra/alexandria-plsql-utils) to parse the region source. This package (part of the Alexandria core) must be installed in the database for the plugin to work.