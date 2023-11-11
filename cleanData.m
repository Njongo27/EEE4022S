% Demand load cleaning and formatting

% Fill outliers
[newTable,outlierIndices] = filloutliers(DemandPriceData,"linear", ...
    "movmedian",1000,"ThresholdFactor",1.5,"DataVariables","TOTALDEMAND");
% Uncomment to display results
% figure
% plot(DemandPriceData.TOTALDEMAND,"SeriesIndex",6,"DisplayName","Input data")
% hold on
% plot(newTable.TOTALDEMAND,"SeriesIndex",1,"LineWidth",1.5, ...
%     "DisplayName","Cleaned data")
% 
% hold off
% title("Number of outliers cleaned: " + nnz(outlierIndices(:,2)))
% legend
% ylabel("TOTALDEMAND")

% Electricity price cleaning

% Fill outliers
[newTable1,outlierIndices2] = filloutliers(newTable,"linear","movmedian",2500, ...
    "ThresholdFactor",0.25,"DataVariables","PRICE");

% Uncomment to display results
% figure
% plot(newTable.PRICE,"SeriesIndex",6,"DisplayName","Input data")
% hold on
% plot(newTable1.PRICE,"SeriesIndex",1,"LineWidth",1.5, ...
%     "DisplayName","Cleaned data")
% 
% hold off
% title("Number of outliers cleaned: " + nnz(outlierIndices2(:,3)))
% legend
% ylabel("PRICE")

% Convert table to timetable for retiming
timeTable = table2timetable(newTable1);

% Retime timetable
newTimetable = retime(timeTable,"regular","linear","TimeStep",minutes(5));

% Convert timetable back to table
cleanTable = timetable2table(newTimetable);

formData = cleanTable(:,{'SETTLEMENTDATE','TOTALDEMAND','PRICE'});
formData.Properties.VariableNames(1:3) = {'Time','Load','Price'};

% Create Predictors
formData.Hour = formData.Time.Hour;
formData.Month = formData.Time.Month;
formData.Year = formData.Time.Year;
formData.DayOfWeek = weekday(formData.Time);
formData.isWeekend = isweekend(formData.Time);
