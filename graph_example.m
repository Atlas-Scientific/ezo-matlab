%% Copyright 2016 Atlas Scientific LLC.


module = EZO_PH('COM3'); % change to any supported circuit

time = now;
data = 0;

figureHandle = figure('NumberTitle','off',...
    'Name','Voltage Characteristics',...
    'Visible','off');

% Set axes
axesHandle = axes('Parent',figureHandle,...
    'YGrid','on','XGrid','on');

hold on;

plotHandle = plot(axesHandle,time,0,'Marker','.','LineWidth',1);

xlim(axesHandle,[min(time) max(time+0.001)]);

% Create xlabel
xlabel('Time','FontWeight','bold','FontSize',14);

% Create ylabel
ylabel('Sensor Data','FontWeight','bold','FontSize',14);

% Create title
title('Sensor Graph','FontSize',15);

count = 1;

while true
    time(count) = datenum(clock); 

    data(count) = read(module);
    set(plotHandle,'YData',data,'XData',time);
    set(figureHandle,'Visible','on');
    datetick('x','mm/DD HH:MM');
    count = count +1;
end