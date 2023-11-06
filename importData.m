%% Import data from spreadsheet
%% Set up the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 3);

% Specify sheet and range
opts.Sheet = "PRICE_AND_DEMAND_202010_VIC1";
opts.DataRange = "A2:C227761";

% Specify column names and types
opts.VariableNames = ["SETTLEMENTDATE", "TOTALDEMAND", "PRICE"];
opts.VariableTypes = ["datetime", "double", "double"];

% Import the data
DemandPriceData = readtable("Demand_Price_Data.xlsx", opts, "UseExcel", false);

%% Clear temporary variables
clear opts
