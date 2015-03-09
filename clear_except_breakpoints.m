tmp = dbstatus;
save('tmpBreakpointsFile.tmp.mat', 'tmp');
clear all;
close all;
load('tmpBreakpointsFile.tmp.mat');
dbstop(tmp);
delete('tmpBreakpointsFile.tmp.mat');
clearvars tmp;