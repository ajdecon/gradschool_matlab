function cefit_4C(crop_ce)
%CEFIT_4C    Create plot of datasets and fits
%   CEFIT_4C(CROP_CE)
%   Creates a plot, similar to the plot in the main curve fitting
%   window, using the data that you provide as input.  You can
%   apply this function to the same data you used with cftool
%   or with different data.  You may want to edit the function to
%   customize the code and this help message.
%
%   Number of datasets:  1
%   Number of fits:  3

 
% Data from dataset "crop_ce":
%    Y = crop_ce:
%    Unweighted
%
% This function was automatically generated on 19-Mar-2010 14:16:24

% Set up figure to receive datasets and fits
f_ = clf;
figure(f_);
set(f_,'Units','Pixels','Position',[469 119 680 477]);
legh_ = []; legt_ = {};   % handles and text for legend
xlim_ = [Inf -Inf];       % limits of x axis
ax_ = axes;
set(ax_,'Units','normalized','OuterPosition',[0 0 1 1]);
set(ax_,'Box','on');
axes(ax_); hold on;

 
% --- Plot data originally in dataset "crop_ce"
x_1 = (1:numel(crop_ce))';
crop_ce = crop_ce(:);
h_ = line(x_1,crop_ce,'Parent',ax_,'Color',[0.333333 0 0.666667],...
     'LineStyle','none', 'LineWidth',1,...
     'Marker','square', 'MarkerSize',6);
xlim_(1) = min(xlim_(1),min(x_1));
xlim_(2) = max(xlim_(2),max(x_1));
legh_(end+1) = h_;
legt_{end+1} = 'crop_ce';

% Nudge axis limits beyond data limits
if all(isfinite(xlim_))
   xlim_ = xlim_ + [-1 1] * 0.01 * diff(xlim_);
   set(ax_,'XLim',xlim_)
else
    set(ax_, 'XLim',[0.73999999999999999, 27.260000000000002]);
end


% --- Create fit "fit 1"
ok_ = isfinite(x_1) & isfinite(crop_ce);
if ~all( ok_ )
    warning( 'GenerateMFile:IgnoringNansAndInfs', ...
        'Ignoring NaNs and Infs in data' );
end
st_ = [1.9645708521867939 -0.095342743493336671 -1.4253374742810385 -0.44632821275186407 ];
ft_ = fittype('exp2');

% Fit this model using new data
cf_ = fit(x_1(ok_),crop_ce(ok_),ft_,'Startpoint',st_);

% Or use coefficients from the original fit:
if 0
   cv_ = { 83655.532131371612, -0.13866236586278774, -83654.65044407727, -0.13866501234521542};
   cf_ = cfit(ft_,cv_{:});
end

% Plot this fit
h_ = plot(cf_,'fit',0.95);
legend off;  % turn off legend from plot method call
set(h_(1),'Color',[1 0 0],...
     'LineStyle','-', 'LineWidth',2,...
     'Marker','none', 'MarkerSize',6);
legh_(end+1) = h_(1);
legt_{end+1} = 'fit 1';

% --- Create fit "fit 2"
ok_ = isfinite(x_1) & isfinite(crop_ce);
if ~all( ok_ )
    warning( 'GenerateMFile:IgnoringNansAndInfs', ...
        'Ignoring NaNs and Infs in data' );
end
st_ = [0.58092756599744022 -0.10000000000000001 0.9735777080550454 -0.10000000000000001 ];
ft_ = fittype('a*x*exp(b*x)+c*x*exp(d*x)',...
     'dependent',{'y'},'independent',{'x'},...
     'coefficients',{'a', 'b', 'c', 'd'});

% Fit this model using new data
cf_ = fit(x_1(ok_),crop_ce(ok_),ft_,'Startpoint',st_);

% Or use coefficients from the original fit:
if 0
   cv_ = { 1.8786802379116481, -1.0844933225167586, 0.41359663918692008, -0.16344125490294698};
   cf_ = cfit(ft_,cv_{:});
end

% Plot this fit
h_ = plot(cf_,'fit',0.95);
legend off;  % turn off legend from plot method call
set(h_(1),'Color',[0 0 1],...
     'LineStyle','-', 'LineWidth',2,...
     'Marker','none', 'MarkerSize',6);
legh_(end+1) = h_(1);
legt_{end+1} = 'fit 2';

% --- Create fit "fit 2 copy 1"
ok_ = isfinite(x_1) & isfinite(crop_ce);
if ~all( ok_ )
    warning( 'GenerateMFile:IgnoringNansAndInfs', ...
        'Ignoring NaNs and Infs in data' );
end
st_ = [0.5411802150500159 -0.10000000000000001 ];
ft_ = fittype('a*x*exp(b*x)',...
     'dependent',{'y'},'independent',{'x'},...
     'coefficients',{'a', 'b'});

% Fit this model using new data
cf_ = fit(x_1(ok_),crop_ce(ok_),ft_,'Startpoint',st_);

% Or use coefficients from the original fit:
if 0
   cv_ = { 0.5583592834424036, -0.18900594409469085};
   cf_ = cfit(ft_,cv_{:});
end

% Plot this fit
h_ = plot(cf_,'fit',0.95);
legend off;  % turn off legend from plot method call
set(h_(1),'Color',[0.666667 0.333333 0],...
     'LineStyle','-', 'LineWidth',2,...
     'Marker','none', 'MarkerSize',6);
legh_(end+1) = h_(1);
legt_{end+1} = 'fit 2 copy 1';

% Done plotting data and fits.  Now finish up loose ends.
hold off;
leginfo_ = {'Orientation', 'vertical'}; 
h_ = legend(ax_,legh_,legt_,leginfo_{:}); % create and reposition legend
set(h_,'Units','normalized');
t_ = get(h_,'Position');
t_(1:2) = [0.640931,0.726066];
set(h_,'Interpreter','none','Position',t_);
xlabel(ax_,'');               % remove x label
ylabel(ax_,'');               % remove y label
