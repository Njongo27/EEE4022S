% Training data, 80%
dataLearn = floor(0.8*numel(formData.Load));
dataIn = formData.Load(1:dataLearn);

% Testing data, 20%
dataOut = formData.Load(1+dataLearn:end);

% X and Y values for training and testing
xIn = dataIn(1:end-1)';
yIn = formData.Load(2:dataLearn)';

xOut = dataOut(1:end-1)';
yOut = dataOut(2:end)';

% Network Training
fnnet = fitnet(10,'trainbr');
fnnet = train(fnnet,xIn,yIn);
yy = fnnet(xOut);
rnnRMSE = perform(fnnet,yy,yOut)/10^3;
plot(yOut, 'b', 'DisplayName', 'Actual');
hold on
plot(yy, 'r', 'DisplayName', 'Forecasted');
xlabel('Time (no. of 5-minute intervals');
ylabel('Load (kWh) ');
title('Actual vs Forecasted Load');
